pipeline {
  agent any
  tools { nodejs 'NodeJS_22' }

  environment {
    AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    AWS_DEFAULT_REGION = "eu-central-1"

    TF_VAR_db_username = credentials('db_username')
    TF_VAR_db_password = credentials('db_password')
    TF_VAR_allowed_ssh_cidrs = credentials('allowed-ssh-cidrs')
    TF_VAR_edge_gateway_private_key = credentials('edge_gateway_private_key')
    TF_VAR_edge_gateway_public_key  = credentials('edge_gateway_public_key')
    TF_VAR_backend_private_key      = credentials('backend_private_key')
    TF_VAR_backend_public_key       = credentials('backend_public_key')
    TF_VAR_frontend_private_key     = credentials('frontend_private_key')
    TF_VAR_frontend_public_key      = credentials('frontend_public_key')
  }

  stages {

    stage('Init Workspace') {
      steps {
        cleanWs()
        sh 'mkdir -p backend_terraform backend_ansible backend_app frontend'
      }
    }

    stage('Checkout Terraform') {
      steps {
        dir('backend_terraform') {
          git branch: 'terraform', url: 'https://github.com/artur-vol/provedcode-backend-artur-vol.git'
        }
      }
    }

    stage('Checkout Ansible') {
      steps {
        dir('backend_ansible') {
          git branch: 'ansible', url: 'https://github.com/artur-vol/provedcode-backend-artur-vol.git'
        }
      }
    }

    stage('Checkout Backend') {
      steps {
        dir('backend_app') {
          git branch: 'main', url: 'https://github.com/artur-vol/provedcode-backend-artur-vol.git'
        }
      }
    }

    stage('Checkout Frontend') {
      steps {
        dir('frontend') {
          git branch: 'main', url: 'https://github.com/artur-vol/provedcode-frontend-artur-vol.git'
        }
      }
    }

    stage('Terraform') {
      steps {
        dir('backend_terraform/terraform') {
          sh 'terraform init -input=false -no-color'
          sh 'terraform validate -no-color'
          sh 'terraform plan -input=false -no-color -out=tfplan'
          input message: 'Apply Terraform changes?', ok: 'Apply'
          sh 'terraform apply -no-color -input=false tfplan'
          sh 'terraform output -json > tf_output.json'
        }
        stash name: 'tf_outputs', includes: 'backend_terraform/terraform/tf_output.json'
      }
    }

    stage('Build Backend') {
      steps {
        dir('backend_app') {
          sh 'chmod +x ./mvnw'
          sh './mvnw -DskipTests=false test'
          sh './mvnw clean package -DskipTests'
          archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
      }
    }

    stage('Upload Backend to S3') {
      steps {
        unstash 'tf_outputs'
        script {
          def tf     = readJSON file: "${env.WORKSPACE}/backend_terraform/terraform/tf_output.json"
          def bucket_name = tf.bucket.value
          sh """
            aws s3 cp backend_app/target/*.jar s3://${bucket_name}/backend/app.jar --region ${AWS_DEFAULT_REGION}
          """
        }
      }
    }

    stage('Build Frontend') {
      steps {
        unstash 'tf_outputs'
        script {
          def tf   = readJSON file: "${env.WORKSPACE}/backend_terraform/terraform/tf_output.json"
          def edge = tf.edge_gateway_public_ip.value
          dir('frontend') {
            sh 'npm ci --no-audit --no-fund'
            sh """
              REACT_APP_BASE_URL="http://${edge}" npm run build
            """
            sh 'tar -cvf build.tar build/'
            archiveArtifacts artifacts: 'build.tar', fingerprint: true
          }
        }
      }
    }

    stage('Upload Frontend to S3') {
      steps {
        unstash 'tf_outputs'
        script {
          def tf     = readJSON file: "${env.WORKSPACE}/backend_terraform/terraform/tf_output.json"
          def bucket_name = tf.bucket.value
          sh """
            aws s3 cp frontend/build.tar s3://${bucket_name}/frontend/build.tar --region ${AWS_DEFAULT_REGION}
          """
        }
      }
    }

    stage('Prepare Ansible') {
      steps {
        unstash 'tf_outputs'
        withCredentials([
          sshUserPrivateKey(credentialsId: 'edge_gateway_private_key', keyFileVariable: 'EDGE_KEY'),
          sshUserPrivateKey(credentialsId: 'backend_private_key',     keyFileVariable: 'BACKEND_KEY'),
          sshUserPrivateKey(credentialsId: 'frontend_private_key',    keyFileVariable: 'FRONTEND_KEY')
        ]) {
          script {
            sh '''
              mkdir -p "${WORKSPACE}/.ssh"
              chmod 700 "${WORKSPACE}/.ssh"
              cp "${EDGE_KEY}"     "${WORKSPACE}/.ssh/edge_gateway_key.pem"
              cp "${BACKEND_KEY}"  "${WORKSPACE}/.ssh/backend_key.pem"
              cp "${FRONTEND_KEY}" "${WORKSPACE}/.ssh/frontend_key.pem"
              chmod 600 "${WORKSPACE}"/.ssh/*.pem
            '''

            def tf = readJSON file: "${env.WORKSPACE}/backend_terraform/terraform/tf_output.json"
            def bastionIp  = tf.edge_gateway_public_ip.value
            def backendIp  = tf.backend_private_ip.value
            def frontendIp = tf.frontend_private_ip.value

            def inv = """\
    bastion ansible_host=${bastionIp} ansible_user=ubuntu ansible_ssh_private_key_file=${WORKSPACE}/.ssh/edge_gateway_key.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

    backend ansible_host=${backendIp} ansible_user=ubuntu ansible_ssh_private_key_file=${WORKSPACE}/.ssh/backend_key.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand="ssh -i ${WORKSPACE}/.ssh/edge_gateway_key.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p -q ubuntu@${bastionIp}"'

    frontend ansible_host=${frontendIp} ansible_user=ubuntu ansible_ssh_private_key_file=${WORKSPACE}/.ssh/frontend_key.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand="ssh -i ${WORKSPACE}/.ssh/edge_gateway_key.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p -q ubuntu@${bastionIp}"'
    """
            writeFile file: "${env.WORKSPACE}/inventory.ini", text: inv
            sh 'ansible all -i ${WORKSPACE}/inventory.ini -m ping -o -e ANSIBLE_NOCOLOR=True'
          }
        }
      }
    }
    //
    // stage('Ansible: run playbook') {
    //   steps {
    //     dir('backend_ansible/ansible') {
    //       sh 'ansible-playbook -i ${WORKSPACE}/inventory.ini site.yml -e ANSIBLE_NOCOLOR=True'
    //     }
    //   }
    // }
    //
  }
}

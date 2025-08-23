pipeline {

  agent any

  tools {
    nodejs 'NodeJS_22'
  }

  environment {
    AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    AWS_DEFAULT_REGION = "eu-central-1"

    TF_VAR_db_username = credentials('db_username')
    TF_VAR_db_password = credentials('db_password')

    TF_VAR_allowed_ssh_cidrs = credentials('allowed-ssh-cidrs')

    TF_VAR_edge_gateway_private_key = credentials('edge_gateway_private_key')
    TF_VAR_edge_gateway_public_key = credentials('edge_gateway_private_key')

    TF_VAR_backend_private_key = credentials('backend_private_key')
    TF_VAR_backend_public_key = credentials('backend_private_key')

    TF_VAR_frontend_private_key = credentials('frontend_private_key')
    TF_VAR_frontend_public_key = credentials('frontend_private_key')
  }

  stages {

    stage('Terraform') {
      stages {
        stage('Checkout') {
          steps {
            git branch: 'terraform', url: 'https://github.com/artur-vol/provedcode-backend-artur-vol.git'
          }
        }
        stage('Terraform Init') {
          steps {
            dir('terraform') {
              sh 'terraform init'
            }
          }
        }
        stage('Check Remote State') {
          steps {
            dir('terraform') {
              sh 'terraform state list'
            }
          }
        }
        stage('Terraform Plan') {
          steps {
            dir('terraform') {
              sh 'terraform plan -out=tfplan'
            }
          }
        }
        stage('Terraform Apply') {
          steps {
            input message: 'Apply Terraform changes?', ok: 'Yes, apply'
            dir('terraform') {
              sh 'terraform apply -auto-approve tfplan'
            }
          }
        }
      }
    }

    stage('Backend') {
      stages {
        stage('Checkout') {
          steps {
            git branch: 'main', url: 'https://github.com/artur-vol/provedcode-backend-artur-vol.git'
          }
        }
        stage('Configure Permissions') {
          steps {
            sh 'chmod +x ./mvnw'
          }
        }
        stage('Download Dependencies') {
          steps {
            sh './mvnw dependency:go-offline'
          }
        }
        stage('Test') {
          steps {
            sh './mvnw test'
          }
        }
        stage('Build') {
          steps {
            sh './mvnw clean package -DskipTests'
          }
          post {
            success {
              archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
          }
        }
      }
    }

    stage('Frontend') {
      stages {
        stage('Checkout Frontend Repo') {
          steps {
            git branch: 'main', url: 'https://github.com/artur-vol/provedcode-frontend-artur-vol.git'
          }
        }
        stage('Download Dependencies') {
          steps {
            sh 'npm ci'
          }
        }
        stage('Build Frontend') {
          steps {
            sh 'npm run build'
            sh 'tar -cvf "build.tar" build/'
          }
          post {
            success {
              archiveArtifacts artifacts: 'build.tar', fingerprint: true
            }
          }
        }
      }
    }

  }
}

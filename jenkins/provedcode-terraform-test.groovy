pipeline {
  agent any
  tools {
    nodejs 'NodeJS_22'
  }
  parameters {
    string(name: 'REGION', defaultValue: 'eu-central-1', description: 'AWS Region for deployment')
  }
  environment {
    AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    AWS_DEFAULT_REGION = "${params.REGION}"
  }
  stages {
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
      }
    }
  }

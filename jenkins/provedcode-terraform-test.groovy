pipeline {
    agent any
    parameters {
        string(name: 'REGION', defaultValue: 'eu-central-1', description: 'AWS Region for deployment')
    }
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION = "${params.REGION}"
    }
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



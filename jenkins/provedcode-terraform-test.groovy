pipeline {
  agent any

  parameters {

  }

  environment {
    AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    AWS_DEFAULT_REGION    = credentials('aws-region')
  }

  stages {

  }

}

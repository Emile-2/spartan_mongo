pipeline {
  agent any

  environment {
    IMAGE_NAME = "edspt/spartan_mongo:V1." + "$BUILD_NUMBER"
    DOCKER_CREDENTIALS = 'docker_hub_cred'
  }

  stages {
    stage('Cloning the project from GitHub'){
      steps {
        git branch :'main',
        url: 'https://github.com/Emile-2/spartan_mongo.git'
      }
    }

    stage('Build Docker image') {
      steps {
        script {
          DOCKER_IMAGE = docker.build IMAGE_NAME
        }
      }
    }

    stage('Push to dockerhub'){
      steps {
        script {
          docker.withRegistry('',DOCKER_CREDENTIALS){
            DOCKER_IMAGE.push()
          }
        }
      }
    }
  }
}
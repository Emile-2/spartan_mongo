pipeline {
  agent any

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
          DOCKER_IMAGE = docker.build 'edspt/spartan_mongo:latest'
        }
      }
    }

    stage('Push to dockerhub'){
      steps {
        script {
          docker.withRegistry('','docker_hub_cred'){
            DOCKER_IMAGE.push()
          }
        }
      }
    }
  }
}
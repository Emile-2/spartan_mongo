pipeline {
  agent any

  environment {
    IMAGE_NAME = "edspt/spartan_mongo:V1." + "$BUILD_NUMBER"
    DOCKER_CREDENTIALS = 'docker_hub_cred'
  }


  stages {
    stage('Cloning the project from GitHub'){
      steps {
        checkout([
            $class: 'GitSCM', branches: [[name: '*/main']],
            serRemoteConfigs: [[
              url: 'git@github.com:Emile-2/spartan_mongo.git',
              credentialsId: 'ssh_git_cred'
            ]]
          ])
      }
    }

    stage('Build Docker image') {
      steps {
        script {
          DOCKER_IMAGE = docker.build IMAGE_NAME
        }
      }
    }

    stage('Testing the Code'){
      steps{
        script {
          sh '''
            docker run $IMAGE_NAME pytest
          '''
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

    stage('Removing the Docker Image'){
     steps {
      sh "docker rmi $IMAGE_NAME"
      }
    }
  }
}
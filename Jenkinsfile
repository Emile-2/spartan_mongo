/* Step 1 is to pull my code from my github repo, set web hooks & set up pub/private keys to do this securely and automatically
   step 2 is to build it as a docker image
   step 3 is to run the image to test my code
   step 4 if my code/image passes its test then push to my dockerhub
   step 5 is to remove my code/image from jenkins
*/

pipeline {
  agent any

  environment {
  IMAGE_NAME = "edspt/spartan_mongo:V1.9" + "$BUILD_NUMBER"
  DOCKER_CREDENTIALS = 'docker_cred'

  }

  stages {
    stage('Cloning the project from GitHub'){
      steps {
          checkout([
            $class: 'GitSCM', branches: [[name:'*/main']],
            serRemoteConfigs: [[
              url: 'github@github.com:Emile-2/spartan_mongo.git'
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

    stage('Testing the Code') {
      steps {
        script {
          sh '''
            docker run --rm -v $PWD/test-results:/reports --workdir /app $IMAGE_NAME pytest -v --junitxml=/reports/results.xml

          '''
        }
      }
      post {
        always {
          junit testResults: '**/test-results/*.xml'
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        script {
          docker.withRegistry('',DOCKER_CREDENTIALS) {
            DOCKER_IMAGE.push()
          }
        }
      }
    }

    stage('Removing the Docker image') {
      steps {
        sh "docker rmi $IMAGE_NAME"
      }
    }
  }
}


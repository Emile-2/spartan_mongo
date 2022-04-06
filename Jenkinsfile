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
        docker.build 'edspt/spartan_mongo:latest'
        }
      }
    }
  }
}
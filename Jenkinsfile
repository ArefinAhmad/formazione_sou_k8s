pipeline {
  agent {
    label 'agent1'
  }

  environment {
    IMAGE_NAME = 'arefinahmad/flask-hello-world'
    GIT_COMMIT_SHORT = "${env.GIT_COMMIT[0..6]}"
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/ArefinAhmad/formazione_sou_k8s.git', branch: 'main'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          dockerImage = docker.build("${IMAGE_NAME}:${GIT_COMMIT_SHORT}")
        }
      }
    }

    stage('Push to DockerHub') {
      steps {
        withDockerRegistry([credentialsId: 'dockerhub-creds', url: '']) {
          script {
            dockerImage.push()
            dockerImage.push('latest')
          }
        }
      }
    }
  }

  post {
    success {
      echo "Build e push completati con successo!"
    }
    failure {
      echo "Qualcosa è andato storto."
    }
  }
}


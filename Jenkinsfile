pipeline {
  agent {
    label 'agent1'
  }

  environment {
    IMAGE_NAME = 'arefinahmad/flask-hello-world'
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/ArefinAhmad/formazione_sou_k8s.git', branch: 'main'
      }
    }

    stage('Determine Docker Tag') {
      steps {
        script {
          def commitSha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          def branchName = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
          echo "Git branch: ${branchName}"
          echo "Git commit: ${commitSha}"

          if (env.TAG_NAME) {
            dockerTag = env.TAG_NAME
          } else if (branchName == 'master') {
            dockerTag = 'latest'
          } else if (branchName == 'develop') {
            dockerTag = "develop-${commitSha}"
          } else {
            dockerTag = commitSha
          }

          echo "Docker image tag will be: ${dockerTag}"
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          dockerImage = docker.build("${IMAGE_NAME}:${dockerTag}")
        }
      }
    }

    stage('Login to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
          sh 'echo $DOCKER_HUB_PASSWORD | docker login -u $DOCKER_HUB_USERNAME --password-stdin'
        }
      }
    }

    stage('Push to DockerHub') {
      steps {
        withDockerRegistry([credentialsId: 'dockerhub-creds', url: '']) {
          script {
            dockerImage.push()
            // Solo se è il branch master, fai anche il push del tag 'latest'
            if (dockerTag != 'latest') {
              echo "Skipping 'latest' tag push since current tag is ${dockerTag}"
            } else {
              dockerImage.push('latest')
            }
          }
        }
      }
    }
  }

  post {
    success {
      echo "Build e push completati con successo con tag: ${dockerTag}"
    }
    failure {
      echo "Qualcosa è andato storto."
    }
  }
}
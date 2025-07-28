pipeline {
  agent {
    label 'agent1'
  }

  environment {
    IMAGE_NAME = 'arefinahmad/flask-hello-world'
  }

  parameters {
    string(name: 'TAG_NAME', defaultValue: '', description: 'Tag Git specifico da usare (opzionale)')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Determine Docker Tag') {
      steps {
        script {
          def dockerTag
          def commitSha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          def branchName = env.BRANCH_NAME ?: sh(script: "git name-rev --name-only HEAD", returnStdout: true).trim()

          echo "Branch rilevato: ${branchName}"
          echo "Commit SHA: ${commitSha}"

          if (params.TAG_NAME?.trim()) {
            dockerTag = params.TAG_NAME.trim()
          } else if (branchName == 'main' || branchName == 'master') {
            dockerTag = 'latest'
          } else if (branchName == 'develop') {
            dockerTag = "develop-${commitSha}"
          } else {
            dockerTag = commitSha
          }

          echo "Docker image tag: ${dockerTag}"

          // Salvo dockerTag come variabile di ambiente per usarlo negli stage successivi
          env.DOCKER_TAG = dockerTag
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          def dockerImage = docker.build("${IMAGE_NAME}:${env.DOCKER_TAG}")
          // salvo dockerImage in variabile globale per stage successivi
          env.DOCKER_IMAGE = "${IMAGE_NAME}:${env.DOCKER_TAG}"
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
            sh "docker push ${env.DOCKER_IMAGE}"

            if (env.DOCKER_TAG == 'latest') {
              echo "Pushing 'latest' tag"
              sh "docker push ${IMAGE_NAME}:latest"
            } else {
              echo "Skipping 'latest' tag push since current tag is ${env.DOCKER_TAG}"
            }
          }
        }
      }
    }
  }

  post {
    success {
      echo "Build e push completati con successo con tag: ${env.DOCKER_TAG}"
    }
    failure {
      echo "Qualcosa è andato storto."
    }
  }
}

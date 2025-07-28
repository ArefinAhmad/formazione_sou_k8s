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
        git url: 'https://github.com/ArefinAhmad/formazione_sou_k8s.git', branch: "${env.BRANCH_NAME ?: 'main'}"
      }
    }

    stage('Determine Docker Tag') {
      steps {
        script {
          def commitSha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          def branchName = env.BRANCH_NAME ?: sh(script: "git name-rev --name-only HEAD", returnStdout: true).trim()

          echo "Branch rilevato: ${branchName}"
          echo "Commit SHA: ${commitSha}"

          if (params.TAG_NAME?.trim()) {
            dockerTag = params.TAG_NAME
          } else if (branchName == 'main' || branchName == 'master') {
            dockerTag = 'latest'
          } else if (branchName == 'develop') {
            dockerTag = "develop-${commitSha}"
          } else {
            dockerTag = commitSha
          }

          echo "Docker image tag: ${dockerTag}"
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

            if (dockerTag == 'latest') {
              echo "Pushing 'latest' tag"
              dockerImage.push('latest')
            } else {
              echo "Skipping 'latest' tag push since current tag is ${dockerTag}"
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


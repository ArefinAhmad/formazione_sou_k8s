
def dockerTag = ''
def dockerImage

pipeline {
  agent {
    label 'agent1'
  }

  parameters {
    string(name: 'TAG_NAME', defaultValue: '', description: 'Inserisci un tag git esistente (es. v1.0.0) oppure lascia vuoto per usare il branch main')
  }

  environment {
    IMAGE_NAME = 'arefinahmad/flask-hello-world'
  }
  
    
  stages {

    stage('Checkout') {
      steps {
        script {
          if (params.TAG_NAME?.trim()) {
            echo "Controllo se il tag '${params.TAG_NAME}' esiste..."
            def tagExists = sh(script: "git ls-remote --tags origin refs/tags/${params.TAG_NAME}", returnStatus: true) == 0
            if (!tagExists) {
              error "Il tag '${params.TAG_NAME}' non esiste nel repository remoto!"
            }

            echo "Il tag esiste. Eseguo checkout di ${params.TAG_NAME}..."
            checkout([$class: 'GitSCM',
              branches: [[name: "*/${env.BRANCH_NAME}"]],
              userRemoteConfigs: [[url: 'https://github.com/ArefinAhmad/formazione_sou_k8s.git']]
            ])
          } 
        }
      }
    }

    stage('Determine Docker Tag') {
      steps {
        script {
          def commitSha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          def branchName = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
              
          echo "Git branch: ${branchName}"
          echo "Git commit: ${commitSha}"

          if (params.TAG_NAME?.trim()) {
            dockerTag = params.TAG_NAME
          } else if (branchName == 'main' || branchName == 'master') {
            dockerTag = 'latest'
          } else if (branchName == 'develop') {
            dockerTag = "develop-${commitSha}"
          } else {
            dockerTag = commitSha
          }

          echo "Docker image tag sarà: ${dockerTag}"
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
            if (dockerTag != 'latest') {
              echo "Immagine con tag ${dockerTag} pushata!"
            } else {
              echo "Push anche del tag 'latest'"
              dockerImage.push('latest')
            }
          }
        }
      }
    }
  }

  post {
    success {
      echo "Build e push completati con successo! Docker tag: ${dockerTag}"
    }
    failure {
      echo "Qualcosa è andato storto nella pipeline."
    }
  }
}

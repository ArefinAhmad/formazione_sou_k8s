pipeline {
    agent { label 'docker' }

    environment {
        DOCKER_IMAGE = 'arefinahmad/flask-app-example'
        REGISTRY_CREDENTIALS = 'dockerhub-creds'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/ArefinAhmad/formazione_sou_k8s.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def tag = 'latest'
                    if (env.GIT_BRANCH ==~ /origin\/tags\/.*/) {
                        tag = env.GIT_BRANCH.replaceFirst(/^origin\/tags\//, '')
                    } else if (env.GIT_BRANCH == 'origin/develop') {
                        tag = "develop-${env.GIT_COMMIT.take(7)}"
                    }

                    docker.build("${DOCKER_IMAGE}:${tag}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    def tag = 'latest'
                    if (env.GIT_BRANCH ==~ /origin\/tags\/.*/) {
                        tag = env.GIT_BRANCH.replaceFirst(/^origin\/tags\//, '')
                    } else if (env.GIT_BRANCH == 'origin/develop') {
                        tag = "develop-${env.GIT_COMMIT.take(7)}"
                    }

                    docker.withRegistry('https://index.docker.io/v1/', REGISTRY_CREDENTIALS) {
                        docker.image("${DOCKER_IMAGE}:${tag}").push()
                    }
                }
            }
        }
    }
}

pipeline {
    agent any

    environment {
        IMAGE_NAME = 'yourdockerhubusername/flask-hello'
        IMAGE_TAG = 'v1'
        REGISTRY_CREDENTIALS_ID = 'dockerhub-credentials' // Jenkins credenziali con username e password DockerHub
        DOCKER_REGISTRY = 'https://index.docker.io/v1/'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry("${DOCKER_REGISTRY}", "${REGISTRY_CREDENTIALS_ID}") {
                        def image = docker.image("${IMAGE_NAME}:${IMAGE_TAG}")
                        image.push()
                        image.push("latest")
                    }
                }
            }
        }

        stage('Cleanup local images') {
            steps {
                sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"
                sh "docker rmi ${IMAGE_NAME}:latest || true"
            }
        }
    }
}

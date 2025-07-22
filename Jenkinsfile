pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials') // Jenkins secret ID
        DOCKERHUB_USERNAME = 'arefinahmad' // modifica col tuo username Docker Hub
        IMAGE_NAME = "${DOCKERHUB_USERNAME}/flask-app-example"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Set Docker Image Tag') {
            steps {
                script {
                    def branch = env.GIT_BRANCH?.replaceAll(/^origin\//, '') ?: 'master'
                    def commit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    def gitTag = sh(returnStdout: true, script: 'git describe --tags --exact-match || true').trim()

                    if (gitTag) {
                        env.IMAGE_TAG = gitTag
                    } else if (branch == 'master') {
                        env.IMAGE_TAG = 'latest'
                    } else if (branch == 'develop') {
                        env.IMAGE_TAG = "develop-${commit}"
                    } else {
                        env.IMAGE_TAG = "dev-${commit}"
                    }

                    echo "Docker image tag: ${env.IMAGE_TAG}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ./app"
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin"
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker logout"
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

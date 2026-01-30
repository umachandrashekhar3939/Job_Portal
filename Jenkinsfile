pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['build', 'deploy', 'remove'],
            description: 'Select action: build, deploy, or remove'
        )
    }

    environment {
        IMAGE_NAME = "job-portal"
        DOCKERHUB_USERNAME = "your_dockerhub_username"
        TAG = "latest"
        COMPOSE_FILE = "docker-compose.yml"
    }

    stages {

        stage('Build') {
            when {
                expression { params.ACTION == 'build' }
            }
            steps {
                echo "Building Docker Image..."
                sh """
                docker build -t ${IMAGE_NAME}:${TAG} .
                docker tag ${IMAGE_NAME}:${TAG} ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${TAG}
                echo "Logging into DockerHub..."
                docker login -u ${DOCKERHUB_USERNAME} -p ${DOCKERHUB_PASS}
                docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${TAG}
                docker rmi ${IMAGE_NAME}:${TAG}
                docker rmi ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${TAG}
                docker logout
                """
            }
            post {
                success {
                    echo "Docker Image Build & Push Successful"
                }
                failure {
                    echo "Docker Build or Push Failed"
                }
                always {
                    echo "Build Stage Completed"
                }
            }
        }

        stage('Deploy') {
            when {
                expression { params.ACTION == 'deploy' }
            }
            steps {
                echo "Deploying Application using Docker Compose..."
                sh """
                docker-compose up -d --build
                """
            }
            post {
                success {
                    echo "Application Deployed Successfully"
                }
                failure {
                    echo "Deployment Failed"
                }
                always {
                    echo "Deploy Stage Completed"
                }
            }
        }

        stage('Remove') {
            when {
                expression { params.ACTION == 'remove' }
            }
            steps {
                echo "Stopping and Removing Containers..."
                sh """
                docker-compose down
                """
            }
            post {
                success {
                    echo "Application Removed Successfully"
                }
                failure {
                    echo "Remove Operation Failed"
                }
                always {
                    echo "Remove Stage Completed"
                }
            }
        }

    }
}

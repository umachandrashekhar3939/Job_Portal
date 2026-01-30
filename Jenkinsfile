pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['build', 'deploy', 'remove'],
            description: 'Select pipeline action'
        )
    }

    environment {
        IMAGE_NAME = "job-portal"
        DOCKERHUB_USER = "your_dockerhub_username"
        IMAGE_TAG = "latest"
        COMPOSE_FILE = "docker-compose.yml"
    }

    stages {

        stage('Build') {
            when {
                expression { params.ACTION == 'build' }
            }
            steps {
                echo "===== BUILD STAGE STARTED ====="
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
                    sh """
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DH_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                    echo "${DH_PASS}" | docker login -u "${DH_USER}" --password-stdin
                    docker push ${DH_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                    docker rmi -f ${IMAGE_NAME}:${IMAGE_TAG} || true
                    docker rmi -f ${DH_USER}/${IMAGE_NAME}:${IMAGE_TAG} || true
                    docker logout
                    """
                }
            }
            post {
                success {
                    echo "Build, Tag & Push Completed Successfully"
                }
                failure {
                    echo "Build or Push Failed"
                }
                always {
                    echo "===== BUILD STAGE FINISHED ====="
                }
            }
        }

        stage('Deploy') {
            when {
                expression { params.ACTION == 'deploy' }
            }
            steps {
                echo "===== DEPLOY STAGE STARTED ====="
                sh """
                docker-compose pull
                docker-compose up -d --build
                """
            }
            post {
                success {
                    echo "Deployment Successful"
                }
                failure {
                    echo "Deployment Failed"
                }
                always {
                    echo "===== DEPLOY STAGE FINISHED ====="
                }
            }
        }

        stage('Remove') {
            when {
                expression { params.ACTION == 'remove' }
            }
            steps {
                echo "===== REMOVE STAGE STARTED ====="
                sh """
                docker-compose down --remove-orphans
                """
            }
            post {
                success {
                    echo "Application Removed Successfully"
                }
                failure {
                    echo "Remove Failed"
                }
                always {
                    echo "===== REMOVE STAGE FINISHED ====="
                }
            }
        }
    }
}


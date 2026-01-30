pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['build', 'deploy', 'remove'],
            description: 'Choose pipeline action'
        )
    }

    environment {
        IMAGE_NAME = "job-portal-app"
        CONTAINER_NAME = "job-portal-container"
    }

    stages {

        stage('Build') {
            when {
                expression { params.ACTION == 'build' }
            }
            steps {
                echo "===== BUILD STAGE ====="
                sh '''
                ./mvnw clean package -DskipTests
                docker build -t $IMAGE_NAME:latest .
                '''
            }
            post {
                success {
                    echo "Build completed successfully"
                }
                failure {
                    echo "Build failed"
                }
            }
        }

        stage('Deploy') {
            when {
                expression { params.ACTION == 'deploy' }
            }
            steps {
                echo "===== DEPLOY STAGE ====="
                sh '''
                docker compose down || true
                docker compose up -d
                '''
            }
            post {
                success {
                    echo "Deployment completed successfully"
                }
                failure {
                    echo "Deployment failed"
                }
            }
        }

        stage('Remove') {
            when {
                expression { params.ACTION == 'remove' }
            }
            steps {
                echo "===== REMOVE STAGE ====="
                sh '''
                docker rm -f $CONTAINER_NAME || true
                docker rmi -f $IMAGE_NAME:latest || true
                '''
            }
            post {
                success {
                    echo "Container and image removed successfully"
                }
                failure {
                    echo "Remove stage failed"
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline Execution Completed"
        }
    }
}

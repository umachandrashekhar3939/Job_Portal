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
        IMAGE_TAG  = "latest"
        COMPOSE_FILE = "docker-compose.yml"
    }

    stages {

        stage('Build & Push Image') {
            when {
                expression { params.ACTION == 'build' }
            }
            steps {
                echo "===== BUILD STAGE STARTED ====="

                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                      docker build -t ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG} .
                      echo "${DOCKER_PASS}" | docker login -u "${DOCKER_USER}" --password-stdin
                      docker push ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                      docker logout
                    """
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
                  docker-compose up -d
                """
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
        }
    }
}

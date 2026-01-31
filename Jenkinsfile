pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['build', 'deploy', 'remove'],
            description: 'Choose pipeline action'
        )
        string(
            name: 'IMAGE_NAME',
            defaultValue: 'spring_project2003',
            description: 'Docker image name'
        )
        string(
            name: 'IMAGE_TAG',
            defaultValue: 'v1',
            description: 'Docker image tag'
        )
        string(
            name: 'DOCKERHUB_USERNAME',
            defaultValue: 'uma777',
            description: 'DockerHub username'
        )
    }

    environment {
        IMAGE = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {

        /* ================= CHECKOUT ================= */
        stage('Checkout Code') {
            when { expression { params.ACTION == 'build' } }
            steps {
                git branch: 'main',
                    url: 'https://github.com/umachandrashekhar3939/Job_Portal.git',
                    credentialsId: 'github-creds'
            }
        }

        /* ================= BUILD ================= */
        stage('Build Docker Image') {
            when { expression { params.ACTION == 'build' } }
            steps {
                sh 'docker build -t $IMAGE .'
            }
        }

        stage('Docker Login') {
            when { expression { params.ACTION == 'build' } }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-1234',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Docker Push') {
            when { expression { params.ACTION == 'build' } }
            steps {
                sh 'docker push $IMAGE'
            }
        }

        stage('Delete Local Image') {
            when { expression { params.ACTION == 'build' } }
            steps {
                sh 'docker rmi $IMAGE || true'
            }
        }

        /* ================= DEPLOY ================= */
        stage('Deploy') {
            when { expression { params.ACTION == 'deploy' } }
            steps {
                sh '''
                docker-compose down || true
                docker-compose pull
                docker-compose up -d
                '''
            }
        }

        /* ================= REMOVE ================= */
        stage('Remove') {
            when { expression { params.ACTION == 'remove' } }
            steps {
                sh 'docker-compose down || true'
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
            echo "Pipeline execution completed successfully"
        }
    }
}

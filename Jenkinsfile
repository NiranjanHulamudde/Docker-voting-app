pipeline {
    agent any 

    environment {
        DOCKER_USER = 'niranjanhulamudde'
        DOCKER_IMAGE = 'voting-app'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('1. Git Code Checkout') {
            steps {
                checkout scm
            }
        }
        stage('2. Code linting') {
            steps {
                dir('backend') {
                    sh 'pip install flake8 && flake8 . --count --select=E9,F63,F7,F82 --statistics || echo "Skipping linting"'                
            }
            }
        }
        stage('3. Build All Services') {
            steps {
                // This will read your docker-compose.yml file and build all components
                sh 'docker compose build'
            }
        }
        stage('4. Pushing the image to dockerhub') {
            steps {
                echo 'Pushing the image to Docker-Hub.'
                withCredentials([usernamePassword(credentialsId : 'docker-pass',
                                                  usernameVariable : 'DH_USER',
                                                  passwordVariable : 'DH_PASSWORD')]) {
                    // Secure login via piped input
                    sh "echo \$DH_PASSWORD | docker login -u \$DH_USER --password-stdin"
                    
                    // 1. Tag and push the FRONTEND service
                    sh "docker tag voting-app-frontend:latest ${DOCKER_USER}/${DOCKER_IMAGE}-frontend:${IMAGE_TAG}"
                    sh "docker push ${DOCKER_USER}/${DOCKER_IMAGE}-frontend:${IMAGE_TAG}"
                    
                    // 2. Tag and push the BACKEND service
                    sh "docker tag voting-app-backend:latest ${DOCKER_USER}/${PROJECT_NAME}-backend:${IMAGE_TAG}"
                    sh "docker push ${DOCKER_USER}/${PROJECT_NAME}-backend:${IMAGE_TAG}"                    
                }
        }
    }
    }
    post {
        success {
            echo 'Build was succesful and Image pushed to Dockerhub succesfully.'
        }
        failure {
            echo 'Build was Un-succesful hence image was not pushed to Dockerhub.'
        }
    }
}


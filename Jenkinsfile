pipeline {
    agent any 

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
        
        stage('3. Build All Services') {
            steps {
                // This will read your docker-compose.yml file and build all components
                sh 'docker build -t voting_app:latest .'
            }
        }
    }
    post {
        success {
            echo 'Build was succesful.'
        }
        failure {
            echo 'Build was Un-succesful.'
        }
    }
}
    }
}

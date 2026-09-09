pipeline {
    agent any 

    stages {
        stage('1. Git Code Checkout') {
            steps {
                checkout scm
            }
        }
        stage('2. Build All Services') {
            steps {
                // This will read your docker-compose.yml file and build all components
                sh 'docker compose build'
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

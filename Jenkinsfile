pipeline {
    agent any
    environment {
        DOCKER_USER  = 'niranjanhulamudde'
        DOCKER_IMAGE = 'docker-voting-app'
        IMAGE_TAG    = "v.${env.BUILD_NUMBER}"
    }
    stages {
        stage('Download and check the source code') {
            steps {
                checkout scm
            }
        }
        
        stage('Running tests') {
            steps {
                dir('backend') { // Shifts focus into the backend directory
                    sh '''
                        python3 -m venv venv
                        ./venv/bin/pip install --upgrade pip
                        ./venv/bin/pip install flask pytest
                        ./venv/bin/python3 -m pytest app.py || [ $? -eq 5 ]
                    '''
                }
            }
        }
        
        stage('Building the Images') {
            steps {
                // Build Backend Image out of its dedicated subfolder
                dir('backend') {
                    sh "docker build -t ${DOCKER_USER}/${DOCKER_IMAGE}-backend:${IMAGE_TAG} ."
                }
                // Build Frontend Image out of its dedicated subfolder
                dir('frontend') {
                    sh "docker build -t ${DOCKER_USER}/${DOCKER_IMAGE}-frontend:${IMAGE_TAG} ."
                }
            }
        }
        
        stage('Pushing the images to Dockerhub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-pass',
                                                 usernameVariable: 'dh_user',
                                                 passwordVariable: 'dh_pass')]) {
                    
                    
                    sh "echo \$dh_pass | docker login -u \$dh_user --password-stdin"
                    
                    
                    sh "docker push ${DOCKER_USER}/${DOCKER_IMAGE}-backend:${IMAGE_TAG}"
                    sh "docker push ${DOCKER_USER}/${DOCKER_IMAGE}-frontend:${IMAGE_TAG}"
                }
            }
        }
        #stage ('Infrastructure provisioning') {
         #   environment {
          #      AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
           #     AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
            #}
            #steps {
             #   dir('terraform') {
              #      sh 'terraform init'
               #     sh 'terraform apply --auto-approve'
                #}
            #}
        #}       
            }
    
post {
        success {
            echo 'Deployed and provisioned successfully'
        }
        failure {
            echo 'Failed to proceed' 
        }
    }
}

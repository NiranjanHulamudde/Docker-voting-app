pipeline {
    agent any
    environment {
        DOCKER_USER = 'niranjanhulamudde'
        DOCKER_IMAGE = 'docker-voting-app'
        IMAGE_TAG = 'latest'
    }
    stages {
        stage ('Download and check the source code') {
            steps {
                chekcout scm
            }
        }
        stage ('Running tests') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pytest test_app.py
                  '''
            }
        }
      stage ('Building the Image') {
          steps {
              sh "docker build -t ${DOCKER_USER}/${DOCKER_IMAGE}:${IMAGE_TAG} ."
          }
      }
      stage ('Pushing the image to Dockerhub') {
          steps {
              withCredential([usernamePassword(credentialsId: 'docker-pass',
                                               usernameVariable: 'dh_user',
                                               passworrdVariable: 'dh_pass' )] ) {
                sh "echo ${dh_pass} | docker login -u ${dh_user} --password-stdin"
                sh "docker push ${DOCKER_USER}/${DOCKER_IMAGE}:${IMAGE_TAG}"
              }
          }
      }

      

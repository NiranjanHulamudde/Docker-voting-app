pipeline {
        agent any

        environment {
        DOCKER_USER  = 'niranjanhulamudde'
        DOCKER_IMAGE = 'voting-app'
        IMAGE_TAG    = 'latest'
        AWS_REGION = 'US-EAST-1'
    }
        stages {
            stage('code checkout') {
                steps {
                    checkout scm
                }
            }
            stage ('Build and push to docker hub') {
                steps {
                    sh 'docker-compose build'
                }
            }
            stage ('Pushing to the dockerhub') {
                steps {
                    withCredentials([usernamePassword(credentialsId: 'docker-pass',
                                                      usernameVariable: 'DH_USER',
                                                      passwordVariable: 'DH_PASS')]) {
                        sh "docker login -u ${DH_USER} -p ${DH_PASS}"
                        sh "docker build -t ${DOCKER_IMAGE} ."
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
            stage('Infrastructure deployment') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-credentials',
                                                 usernameVariable: 'AWS_KEY',
                                                 passwordVariable: 'AWS_SECRET')]) {
                    sh """
                        export AWS_ACCESS_KEY_ID=${AWS_KEY}
                        export AWS_SECRET_ACCESS_KEY=${AWS_SECRET}
                        terraform init
                        terraform apply -auto-approve
                    """
                }
            }
        }
    }

    post {
        success {
                echo "deployed successfully"
            }
        failure {
                echo "failed  to deploy"
            }
        }
    }
                                                      

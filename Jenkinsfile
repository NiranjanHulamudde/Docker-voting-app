pipepline {
          agent any {
          stages {
            stage ('1. git-code checking') {
              steps {
                   checkout scm
            }
            stage ('2. Testing and building the the build') {
              steps {
                sh './Docker-voting-app'
                sh 'docker build -t  votingapp:latest .'
            }
            }
            }
          }
          }
}

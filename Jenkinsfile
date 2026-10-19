pipeline {
    agent none

    options {
        disableConcurrentBuilds()
    }

    stages {
        stage('Preparation') {
            agent any
            steps {
                sh '''
                    set -eu
                    docker version >/dev/null
                    echo "Docker is available."
                '''
            }
        }

        stage('Build and deploy') {
            steps {
                build job: 'BuildSampleApp',
                      wait: true,
                      propagate: true
            }
        }

        stage('Acceptance test') {
            steps {
                build job: 'TestSampleApp',
                      wait: true,
                      propagate: true
            }
        }
    }
}
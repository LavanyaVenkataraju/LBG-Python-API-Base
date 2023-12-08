pipeline {
    agent any
    stages {
        stage('Init') {
            steps {
                // Init 
                // SSH command establishes the connection between Jenkins server and Prod server 
                // Because we want to run these containers(flask-app) on prod server and not on Jenkins server so we SSH
                //<< EOF is a Here Dock is to indicate that the commands following EOF are commands to be run as if it were commands under .sh script
                sh '''
                ssh -i ~/.ssh/id_rsa jenkins@10.200.0.10 << EOF
                docker stop flask-app || echo "flask-app not running"
                docker rm flask-app || echo "flask-app not running"  
                '''
           }
        }
        stage('Build') {
            steps {
                // We are building the docker images on Jenkins machine , SSH is not required. 
                sh '''
                docker build -t lavyyndocker/python-api -t lavyyndocker/python-api:v${BUILD_NUMBER} .
                '''
            }
        }
        stage('Push') {
            steps {
                 // We are pushing the docker images to docker hub on Jenkins machine , SSH is not required. 
                sh '''
                docker push lavyyndocker/python-api
                docker push lavyyndocker/python-api:v${BUILD_NUMBER}
                '''
            }
        }
        stage('Deploy') {
            steps {
                sh '''
                ssh -i ~/.ssh/id_rsa jenkins@10.200.0.10 << EOF
                docker run -t -p 8080 --name flask-app lavyyndocker/python-api
                '''
            }
        }
        stage('Cleanup') {
            steps {
                sh '''
                docker system prune -f 
                '''
            }
        }
    }
}

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
                
                docker stop flask-app || echo "Lavanya msg - flask-app not running"
                docker rm flask-app || echo "Lavanya msg - flask-app not running"  

                docker stop nginx || echo "Lavanya msg - nginx not running"
                docker rm nginx || echo "Lavanya msg - nginx not running" 

                docker rmi lavyyndocker/flask-jenk1 || echo "Image does not exist"
                docker rmi lavyyndocker/flask-nginx || echo "Image does not exist"

                docker network create project || echo "network already exists"
                '''
           }
        }
        stage('Build') {
            steps {
                // We are building the docker images on Jenkins machine , SSH is not required.
                sh '''
                docker build -t lavyyndocker/flask-jenk1 -t lavyyndocker/flask-jenk1:v${BUILD_NUMBER} .
                docker build -t lavyyndocker/flask-nginx -t lavyyndocker/flask-nginx:v${BUILD_NUMBER} ./nginx
                '''
            }
        }
        stage('Push') {
            steps {
                 // We are pushing the docker images to docker hub on Jenkins machine , SSH is not required. 
               sh '''
               docker push lavyyndocker/flask-jenk1
               docker push lavyyndocker/flask-jenk1:v${BUILD_NUMBER}

               docker push lavyyndocker/flask-nginx
               docker push lavyyndocker/flask-nginx:v${BUILD_NUMBER}
               '''
            }
        }
        stage('Deploy') {
            steps {
                sh '''
                ssh -i ~/.ssh/id_rsa jenkins@10.200.0.10 << EOF
                docker run -d --name flask-app --network project lavyyndocker/flask-jenk1
                docker run -d -p 80:8080 --name flask-app --network project lavyyndocker/flask-nginx
                '''
            }
        }
        stage('Cleanup') {
            steps {
                sh '''
                docker system prune -f 
                docker rmi lavyyndocker/flask-app:v${BUILD_NUMBER}
                 docker rmi lavyyndocker/flask-nginx:v${BUILD_NUMBER}
                '''
            }
        }
    }
}

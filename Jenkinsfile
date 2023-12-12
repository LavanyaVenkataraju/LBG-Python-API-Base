pipeline {
    agent any
    stages {
        stage('Init') {
            steps {
                script {
			        if (env.GIT_BRANCH == 'origin/main') {
                        sh '''
                        ssh -i ~/.ssh/id_rsa jenkins@10.200.0.10 << EOF
                        docker stop flask-app || echo "flask-app not running"
                        docker rm flask-app || echo "flask-app not running"
                        docker stop nginx || echo "nginx not running"
                        docker rm nginx || echo "nginx not running"
                        docker rmi lavyyndocker/flask-jenk1 || echo "Image does not exist"
                        docker rmi lavyyndocker/flask-nginx || echo "Image does not exist"
                        docker network create project || echo "network already exists"
                        '''
                    } else if (env.GIT_BRANCH == 'origin/dev2') {
                        sh '''
                        ssh -i ~/.ssh/id_rsa jenkins@10.200.0.10 << EOF
                        docker stop flask-app || echo "flask-app not running"
                        docker rm flask-app || echo "flask-app not running"
                        docker stop nginx || echo "nginx not running"
                        docker rm nginx || echo "nginx not running"
                        docker rmi lavyyndocker/flask-jenk1 || echo "Image does not exist"
                        docker rmi lavyyndocker/flask-nginx || echo "Image does not exist"
                        docker network create project || echo "network already exists"
                        '''
                    } else {
                        sh '''
                        echo "Unrecognised branch"
                        '''
                    }
		        }
           }
        }
        stage('Build') {
            steps {
                script {
			        if (env.GIT_BRANCH == 'origin/main') {
                        sh '''
                        echo "Build not required in main"
                        '''
                    } else if (env.GIT_BRANCH == 'origin/dev2') {
                        sh '''
                        docker build -t lavyyndocker/flask-jenk1 -t lavyyndocker/flask-jenk1 :v${BUILD_NUMBER} .   
                        docker build -t lavyyndocker/flask-nginx -t lavyyndocker/flask-nginx:v${BUILD_NUMBER} ./nginx             
                        '''
                    } else {
                        sh '''
                        echo "Unrecognised branch"
                        '''
                    }
		        }
           }
        }
        stage('Push') {
            steps {
                script {
			        if (env.GIT_BRANCH == 'origin/main') {
                        sh '''
                        echo "Push not required in main"
                        '''
                    } else if (env.GIT_BRANCH == 'origin/dev2') {
                        sh '''
                        docker push lavyyndocker/flask-jenk1 
                        docker push lavyyndocker/flask-jenk1 :v${BUILD_NUMBER}
                        docker push lavyyndocker/flask-nginx
                        docker push lavyyndocker/flask-nginx:v${BUILD_NUMBER}
                        '''
                    } else {
                        sh '''
                        echo "Unrecognised branch"
                        '''
                    }
		        }
           }
        }
        stage('Deploy') {
            steps {
                script {
			        if (env.GIT_BRANCH == 'origin/main') {
                        sh '''
                        ssh -i ~/.ssh/id_rsa jenkins@10.200.0.3 << EOF
                        docker run -d --name flask-app --network project lavyyndocker/flask-jenk1
                        docker run -d -p 80:80 --name nginx --network project lavyyndocker/flask-nginx
                        '''
                    } else if (env.GIT_BRANCH == 'origin/dev2') {
                        sh '''
                        ssh -i ~/.ssh/id_rsa jenkins@10.200.0.15 << EOF
                        docker run -d --name flask-app --network project lavyyndocker/flask-jenk1
                        docker run -d -p 80:80 --name nginx --network project lavyyndocker/flask-nginx
                        '''
                    } else {
                        sh '''
                        echo "Unrecognised branch"
                        '''
                    }
		        }
            }
        }
        stage('Cleanup') {
            steps {
                script {
                    if (env.GIT_BRANCH == 'origin/dev2') {
                        sh '''
                        docker rmi lavyyndocker/flask-jenk1:v${BUILD_NUMBER}
                        docker rmi lavyyndocker/flask-nginx:v${BUILD_NUMBER}
                        '''
                    }
                }
                sh '''
                docker system prune -f 
                '''
           }
        }
    }
}

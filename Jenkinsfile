pipeline {
    agent any
    stages {
        stage('Init') {
            steps {
                script {
                    if (env.GIT_BRANCH == "origin/main") {
                        sh '''
                        kubectl create namespace prod || echo "Namespace prod already exists"
                        '''
                    } else if (env.GIT_BRANCH == "origin/dev3") {
                        sh '''
                        kubectl create namespace dev || echo "Namespace dev already exists"
                        '''
                    } else {
                        sh '''
                        echo "Branch not recognised"
                        '''
                    }
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    if (env.GIT_BRANCH == "origin/main") {
                        sh '''
                        docker build -t lavyyndocker/task1-kube:latest -t lavyyndocker/task1-kube:prod-v${BUILD_NUMBER} .
                        '''
                    } else if (env.GIT_BRANCH == "origin/dev3") {
                        sh '''
                        docker build -t lavyyndocker/task1-kube:latest -t lavyyndocker/task1-kube:dev3-v${BUILD_NUMBER} .
                        '''
                    } else {
                        sh '''
                        echo "Branch not recognised"
                        '''
                    }
                }
            }
        }

        stage('Push') {
            steps {
                script {
                    if (env.GIT_BRANCH == "origin/main") {
                        sh '''
                        docker push lavyyndocker/task1-kube:latest
                        docker push lavyyndocker/task1-kube:prod-v${BUILD_NUMBER}
                        '''
                    } else if (env.GIT_BRANCH == "origin/dev3") {
                        sh '''
                        docker push lavyyndocker/task1-kube:latest
                        docker push lavyyndocker/task1-kube:dev3-v${BUILD_NUMBER}
                        '''
                    } else {
                        sh '''
                        echo "Branch not recognised"
                        '''
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    if (env.GIT_BRANCH == "origin/main") {
                        sh '''
                        kubectl apply -n prod -f ./kubernetes
                        kubectl set image deployment/flask-deployment task1=lavyyndocker/task1-kube:prod-v${BUILD_NUMBER} -n prod
                        '''
                    } else if (env.GIT_BRANCH == "origin/dev3") {
                        sh '''
                        kubectl apply -n dev -f ./kubernetes
                        kubectl set image deployment/flask-deployment task1=lavyyndocker/task1-kube:dev3-v${BUILD_NUMBER} -n dev
                        '''
                    } else {
                        sh '''
                        echo "Branch not recognised"
                        '''
                    }
                }
            }
        }

        stage('CleanUp') {
            steps {
                sh '''
                docker system prune -f 
                '''
            }
        }
    }
}
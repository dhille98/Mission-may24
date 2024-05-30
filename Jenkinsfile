pipeline {
    agent {label 'JDK-17'}
    
    tools{
        jdk 'java'
        maven 'maven3'
    }
    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub' // Replace with your credentials ID
        DOCKERHUB_REPO = 'dhillevajja/missionjenkins' // Replace with your Docker Hub repository
        IMAGE_TAG = "${env.BUILD_NUMBER}" // Use the build number as the tag
       
    }
    
    stages{
        stage ('git clone'){
            steps {
                git url: 'https://github.com/dhille98/Mission-may24.git', branch: 'dev'
            }
            
        }
        stage ('build'){
            steps{
                sh 'mvn compile'
                sh "mvn package -DskipTests=true" 
                archiveArtifacts artifacts: '**/target/*.jar', followSymlinks: false
            }
        }
        stage('sonar-QUBE') {
            steps {
                withSonarQubeEnv(credentialsId: 'sonar-cri', installationName: 'sonar-cri') { // You can override the credential to be used
                sh 'mvn package -DskipTests=true sonar:sonar -Dsonar.host.url=https://sonarcloud.io -Dsonar.organization=dhille98 -Dsonar.projectKey=dhille98-spring-pet'}

            }
        }
        stage('Trivy Scan file') {            
             steps { 
                sh "trivy fs --format table -o trivy-fs-report.html ."              
            } 
        }
       stage('Build') {
            steps {
                script {
                    echo "Building Docker image with tag: $IMAGE_TAG"
                    sh 'docker build -t $DOCKERHUB_REPO:$IMAGE_TAG .'
                }
            }
        }
        stage('Login to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        echo "Logged in to Docker Hub"
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        sh 'docker push $DOCKERHUB_REPO:$IMAGE_TAG'
                    }
                }
            }
        }
         stage('kubenetes deployment'){
            steps {
               withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'k8s-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://10.182.0.60:6443') {
               sh 'kubectl apply -f ds.yml'
            }
        }
   
      }

    }
}
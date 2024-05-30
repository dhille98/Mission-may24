pipeline {
    agent {label 'JDK-17'}
    
    tools{
        jdk 'java'
        maven 'maven3'
    }
    environment {
        
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
       stage('image build')  {
            steps {
                // This step should not normally be used in your script. Consult the inline help for details.
                withDockerRegistry(credentialsId: 'dockerhub', toolName: 'docker') {
                sh 'docker image build -t dhillevajja/missionjenkins:$IMAGE_TAG .'
}
            }
       }    


    }
}
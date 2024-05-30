pipeline {
    agent {label 'JDK-17'}
    
    tools{
        jdk 'java'
        maven 'maven3'
    }
    
    stages{
        stage ('git clone'){
            steps {
                git url: 'https://github.com/jaiswaladi246/Mission.git', branch: 'main'
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


    }
}
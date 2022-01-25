pipeline {
    agent any
    tools { 
        maven 'M3' 
    }
        stages {
          
            stage('build') {


                   steps {
                       
                             sh 'mvn clean package'
                             
                            } 
                       
              }
        
         stage("build & SonarQube analysis") {

            steps {
              withSonarQubeEnv('sonarqube') {
                sh 'mvn clean package sonar:sonar'
              }
            }
          }
          stage("Quality Gate") {
            steps {
              timeout(time: 3, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
              }
            }
          }
        
        
   }
}

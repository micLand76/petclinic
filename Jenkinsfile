pipeline {
    agent any
    tools { 
        maven 'M3' 
    }
        stages {       
            stage('build mvn') {

                   steps {
                       
                             sh 'mvn clean'
                             
                            } 
                       
              }
	     stage('cmd docker') {
		 steps{
			sh 'docker ps'
			}
		}
		stage('test install tomcat'){
		steps{
			sh 'docker run --rm -p 8888:8080 tomcat:9.0'
			}	
		}
       		stage('install app petclinic sur tomcat'){
		steps{
		sh 'COPY target/petclinic.war /usr/local/tomcat/webapps/ROOT.wa'
		}
		}	

/*         stage("build and SonarQube analysis") {
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
*/   }
}

pipeline {
    agent any
    tools { 
        maven 'M3' 
    }

    environment {
        registryName = "petclinicweb"
        registryCredential = 'petclinic_ACR'
        registryUrl = 'petclinicweb.azurecr.io'
		dockerImage = ''
	}	
    stages {       
        /*stage('build mvn') {
            steps {      
                sh 'mvn clean '        
            }        
        }*/
     
		stage("build and SonarQube analysis") {
            steps {
				withSonarQubeEnv('sonarqube') {
					sh 'mvn clean package sonar:sonar'
				}
            }
         }
         
		/*stage("Quality Gate") {
            steps {
				timeout(time: 10, unit: 'MINUTES') {
					waitForQualityGate abortPipeline: true
				}
            }
        }       */


	    
       // Stopping Docker containers for cleaner Docker run
        stage('stop previous containers') {
            steps {
				sh 'docker ps -f name=petclinic -q | xargs --no-run-if-empty docker container stop'
				sh 'docker container ls -a -fname=petclinic -q | xargs -r docker container rm'
			}
       }

		stage('install tomcat in a docker'){
			steps{
				sh 'docker build -t petclinic_img2 .'
				sh 'docker run -d -p 8888:8080 --name petclinic petclinic_img2'
			}	
		}

        stage ('Build Docker image') {
            steps {
                script {
                    dockerImage = docker.build registryName
                }
            }
        }

		stage('Upload Image to ACR') {
			steps{   
				script {
					docker.withRegistry( "http://${registryUrl}", registryCredential ) {
						dockerImage.push()
					}
				}
			}
		}
	}
}

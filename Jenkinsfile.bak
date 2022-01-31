pipeline {
    agent any
    tools { 
        maven 'M3' 
    }

    environment {
        registryName = "petclinicweb"
        registryCredential = 'petclinic_ACR'
        registryUrl = 'petclinicweb.azurecr.io'
		MYSQL_PASSWORD = 'admin_Petclinic'
		MYSQL_USERNAME = 'myConnection'
		MYSQL_SERVER_IP = 'petclinic.mysql.database.azure.com'
		dockerImage = ''
	}	
    stages {       
		
		//first stage: execute maven to test and build the application
		stage("Maven build") {
            steps {
				withSonarQubeEnv('sonarqube') {
					sh 'mvn clean instal'
					echo 'mvn -Denv.MYSQL_SERVER_IP=${MYSQL_SERVER_IP} -Denv.MYSQL_USERNAME=${MYSQL_USERNAME} -Denv.MYSQL_PASSWORD=${MYSQL_PASSWORD} package -P MySQL '
				}
            }
         }
		  
		stage("SonarQube Quality Gate") {
            steps {
				timeout(time: 10, unit: 'MINUTES') {
					waitForQualityGate abortPipeline: true
				}
            }
        }       

       // Stopping Docker containers for cleaner Docker run
        stage('stop previous containers') {
            steps {
				sh 'docker ps -f name=petclinic -q | xargs --no-run-if-empty docker container stop'
				sh 'docker container ls -a -fname=petclinic -q | xargs -r docker container rm'
			}
       }
		
		//installing the server web Tomcat in a container
		stage('install tomcat in a docker'){
			steps{
				sh 'docker build -t petclinic_img .'
				sh 'docker run -d -p 8888:8080 --name petclinic petclinic_img'
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

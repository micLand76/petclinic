FROM tomcat:9.0

COPY target/petclinic.war /usr/local/tomcat/webapps/ROOT.wa

EXPOSE 8888

CMD ["catalina.sh", "run"]

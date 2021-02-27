FROM maven:3.6.3-jdk-8-slim as maven_builder

RUN apt update && apt install git -y

RUN git clone https://github.com/shephertz/App42PaaS-Java-MySQL-Sample.git /app

WORKDIR /app

RUN ["mvn", "package"]

######################################################################################

FROM tomcat:10.0.2-jdk8-corretto

COPY --from=maven_builder /app/target/App42PaaS-Java-MySQL-Sample-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/sampapp.war
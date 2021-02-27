FROM maven:3.6.3-jdk-8-slim as maven_builder

ARG MYSQL_IP
ARG MYSQL_PORT
ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG MYSQL_DATABASE

RUN apt update && apt install git -y

RUN git clone https://github.com/shephertz/App42PaaS-Java-MySQL-Sample.git /app

WORKDIR /app

SHELL ["/bin/bash", "-c"]

RUN echo -e "app42.paas.db.ip = ${MYSQL_IP}"\
         "\napp42.paas.db.port = ${MYSQL_PORT}"\
         "\napp42.paas.db.username = ${MYSQL_USER}"\
         "\napp42.paas.db.password = ${MYSQL_PASSWORD}"\
         "\napp42.paas.db.name = ${MYSQL_DATABASE}" > WebContent/Config.properties

RUN cat WebContent/Config.properties

RUN ["mvn", "package"]

######################################################################################

FROM tomcat:10.0.2-jdk8-corretto

COPY --from=maven_builder /app/target/App42PaaS-Java-MySQL-Sample-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/sampapp.war
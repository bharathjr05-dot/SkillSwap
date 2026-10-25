FROM maven:3.9-eclipse-temurin-17 AS mysql-driver
WORKDIR /build
RUN mvn -B dependency:get -Dartifact=com.mysql:mysql-connector-j:8.4.0
COPY WEB-INF/classes/util/*.java ./src/util/
RUN mkdir -p /compiled && javac -d /compiled src/util/*.java

FROM tomcat:10.1-jdk17-temurin
ENV PORT=8080
COPY --from=mysql-driver /root/.m2/repository/com/mysql/mysql-connector-j/8.4.0/mysql-connector-j-8.4.0.jar /usr/local/tomcat/lib/mysql-connector-j.jar
COPY *.jsp /usr/local/tomcat/webapps/ROOT/
COPY css/ /usr/local/tomcat/webapps/ROOT/css/
COPY js/ /usr/local/tomcat/webapps/ROOT/js/
COPY WEB-INF/web.xml /usr/local/tomcat/webapps/ROOT/WEB-INF/web.xml
COPY --from=mysql-driver /compiled/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/
COPY docker-entrypoint.sh /usr/local/bin/skillshare-entrypoint.sh
RUN chmod +x /usr/local/bin/skillshare-entrypoint.sh
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/skillshare-entrypoint.sh"]

FROM openjdk:11-jdk-slim-buster
ARG JAR=target/react-and-spring-data-rest-0.0.1-SNAPSHOT.jar
ADD ${JAR} java_app.jar
ENTRYPOINT ["java", "-jar", "/java_app.jar"]
### Expose the port on which the Spring Boot application will listen for requests
EXPOSE 8080

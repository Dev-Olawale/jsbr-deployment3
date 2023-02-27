### Define the base image for your Docker container
FROM openjdk:11-jdk-slim-buster

### Set the working directory for the Docker container
WORKDIR /

### Copy the pom.xml file to the container's working directory.
COPY pom.xml .

### Install the dependencies required for the React frontend
RUN apt-get update && \
    apt-get install -y npm && \
    npm install

### Copy the rest of the frontend files to the container's working directory
COPY src/main/js/ .

### Build the React frontend
RUN npm run build

### Copy the backend files to the container's working directory
COPY src/main/java/ .

### Build the Spring Boot backend
RUN mvn package

### Set the entrypoint for the Docker container
ENTRYPOINT ["java", "-jar", "target/react-and-spring-data-rest-0.0.1-SNAPSHOT.jar"]

### Expose the port on which the Spring Boot application will listen for requests
EXPOSE 8080

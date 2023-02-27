### Define the base image for your Docker container
FROM openjdk:11-jdk-slim-buster AS spring-build

### Set the working directory for the Docker container
### WORKDIR /

### Copy the pom.xml file to the container's working directory.
COPY src /home/app/src
COPY pom.xml mvnw mvnw.cmd /home/app/
### New - Copy the mvnw file to the container's working directory.
### COPY mvnw ./
### New line - Copy the mvnw.cmd file to the container's working directory.
### COPY mvnw.cmd ./

### New line - Copy the package.json file to the container's working directory
### COPY package.json ./
### New line - Copy the webpack.config.js file to the container's working directory
### COPY webpack.config.js ./
### New line - Copy the package-lock.json file to the container's working directory
### COPY package-lock.json ./

### Install the dependencies required for the React frontend
### RUN apt-get update && apt-get install -y npm && npm install

### Copy the rest of the frontend files to the container's working directory
### COPY src/main/ ./

### Build the React frontend
### RUN npm run build
### RUN webpack --mode production

### Copy the backend files to the container's working directory
### COPY src/main/java/ ./

### Updated line - Build the Spring Boot backend
RUN mvn -N io.takari:maven:wrapper
RUN chmod +x mvnw
RUN mvnw -f ./pom.xml clean package

# Package stage
FROM openjdk:8-jdk-alpine
WORKDIR /app
COPY --from=spring-build /home/app/target/react-and-spring-data-rest-0.0.1-SNAPSHOT.jar .
### Set the entrypoint for the Docker container
ENTRYPOINT ["java", "-jar", "target/react-and-spring-data-rest-0.0.1-SNAPSHOT.jar"]
### Expose the port on which the Spring Boot application will listen for requests
EXPOSE 8080

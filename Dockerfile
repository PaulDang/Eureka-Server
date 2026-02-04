# Use an official java runtime as parent image
FROM eclipse-temurin:17-jre-alpine

LABEL authors="Paul"

#Set the working directory in the container
WORKDIR /app

# Copy the jar files into the container
COPY target/*.jar /app/eureka-server.jar

#Run the jar file
ENTRYPOINT ["java", "-jar", "/app/eureka-server.jar"]

#Expose the port of the application runs on
EXPOSE 8761
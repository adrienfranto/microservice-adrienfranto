# Stage 1: Build avec Maven
FROM maven:3.9.6-eclipse-temurin-21 AS builder
WORKDIR /app

# Copie parent + module enfant
COPY pom.xml .
COPY etudiant-service/pom.xml etudiant-service/
COPY etudiant-service/src etudiant-service/src

# Build module etudiant-service
RUN mvn -f etudiant-service/pom.xml clean package -DskipTests

# Stage 2: Runtime avec JDK léger
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app
COPY --from=builder /app/etudiant-service/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]

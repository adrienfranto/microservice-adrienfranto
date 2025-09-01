# Étape 1 : Build avec Maven
FROM maven:3.9.6-eclipse-temurin-21 AS builder
WORKDIR /app

# Copie parent + module enfant
COPY pom.xml .
COPY etudiant-service/pom.xml etudiant-service/
COPY etudiant-service/src etudiant-service/src

# Build module etudiant-service
RUN mvn -f etudiant-service/pom.xml clean package -DskipTests

# Étape 2 : Exécution avec JDK léger
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app
COPY --from=builder /app/etudiant-service/target/etudiant-service-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]

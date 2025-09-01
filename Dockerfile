# ----------------------------
# Build Stage pour API Gateway
# ----------------------------
FROM maven:3.9.8-eclipse-temurin-21 AS build-api
WORKDIR /app
COPY pom.xml ./
COPY src ./src
RUN mvn dependency:resolve
RUN mvn clean package -DskipTests

# ----------------------------
# Runtime API Gateway
# ----------------------------
FROM eclipse-temurin:21-jdk-alpine AS run-api
WORKDIR /app
COPY --from=build-api /app/target/api-gateway-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 9000
ENTRYPOINT ["java","-jar","app.jar"]

# ----------------------------
# Build Stage pour Etudiant Service
# ----------------------------
FROM maven:3.9.6-eclipse-temurin-21 AS build-etudiant
WORKDIR /app
COPY pom.xml ./
COPY etudiant-service/pom.xml etudiant-service/
COPY etudiant-service/src etudiant-service/src
RUN mvn -f etudiant-service/pom.xml clean package -DskipTests

# Runtime Etudiant Service
FROM eclipse-temurin:21-jdk-alpine AS run-etudiant
WORKDIR /app
COPY --from=build-etudiant /app/etudiant-service/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]

# ----------------------------
# Build Stage pour Travail Service
# ----------------------------
FROM maven:3.9.8-eclipse-temurin-21 AS build-travail
WORKDIR /app
COPY pom.xml ./
COPY travail-service/pom.xml travail-service/
COPY travail-service/src travail-service/src
RUN mvn -f travail-service/pom.xml clean package -DskipTests

# Runtime Travail Service
FROM eclipse-temurin:21-jdk-alpine AS run-travail
WORKDIR /app
COPY --from=build-travail /app/travail-service/target/*.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java","-jar","app.jar"]

# ----------------------------
# Build Stage pour Groupe Service
# ----------------------------
FROM maven:3.9.8-eclipse-temurin-21 AS build-groupe
WORKDIR /app
COPY pom.xml ./
COPY groupe-service/pom.xml groupe-service/
COPY groupe-service/src groupe-service/src
RUN mvn -f groupe-service/pom.xml clean package -DskipTests

# Runtime Groupe Service
FROM eclipse-temurin:21-jdk-alpine AS run-groupe
WORKDIR /app
COPY --from=build-groupe /app/groupe-service/target/*.jar app.jar
EXPOSE 8082
ENTRYPOINT ["java","-jar","app.jar"]

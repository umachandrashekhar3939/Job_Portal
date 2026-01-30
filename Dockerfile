# =========================
# Stage 1: Build Stage
# =========================
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Install MySQL client (optional but useful for debugging/testing)
RUN apt-get update && apt-get install -y default-mysql-client

# Copy pom.xml and download dependencies (cache optimization)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy full project source
COPY src ./src

# Build Spring Boot JAR
RUN mvn clean package -DskipTests


# =========================
# Stage 2: Runtime Stage
# =========================
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy built jar from Stage 1
COPY --from=build /app/target/*.jar app.jar

# Expose application port
EXPOSE 8080

# Run Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]

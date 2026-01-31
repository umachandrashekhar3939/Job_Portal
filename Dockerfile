# =========================
# Stage 1: Build with Maven
# =========================
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom.xml and download dependencies first (for caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application JAR
RUN mvn clean package -DskipTests


# =========================
# Stage 2: Runtime (Java)
# =========================
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy JAR from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose application port
EXPOSE 8085

# Run Spring Boot app
ENTRYPOINT ["java", "-jar", "app.jar"]


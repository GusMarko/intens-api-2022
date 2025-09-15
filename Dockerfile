FROM maven:3.8.4-openjdk-8 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests


FROM openjdk:8-jre-slim
WORKDIR /app
ARG PORT
ENV PORT=${PORT}
COPY --from=build /app/target/*.jar app.jar
EXPOSE ${PORT}
RUN groupadd -r intensgroup && useradd -r -g intensgroup intensuser
RUN chown -R intensgroup:intensuser /app
USER javauser
ENTRYPOINT ["java", "-jar", "app.jar"]

# PROVEDCODE BACKEND PRODUCTION DOCKERFILE


# BUILD STAGE

FROM eclipse-temurin:17-jdk AS build

WORKDIR /app

COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .

RUN chmod +x ./mvnw

RUN ./mvnw dependency:go-offline

COPY src src

RUN ./mvnw clean package -DskipTests


# PRODUCTION STAGE

FROM eclipse-temurin:17-jre

RUN addgroup --system app && adduser --system app --ingroup app

WORKDIR /app

COPY --from=build /app/target/*.jar ./app.jar

RUN chown app:app ./app.jar

USER app

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]

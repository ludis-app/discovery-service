#
# Build stage
#
FROM maven:3.6.0-jdk-11-slim AS build
COPY pom.xml /opt/
COPY src /opt/src/
WORKDIR /opt
RUN mvn -f /opt/pom.xml clean package
COPY target/*.jar /opt/app.jar
ENTRYPOINT exec java $JAVA_OPTS -jar app.jar

#
# Package stage
#
FROM openjdk:11-jre-slim
COPY --from=build /opt/target/discovery-0.0.1-SNAPSHOT.jar /usr/local/lib/discovery.jar
ENV PORT 8761
EXPOSE 8761
ENTRYPOINT ["java","-jar","/usr/local/lib/discovery.jar"]
# Building jar
FROM openjdk:8-jdk-alpine as javajdk
WORKDIR /usr/src/app
COPY ./ ./
RUN chmod +x gradlew
RUN ./gradlew bootjar

# Run jar
FROM openjdk:8-jre-alpine
WORKDIR /usr/src/app
COPY --from=javajdk /usr/src/app/build/libs/demo-0.0.1-SNAPSHOT.jar ./springapp.jar
CMD java -jar springapp.jar


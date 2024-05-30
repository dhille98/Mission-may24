FROM adoptopenjdk/openjdk11
  
EXPOSE 8080
 
ENV APP_HOME /usr/src/app

COPY target/Assignment3_MihyeBang-0.0.1-SNAPSHOT.jar $APP_HOME/Assignment3_MihyeBang-0.0.1-SNAPSHOT.jar

WORKDIR $APP_HOME

CMD ["java", "-jar", "Assignment3_MihyeBang-0.0.1-SNAPSHOT.jar"]

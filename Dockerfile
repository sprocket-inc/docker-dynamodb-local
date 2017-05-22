FROM openjdk:8-jre-alpine

RUN apk add --no-cache --no-progress --virtual .deps curl && \
  curl -sL http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest.tar.gz | tar xz && \
  apk del .deps

ENTRYPOINT ["/usr/bin/java", "-Djava.library.path=./DynamoDBLocal_lib", "-jar", "DynamoDBLocal.jar"]

CMD ["-help"]

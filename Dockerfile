FROM openjdk:8-jdk-alpine AS build-env

WORKDIR /root
RUN apk add --no-cache alpine-sdk bash subversion swig unzip zip
RUN ln -sf /bin/bash /bin/sh

# install groovy
RUN curl -s get.sdkman.io | bash
RUN bash -c 'source "$HOME/.sdkman/bin/sdkman-init.sh"; sdk install groovy'

# install gant
RUN mkdir .gradle && echo "gant_installPath = \${System.properties.'user.home'}/lib/gant" > .gradle/gradle.properties
RUN curl -sL https://github.com/Gant/Gant/archive/1.9.11.tar.gz | tar xz
WORKDIR /root/Gant-1.9.11
RUN ./gradlew :gant:install

# build sqlite4java
WORKDIR /root
RUN git clone -b linux-gccv4 https://bitbucket.org/almworks/sqlite4java.git
WORKDIR /root/sqlite4java/ant
RUN sed -i.org -e '/^platforms=/s/linux-i386, //' linux.properties
RUN bash -c 'source "$HOME/.sdkman/bin/sdkman-init.sh"; ~/lib/gant/bin/gant all'


FROM openjdk:8-jre-alpine

RUN apk add --no-cache --no-progress --virtual .deps curl && \
  curl -sL http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest.tar.gz | tar xz && \
  apk del .deps
COPY --from=build-env /root/sqlite4java/build/dist/libsqlite4java-linux-amd64.so /DynamoDBLocal_lib

ENTRYPOINT ["/usr/bin/java", "-Djava.library.path=./DynamoDBLocal_lib", "-jar", "DynamoDBLocal.jar"]

CMD ["-help"]

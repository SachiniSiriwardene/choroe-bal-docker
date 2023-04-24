FROM ballerina/ballerina:2201.3.1 AS ballerina-builder

USER root

ADD . /src

WORKDIR /src




RUN bal build --sticky

FROM ballerina/jvm-runtime:1.0 







FROM adoptopenjdk/openjdk11:x86_64-alpine-jre-11.0.19_7




RUN addgroup troupe \
   && adduser -S -s /bin/bash -g 'ballerina' -G troupe -D 10014 \
   && apk add --update --no-cache bash \
   && rm -rf /var/cache/apk/*

WORKDIR /home/ballerina

LABEL maintainer="dev@ballerina.io"

RUN apk add --update make 
RUN apk add pkgconfig
RUN apk --update add redis







COPY --from=ballerina-builder /src/target/bin/greeting_service.jar /home/ballerina/
COPY --from=ballerina-builder /src/script.sh /home/ballerina/

RUN chmod +x /home/ballerina/script.sh



RUN chown 10014 /home/ballerina/greeting_service.jar




EXPOSE 9090

EXPOSE 6379



USER 10014




ENTRYPOINT ["/home/ballerina/script.sh"]



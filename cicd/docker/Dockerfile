FROM java:8-jre-alpine
COPY demo_http_microservice-1.1.0.jar app.jar

COPY docker-entrypoint.sh /
RUN dos2unix /docker-entrypoint.sh && chmod 755 /docker-entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/docker-entrypoint.sh"]

FROM jetty:alpine

ARG WEBSERVICE_URL

ENV JETTY_WEBAPPS "$JETTY_BASE"/webapps
ENV OFFICE_HOME /usr/lib/libreoffice

ENV WEBCLIENT_WAR http://jenkins-paderborn.tei-c.org/job/OxGarage/lastSuccessfulBuild/artifact/ege-webclient/target/ege-webclient.war
ENV WEBSERVICE_WAR http://jenkins-paderborn.tei-c.org/job/OxGarage/lastSuccessfulBuild/artifact/ege-webservice/target/ege-webservice.war
ENV WEBSERVICE_URL ${WEBSERVICE_URL:-http://localhost:8080/ege-webservice/}

USER root:root

RUN apk --update add libreoffice \
    ttf-dejavu \
    ttf-linux-libertine \ 
    font-noto \
    && ln -s $OFFICE_HOME /usr/lib/openoffice 

COPY oxgarage.properties /etc/
COPY log4j.xml /var/cache/oxgarage/log4j.xml

ADD $WEBCLIENT_WAR /tmp/
ADD $WEBSERVICE_WAR /tmp/
       
RUN mkdir "$JETTY_WEBAPPS"/ege-webclient \
    && unzip -q /tmp/ege-webclient.war -d "$JETTY_WEBAPPS"/ege-webclient/ \
    && rm /tmp/ege-webclient.war
RUN mkdir "$JETTY_WEBAPPS"/ege-webservice \
    && unzip -q /tmp/ege-webservice.war -d "$JETTY_WEBAPPS"/ege-webservice/ \
    && rm /tmp/ege-webservice.war

COPY webservice_web.xml "$JETTY_WEBAPPS"/ege-webservice/WEB-INF/web.xml
COPY entrypoint.sh /

# add some Jetty jars needed for CORS support
ADD http://central.maven.org/maven2/org/eclipse/jetty/jetty-servlets/9.4.7.v20170914/jetty-servlets-9.4.7.v20170914.jar "$JETTY_WEBAPPS"/ege-webservice/WEB-INF/lib/
ADD http://central.maven.org/maven2/org/eclipse/jetty/jetty-util/9.4.7.v20170914/jetty-util-9.4.7.v20170914.jar "$JETTY_WEBAPPS"/ege-webservice/WEB-INF/lib/

RUN chown -R jetty:jetty \
    /var/cache/oxgarage \
    "$JETTY_WEBAPPS"/* \
    /entrypoint.sh \
    && chmod 755 /entrypoint.sh

USER jetty:jetty
VOLUME ["/usr/share/xml/tei/stylesheet", "/usr/share/xml/tei/odd"]
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
CMD ["java","-jar","/usr/local/jetty/start.jar"]

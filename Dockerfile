FROM jetty:alpine

ENV JETTY_WEBAPPS "$JETTY_BASE"/webapps
ENV OFFICE_HOME /usr/lib/libreoffice

ENV STYLESHEETS_URL http://jenkins.tei-c.org/job/Stylesheets/lastSuccessfulBuild/artifact/tei-xsl-7.43.0.zip
ENV WEBCLIENT_URL http://jenkins.tei-c.org/job/OxGarage/lastSuccessfulBuild/artifact/ege-webclient/target/ege-webclient.war
ENV WEBSERVICE_URL http://jenkins.tei-c.org/job/OxGarage/lastSuccessfulBuild/artifact/ege-webservice/target/ege-webservice.war

USER root:root
COPY oxgarage.properties /etc/
COPY log4j.xml /var/cache/oxgarage/log4j.xml

ADD $STYLESHEETS_URL /tmp/
ADD $WEBCLIENT_URL /tmp/
ADD $WEBSERVICE_URL /tmp/

RUN unzip -q /tmp/tei-xsl*.zip -d  /usr/share/ \
    && rm /tmp/tei-xsl*.zip
RUN mkdir "$JETTY_WEBAPPS"/ege-webclient \
    && unzip -q /tmp/ege-webclient.war -d "$JETTY_WEBAPPS"/ege-webclient/ \
    && rm /tmp/ege-webclient.war
RUN mkdir "$JETTY_WEBAPPS"/ege-webservice \
    && unzip -q /tmp/ege-webservice.war -d "$JETTY_WEBAPPS"/ege-webservice/ \
    && rm /tmp/ege-webservice.war
RUN apk --update add libreoffice \
    ttf-dejavu \
    ttf-linux-libertine \ 
    font-noto \
    && ln -s $OFFICE_HOME /usr/lib/openoffice 

RUN chown -R jetty:jetty /var/cache/oxgarage \
    "$JETTY_WEBAPPS"/*

USER jetty:jetty

EXPOSE 8080

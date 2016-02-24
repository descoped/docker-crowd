# Basics
#
FROM docker-atlassian-base
#MAINTAINER Nicola Paolucci <npaolucci@atlassian.com>

# Install Crowd

ENV CROWD_VERSION 2.7.2
RUN curl -Lks http://www.atlassian.com/software/crowd/downloads/binary/atlassian-crowd-${CROWD_VERSION}.tar.gz -o /root/crowd.tar.gz
RUN /usr/sbin/useradd --create-home --home-dir /opt/crowd --groups atlassian --shell /bin/bash crowd
RUN tar zxf /root/crowd.tar.gz --strip=1 -C /opt/crowd
RUN echo "crowd.home = /opt/atlassian-home" > /opt/crowd/crowd-webapp/WEB-INF/classes/crowd-init.properties
RUN mv /opt/crowd/apache-tomcat/webapps/ROOT /opt/crowd/splash-webapp
RUN mv /opt/crowd/apache-tomcat/conf/Catalina/localhost /opt/crowd/webapps
RUN mkdir /opt/crowd/apache-tomcat/conf/Catalina/localhost

ENV CROWD_URL http://localhost:8095/crowd
ENV LOGIN_BASE_URL http://localhost:8095

ENV CROWD_CONTEXT crowd
ENV CROWDID_CONTEXT openidserver
ENV OPENID_CLIENT_CONTEXT openidclient
ENV DEMO_CONTEXT demo
ENV SPLASH_CONTEXT ROOT

ADD splash-context.xml /opt/crowd/webapps/splash.xml
RUN chown -R crowd:crowd /opt/crowd
ADD launch.bash /launch
RUN chmod +x /launch

# Launching Crowd

VOLUME /opt/atlassian-home
WORKDIR /opt/crowd
EXPOSE 8095
USER crowd
CMD ["/launch"]

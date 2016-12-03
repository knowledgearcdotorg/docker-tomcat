FROM knowledgearcdotorg/base

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

ENV TOMCAT_MAJOR 9
ENV TOMCAT_VERSION 9.0.0.M13
ENV CATALINA_HOME /opt/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

RUN groupadd -r tomcat
RUN useradd -d $CATALINA_HOME -r -g tomcat tomcat

WORKDIR /opt/tomcat

RUN apt-get update && \
    apt-get install -y wget openjdk-8-jre-headless && \
    rm -rf /var/lib/apt/lists/*

RUN wget -O tomcat.tar.gz http://apache.mirror.amaze.com.au/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz && \
    tar -xzf tomcat.tar.gz --strip-components=1 && \
    rm tomcat.tar.gz && \
    chown -R tomcat: $CATALINA_HOME

COPY supervisord/tomcat.conf /etc/supervisor/conf.d/tomcat.conf

EXPOSE 8080

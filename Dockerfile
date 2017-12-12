FROM centos:centos6

#Install wget and install Java 8
RUN yum -y install wget
RUN mkdir -p /usr/java/
RUN wget --no-cookies \
         --no-check-certificate \
         --header "Cookie: oraclelicense=accept-securebackup-cookie" \
         "http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.tar.gz" \
         -O /tmp/jdk-8u151-linux-x64.tar.gz
RUN yum install wget -y tar && tar -xvf  /tmp/jdk-8u151-linux-x64.tar.gz -C /usr/java/
RUN wget "http://redrockdigimark.com/apachemirror/tomcat/tomcat-8/v8.0.47/bin/apache-tomcat-8.0.47.tar.gz" \
                 -O /apache-tomcat-8.0.47.tar.gz && \
            tar xvzf /apache-tomcat-8.0.47.tar.gz && \
    rm /apache-tomcat-8.0.47.tar.gz && \
    rm -rf /apache-tomcat-8.0.47/webapps/docs && \
    rm -rf /apache-tomcat-8.0.47/webapps/examples && \
    mv /apache-tomcat-8.0.47/ /var/ && \
    yum clean all

RUN yum -y install epel-release
ADD tomcat-users.xml /var/apache-tomcat-8.0.47/conf/tomcat-users.xml
ADD setenv.sh /var/apache-tomcat-8.0.47/bin/setenv.sh
RUN chmod 0755 /var/apache-tomcat-8.0.47/bin/setenv.sh
EXPOSE 8080
ENV CATALINA_HOME /var/apache-tomcat-8.0.47
CMD exec ${CATALINA_HOME}/bin/catalina.sh run

FROM stakater/java-centos:7-1.8

ENV SONAR_VERSION=7.1 \
    SONARQUBE_HOME=/opt/app/sonarqube \
    # Database configuration
    # Defaults to using H2
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=
    
# Change to user root to install jdk, cant install it with any other user
USER root 
RUN yum update -y && \
    yum install -y unzip && \
    yum clean all

# Again using non-root user i.e. stakater as set in base image
USER 10001

# Http port
EXPOSE 9000

# Comma separated list of Plugin URLS to install 
ARG PLUGIN_URLS="https://github.com/vaulttec/sonar-auth-oidc/releases/download/v1.0.4/sonar-auth-oidc-plugin-1.0.4.jar"

RUN set -x \
    # pub   2048R/D26468DE 2015-05-25
    #       Key fingerprint = F118 2E81 C792 9289 21DB  CAB4 CFCA 4A29 D264 68DE
    # uid                  sonarsource_deployer (Sonarsource Deployer) <infra@sonarsource.com>
    # sub   2048R/06855C1D 2015-05-25
    && (gpg --keyserver ha.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE \
	    || gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE) \
    && curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && curl -o sonarqube.zip.asc -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && rm sonarqube.zip* \
    && rm -rf $SONARQUBE_HOME/bin/*

# Install plugins
RUN mkdir -p ${SONARQUBE_HOME}/extensions/plugins \
    && cd ${SONARQUBE_HOME}/extensions/plugins \
    && IFS=, read -ra pluginUrlList <<< "$PLUGIN_URLS" \
       for plugin_url in "${pluginUrlList[@]}" \
       do \
         wget "${plugin_url}" \
       done
        
VOLUME "$SONARQUBE_HOME/data"

WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/
ENTRYPOINT ["./bin/run.sh"]
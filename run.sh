#!/bin/bash

set -e

if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi


# Install plugins from download dir
mv ${HOME}/downloads/plugins/* ${SONARQUBE_HOME}/extensions/plugins

# WIP
if [ -f /opt/app/tmp/conf/sonar.properties ];
then
  echo "moving properties"
  mv /opt/app/tmp/conf/sonar.properties ${SONARQUBE_HOME}/conf/
fi

exec java -jar lib/sonar-application-$SONAR_VERSION.jar \
  -Dsonar.log.console=true \
  -Dsonar.jdbc.username="$SONARQUBE_JDBC_USERNAME" \
  -Dsonar.jdbc.password="$SONARQUBE_JDBC_PASSWORD" \
  -Dsonar.jdbc.url="$SONARQUBE_JDBC_URL" \
  -Dsonar.web.javaAdditionalOpts="$SONARQUBE_WEB_JVM_OPTS -Djava.security.egd=file:/dev/./urandom" \
  "$@"
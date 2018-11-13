#!/bin/bash

set -e

if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi


# Install plugins from download dir
mv ${HOME}/downloads/plugins/* ${SONARQUBE_HOME}/extensions/plugins

# Move conf from temp mount path to conf location
if [ -f ${CONF_MOUNT_PATH} ];
then
  rm -f ${SONARQUBE_HOME}/conf/sonar.properties
  mv ${CONF_MOUNT_PATH} ${SONARQUBE_HOME}/conf/
fi

exec java -jar lib/sonar-application-$SONAR_VERSION.jar \
  -Dsonar.log.console=true \
  -Dsonar.jdbc.username="$SONARQUBE_JDBC_USERNAME" \
  -Dsonar.jdbc.password="$SONARQUBE_JDBC_PASSWORD" \
  -Dsonar.jdbc.url="$SONARQUBE_JDBC_URL" \
  -Dsonar.web.javaAdditionalOpts="$SONARQUBE_WEB_JVM_OPTS -Djava.security.egd=file:/dev/./urandom" \
  "$@"
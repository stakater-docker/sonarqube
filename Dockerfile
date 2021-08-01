FROM docker.io/sonarqube:8.9.2-community

ENV CUSTOM_PLUGINS_DIR=/opt/sonarqube/extensions/plugins
RUN chown -R sonarqube:sonarqube ${CUSTOM_PLUGINS_DIR}

ADD https://github.com/rht-labs/sonar-auth-openshift/releases/download/v1.2.0/sonar-auth-openshift-plugin.jar ${CUSTOM_PLUGINS_DIR}
ADD https://github.com/dmeiners88/sonarqube-prometheus-exporter/releases/download/v1.0.0-SNAPSHOT-2018-07-04/sonar-prometheus-exporter-1.0.0-SNAPSHOT.jar ${CUSTOM_PLUGINS_DIR}

FROM docker.io/sonarqube:7.9.1-community

USER root
ARG sonar_plugins="pmd ldap"
ADD sonar.properties /opt/sonarqube/conf/sonar.properties
ADD run.sh /opt/sonarqube/bin/run.sh
CMD /opt/sonarqube/bin/run.sh
RUN cp -a /opt/sonarqube/data /opt/sonarqube/data-init && \
	cp -a /opt/sonarqube/extensions /opt/sonarqube/extensions-init && \
	chown root:root /opt/sonarqube && chmod -R gu+rwX /opt/sonarqube
ADD plugins.sh /opt/sonarqube/bin/plugins.sh
ADD https://github.com/rht-labs/sonar-auth-openshift/releases/latest/download/sonar-auth-openshift-plugin.jar /opt/sonarqube/extensions-init/plugins/
ADD https://github.com/dmeiners88/sonarqube-prometheus-exporter/releases/download/v1.0.0-SNAPSHOT-2018-07-04/sonar-prometheus-exporter-1.0.0-SNAPSHOT.jar /opt/sonarqube/extensions-init/plugins/
RUN /opt/sonarqube/bin/plugins.sh $sonar_plugins
RUN chown root:root /opt/sonarqube -R; \
    chmod 6775 /opt/sonarqube -R
USER 1001

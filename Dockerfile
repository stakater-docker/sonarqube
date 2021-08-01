FROM docker.io/sonarqube:8.9.2-community

ADD https://github.com/rht-labs/sonar-auth-openshift/releases/download/v1.2.0/sonar-auth-openshift-plugin.jar /opt/sonarqube/extensions/plugins
ADD https://github.com/dmeiners88/sonarqube-prometheus-exporter/releases/download/v1.0.0-SNAPSHOT-2018-07-04/sonar-prometheus-exporter-1.0.0-SNAPSHOT.jar /opt/sonarqube/extensions/plugins
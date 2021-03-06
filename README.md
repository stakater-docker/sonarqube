# SonarQube Docker Image

Docker Image for SonarQube with required plugins installed.


## Plugins
- OpenID Connect (https://github.com/vaulttec/sonar-auth-oidc)
- Build Breaker (Jar in `plugins` directory. Built from: https://github.com/mstoecklmayr/sonar-build-breaker/tree/eed385d28523962f4a82dfaebd690df1ec20a8d3)

## Mounting config file
Mount config files to `/opt/app/tmp/conf/` instead of the actual `${SONARQUBE_HOME}/conf` location in order to preserve the user's (10001) ownership.
The start script will copy it to the actual location.

Update the `CONF_MOUNT_PATH` variable if you need to change the name of the config file from `sonar.properties` to something else. 

## Reference
- https://github.com/SonarSource/docker-sonarqube
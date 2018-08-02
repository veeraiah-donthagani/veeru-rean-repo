#!/bin/bash
export CATALINA_OPTS="-Djava.security.egd=file:/dev/./urandom $CATALINA_OPTS"
export CATALINA_OPTS="-Djenkins.install.runSetupWizard=false $CATALINA_OPTS"
export JENKINS_HOME="/opt/jenkins"
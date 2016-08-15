#/bin/sh
java \
  -Xmx512m \
  -Dcryptomator.logPath=/var/log/cryptomator.log \
  -Dcryptomator.settingsPath=/etc/cryptomator.properties \
  -jar /usr/share/java/cryptomator/Cryptomator-##CRYPTOMATOR_VERSION##.jar

#/bin/sh
java \
  -Xmx512m \
  -Dcryptomator.logPath=~/.Cryptomator/cryptomator.log \
  -Dcryptomator.upgradeLogPath=~/.Cryptomator/upgrade.log \
  -jar /usr/share/java/cryptomator/Cryptomator-##CRYPTOMATOR_VERSION##.jar

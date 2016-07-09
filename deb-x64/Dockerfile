FROM debian:7
MAINTAINER sebastian.stenzel@cryptomator.org

ENV LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_COLLATE=C \
	LC_CTYPE=en_US.UTF-8 \
	JDK_FULL_VERSION="jdk1.8.0_92" \
	JDK_DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jdk-8u92-linux-x64.tar.gz" \
	JCE_POLICY_URL="http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip" \
	ANT_DOWNLOAD_URL="http://mirrors.ae-online.de/apache/ant/binaries/apache-ant-1.9.7-bin.tar.gz"

# Install Build Dependencies
RUN apt-get update \
	&& apt-get -y --no-install-recommends install curl unzip ca-certificates fakeroot \
	&& apt-get clean
RUN cd /tmp \
	&& curl -L --cookie 'oraclelicense=accept-securebackup-cookie;' ${JDK_DOWNLOAD_URL} -o jdk.tar.gz \
	&& mkdir -p /usr/lib/jvm \
	&& tar -xzf jdk.tar.gz -C /usr/lib/jvm \
	&& rm jdk.tar.gz
RUN cd /tmp \
	&& curl -L --cookie 'oraclelicense=accept-securebackup-cookie;' ${JCE_POLICY_URL} -o jce-policy.zip \
	&& unzip -j -o jce-policy.zip *.jar -d /usr/lib/jvm/${JDK_FULL_VERSION}/jre/lib/security \
	&& rm jce-policy.zip
RUN cd /tmp \
	&& curl -L ${ANT_DOWNLOAD_URL} -o ant.tar.gz \
	&& mkdir -p /usr/local/ant \
	&& tar -xzf ant.tar.gz \
	&& mv apache-ant-*/* /usr/local/ant \
	&& rm ant.tar.gz \
	&& ln -s /usr/local/ant/bin/ant /usr/local/bin/ant

ENV CRYPTOMATOR_VERSION=1.1.2 \
	BINTRAY_API_KEY=toBeSpecifiedWhenRunningThisContainer \
	GPG_PASSPHRASE=toBeSpecifiedWhenRunningThisContainer

# Build and upload DEB package
CMD cd /home \
	&& curl -L https://github.com/cryptomator/cryptomator/releases/download/${CRYPTOMATOR_VERSION}/antkit.tar.gz -o antkit.tar.gz \
	&& tar -xzf antkit.tar.gz \
	&& export JAVA_HOME="/usr/lib/jvm/${JDK_FULL_VERSION}" \
	&& export ANT_HOME="/usr/local/ant" \
	&& ant deb \
	&& curl -T antbuild/bundles/cryptomator-*.deb -ucryptobot:${BINTRAY_API_KEY} \
		-H "X-Bintray-Package:cryptomator" \
		-H "X-Bintray-Version:${CRYPTOMATOR_VERSION}" \
		-H "X-Bintray-Debian-Distribution:wheezy" \
		-H "X-Bintray-Debian-Component:contrib" \
		-H "X-Bintray-Debian-Architecture:amd64" \
		-H "X-GPG-PASSPHRASE:${GPG_PASSPHRASE}" \
		https://api.bintray.com/content/cryptomator/cryptomator-deb/cryptomator-${CRYPTOMATOR_VERSION}-amd64.deb

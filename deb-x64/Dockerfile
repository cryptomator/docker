FROM debian:8
MAINTAINER sebastian.stenzel@cryptomator.org

ENV LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_COLLATE=C \
	LC_CTYPE=en_US.UTF-8 \
	JDK_FULL_VERSION="jdk1.8.0_92" \
	JDK_DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jdk-8u92-linux-x64.tar.gz" \
	JCE_POLICY_URL="http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip"

# Install Build Dependencies
RUN apt-get update \
	&& apt-get -y --no-install-recommends install curl unzip ant fakeroot \
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
RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/${JDK_FULL_VERSION}/bin/java 99999999 \
	&& update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/${JDK_FULL_VERSION}/bin/javac 99999999

ENV CRYPTOMATOR_VERSION=1.0.3d \
	BINTRAY_API_KEY=toBeSpecifiedWhenRunningThisContainer

# Build and upload DEB package
CMD cd /home \
	&& curl -L https://github.com/cryptomator/cryptomator/releases/download/${CRYPTOMATOR_VERSION}/antkit.tar.gz -o antkit.tar.gz \
	&& tar -xzf antkit.tar.gz \
	&& export JAVA_HOME="/usr/lib/jvm/${JDK_FULL_VERSION}" \
	&& ant deb \
	&& curl -T antbuild/bundles/cryptomator-*.deb -ucryptobot:${BINTRAY_API_KEY} \
		-H "X-Bintray-Package:cryptomator" \
		-H "X-Bintray-Version:${CRYPTOMATOR_VERSION}" \
		-H "X-Bintray-Debian-Distribution:wheezy" \
		-H "X-Bintray-Debian-Component:contrib" \
		-H "X-Bintray-Debian-Architecture:amd64" \
		https://api.bintray.com/content/cryptomator/cryptomator-deb/cryptomator-${CRYPTOMATOR_VERSION}-amd64.deb

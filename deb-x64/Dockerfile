FROM debian:8
MAINTAINER sebastian.stenzel@cryptomator.org

ENV LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_COLLATE=C \
	LC_CTYPE=en_US.UTF-8 \
	CRYPTOMATOR_VERSION=1.0.3c \
	JDK_FULL_VERSION="jdk1.8.0_92" \
	JDK_DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jdk-8u92-linux-x64.tar.gz" \
	JCE_POLICY_URL="http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip"

# Install Build Dependencies
RUN apt-get update \
	&& apt-get -y --no-install-recommends install wget unzip ant fakeroot \
	&& apt-get clean
RUN cd /tmp \
	&& wget -O jdk.tar.gz --progress=dot:giga --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "${JDK_DOWNLOAD_URL}" \
	&& mkdir -p /usr/lib/jvm \
	&& tar -xzf jdk.tar.gz -C /usr/lib/jvm \
	&& rm jdk.tar.gz
RUN cd /tmp \
	&& wget -O jce-policy.zip --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "${JCE_POLICY_URL}" \
	&& unzip -j -o jce-policy.zip *.jar -d /usr/lib/jvm/${JDK_FULL_VERSION}/jre/lib/security \
	&& rm jce-policy.zip
RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/${JDK_FULL_VERSION}/bin/java 99999999 \
	&& update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/${JDK_FULL_VERSION}/bin/javac 99999999

# Build deb (TODO)
# WORKDIR /home
# CMD wget --progress=dot:mega -O antkit.tar.gz -L https://github.com/cryptomator/cryptomator/releases/download/${CRYPTOMATOR_VERSION}/antkit.tar.gz \
# 	&& tar -xzf antkit.tar.gz \
# 	&& export JAVA_HOME="/usr/java/${JDK_FULL_VERSION}" \
# 	&& ant deb

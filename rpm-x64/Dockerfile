FROM centos:7
MAINTAINER sebastian.stenzel@cryptomator.org

ENV LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_COLLATE=C \
	LC_CTYPE=en_US.UTF-8 \
	JDK_FULL_VERSION="jdk1.8.0_92" \
	JDK_DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jdk-8u92-linux-x64.rpm" \
	JCE_POLICY_URL="http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip"

# Install Build Dependencies
RUN yum makecache \
	&& yum -y install curl unzip ant alternatives rpm-build \
	&& yum clean all
RUN cd /tmp \
	&& curl -L --cookie 'oraclelicense=accept-securebackup-cookie;' ${JDK_DOWNLOAD_URL} -o jdk.rpm \
	&& yum -y localinstall jdk.rpm \
	&& rm jdk.rpm \
	&& yum clean all
RUN cd /tmp \
	&& curl -L --cookie 'oraclelicense=accept-securebackup-cookie;' ${JCE_POLICY_URL} -o jce-policy.zip \
	&& unzip -j -o jce-policy.zip *.jar -d /usr/java/${JDK_FULL_VERSION}/jre/lib/security \
	&& rm jce-policy.zip
RUN alternatives --install /usr/bin/java java /usr/java/latest/jre/bin/java 99999999 \
	&& alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 99999999

ENV CRYPTOMATOR_VERSION=1.0.3d \
	BINTRAY_API_KEY=toBeSpecifiedWhenRunningThisContainer

# Build and upload RPM package
CMD cd /home \
	&& curl -L https://github.com/cryptomator/cryptomator/releases/download/${CRYPTOMATOR_VERSION}/antkit.tar.gz -o antkit.tar.gz \
	&& tar -xzf antkit.tar.gz \
	&& export JAVA_HOME="/usr/java/latest" \
	&& ant rpm \
	&& ls -laR antbuild/bundles \
	&& curl -T antbuild/bundles/cryptomator-*.rpm -ucryptobot:${BINTRAY_API_KEY} \
		-H "X-Bintray-Package:cryptomator" \
		-H "X-Bintray-Version:${CRYPTOMATOR_VERSION}" \
		https://api.bintray.com/content/cryptomator/cryptomator-rpm/cryptomator-${CRYPTOMATOR_VERSION}-amd64.rpm

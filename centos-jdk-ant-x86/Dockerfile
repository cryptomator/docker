FROM centos:7
MAINTAINER sebastian.stenzel@cryptomator.org

ENV LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_COLLATE=C \
	LC_CTYPE=en_US.UTF-8 \
	JDK_FULL_VERSION="jdk1.8.0_152" \
	JAVA_HOME="/usr/lib/jvm/jdk1.8.0_152" \
	JDK_DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jdk/8u152-b16/aa0333dd3019491ca4f6ddbe78cdb6d0/jdk-8u152-linux-i586.tar.gz" \
	ANT_HOME="/usr/local/ant" \
	ANT_DOWNLOAD_URL="http://mirror.netcologne.de/apache.org//ant/binaries/apache-ant-1.10.1-bin.tar.gz"

# Install Build Dependencies
RUN yum makecache \
	&& yum -y install curl unzip rpm-build glibc.i686 libstdc++.i686 \
	&& yum clean all
RUN cd /tmp \
	&& curl -L --cookie 'oraclelicense=accept-securebackup-cookie;' ${JDK_DOWNLOAD_URL} -o jdk.tar.gz \
	&& mkdir -p `dirname ${JAVA_HOME}` \
	&& tar -xzf jdk.tar.gz -C `dirname ${JAVA_HOME}` \
	&& rm jdk.tar.gz
RUN sed -i 's|#crypto.policy=unlimited|crypto.policy=unlimited|' "${JAVA_HOME}/jre/lib/security/java.security"
RUN cd /tmp \
	&& curl -L ${ANT_DOWNLOAD_URL} -o ant.tar.gz \
	&& mkdir -p /usr/local/ant \
	&& tar -xzf ant.tar.gz \
	&& mv apache-ant-*/* ${ANT_HOME} \
	&& rm ant.tar.gz \
	&& ln -s ${ANT_HOME}/bin/ant /usr/local/bin/ant

CMD ant -version

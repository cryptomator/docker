FROM cryptomator/debian-jdk-ant-x64
MAINTAINER sebastian.stenzel@cryptomator.org

ENV CRYPTOMATOR_VERSION=1.2.0 \
	BINTRAY_API_KEY=toBeSpecifiedWhenRunningThisContainer \
	GPG_PASSPHRASE=toBeSpecifiedWhenRunningThisContainer

# Build and upload DEB package
CMD cd /home \
	&& curl -L https://github.com/cryptomator/cryptomator/releases/download/${CRYPTOMATOR_VERSION}/antkit.tar.gz -o antkit.tar.gz \
	&& tar -xzf antkit.tar.gz \
	&& ant deb \
	&& curl -T antbuild/bundles/cryptomator-*.deb -u cryptobot:${BINTRAY_API_KEY} \
		-H "X-Bintray-Package:cryptomator" \
		-H "X-Bintray-Version:${CRYPTOMATOR_VERSION}" \
		-H "X-Bintray-Debian-Distribution:wheezy" \
		-H "X-Bintray-Debian-Component:contrib" \
		-H "X-Bintray-Debian-Architecture:amd64" \
		-H "X-GPG-PASSPHRASE:${GPG_PASSPHRASE}" \
		https://api.bintray.com/content/cryptomator/cryptomator-deb/cryptomator-${CRYPTOMATOR_VERSION}-amd64.deb \
	&& curl -X POST -u cryptobot:${BINTRAY_API_KEY} \
		-H "X-GPG-PASSPHRASE:${GPG_PASSPHRASE}" \
		https://api.bintray.com/gpg/cryptomator/cryptomator-deb/cryptomator-${CRYPTOMATOR_VERSION}-amd64.deb \
	&& curl -X POST -u cryptobot:${BINTRAY_API_KEY} \
		-H "X-GPG-PASSPHRASE:${GPG_PASSPHRASE}" \
		https://api.bintray.com/calc_metadata/cryptomator/cryptomator-deb/

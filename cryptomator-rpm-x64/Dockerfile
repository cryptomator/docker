FROM cryptomator/centos-jdk-ant-x64
MAINTAINER sebastian.stenzel@cryptomator.org

ENV CRYPTOMATOR_VERSION=1.2.0 \
	BINTRAY_API_KEY=toBeSpecifiedWhenRunningThisContainer \
	GPG_PASSPHRASE=toBeSpecifiedWhenRunningThisContainer

# Build and upload RPM package
CMD cd /home \
	&& curl -L https://github.com/cryptomator/cryptomator/releases/download/${CRYPTOMATOR_VERSION}/antkit.tar.gz -o antkit.tar.gz \
	&& tar -xzf antkit.tar.gz \
	&& ant rpm \
	&& curl -T antbuild/bundles/cryptomator-*.rpm -u cryptobot:${BINTRAY_API_KEY} \
		-H "X-Bintray-Package:cryptomator" \
		-H "X-Bintray-Version:${CRYPTOMATOR_VERSION}" \
		-H "X-GPG-PASSPHRASE:${GPG_PASSPHRASE}" \
		https://api.bintray.com/content/cryptomator/cryptomator-rpm/cryptomator-${CRYPTOMATOR_VERSION}-amd64.rpm \
	&& curl -X POST -u cryptobot:${BINTRAY_API_KEY} \
		-H "X-GPG-PASSPHRASE:${GPG_PASSPHRASE}" \
		https://api.bintray.com/gpg/cryptomator/cryptomator-rpm/cryptomator-${CRYPTOMATOR_VERSION}-amd64.rpm \
	&& curl -X POST -u cryptobot:${BINTRAY_API_KEY} \
		-H "X-GPG-PASSPHRASE:${GPG_PASSPHRASE}" \
		https://api.bintray.com/calc_metadata/cryptomator/cryptomator-rpm/

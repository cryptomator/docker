#!/bin/bash

# cleanup
rm cryptomator-linux.zip
rm -rf cryptomator_*

# download and prepare sources
curl -o buildkit-linux.zip -L http://dl.bintray.com/cryptomator/cryptomator/${BUILDKIT_VERSION}/buildkit-linux.zip
unzip buildkit-linux.zip -d cryptomator_${PACKAGE_VERSION}
mk-origtargz --repack --package=cryptomator --version=${PACKAGE_VERSION} buildkit-linux.zip
cp -r debian cryptomator_${PACKAGE_VERSION}/debian
pushd cryptomator_${PACKAGE_VERSION}

# substitute variables
RFC2822_TIMESTAMP=`date --rfc-2822`
LAUNCHER_VERSION=`cat libs/version.txt`
sed -i -e "s/##PACKAGE_VERSION##/${PACKAGE_VERSION}/g" debian/org.cryptomator.Cryptomator.desktop
sed -i -e "s/##PPA_VERSION##/${PPA_VERSION}/g" debian/changelog
sed -i -e "s/##RFC2822_TIMESTAMP##/${RFC2822_TIMESTAMP}/g" debian/changelog
sed -i -e "s/%LAUNCHER_VERSION%/${LAUNCHER_VERSION}/g" debian/rules
ls -1d libs/*.jar >> debian/source/include-binaries

# build source package
if [[ ${PPA_VERSION} =~ .*ppa1$ ]]
then
  debuild -S -sa -uc -us
else
  debuild -S -sd -uc -us
fi

# sign .dsc file by hand (debsign would need a tty)
popd
DSC_SIZE_ORIG=`wc -c < cryptomator_${PPA_VERSION}.dsc`
DSC_MD5_ORIG=`md5sum cryptomator_${PPA_VERSION}.dsc | cut -d' ' -f1`
DSC_SHA1_ORIG=`sha1sum cryptomator_${PPA_VERSION}.dsc | cut -d' ' -f1`
DSC_SHA256_ORIG=`sha256sum cryptomator_${PPA_VERSION}.dsc | cut -d' ' -f1`
gpg --clearsign --no-tty --passphrase ${GPG_PASSPHRASE} --output cryptomator_${PPA_VERSION}.dsc.gpg cryptomator_${PPA_VERSION}.dsc
mv cryptomator_${PPA_VERSION}.dsc.gpg cryptomator_${PPA_VERSION}.dsc
DSC_SIZE_NEW=`wc -c < cryptomator_${PPA_VERSION}.dsc | cut -d' ' -f1`
DSC_MD5_NEW=`md5sum cryptomator_${PPA_VERSION}.dsc | cut -d' ' -f1`
DSC_SHA1_NEW=`sha1sum cryptomator_${PPA_VERSION}.dsc | cut -d' ' -f1`
DSC_SHA256_NEW=`sha256sum cryptomator_${PPA_VERSION}.dsc | cut -d' ' -f1`

# adjust and sign .changes file by hand
sed -i -e "s/${DSC_MD5_ORIG} ${DSC_SIZE_ORIG}/${DSC_MD5_NEW} ${DSC_SIZE_NEW}/g" cryptomator_${PPA_VERSION}_source.changes
sed -i -e "s/${DSC_SHA1_ORIG} ${DSC_SIZE_ORIG}/${DSC_SHA1_NEW} ${DSC_SIZE_NEW}/g" cryptomator_${PPA_VERSION}_source.changes
sed -i -e "s/${DSC_SHA256_ORIG} ${DSC_SIZE_ORIG}/${DSC_SHA256_NEW} ${DSC_SIZE_NEW}/g" cryptomator_${PPA_VERSION}_source.changes
gpg --clearsign --no-tty --passphrase ${GPG_PASSPHRASE} --output cryptomator_${PPA_VERSION}_source.changes.gpg cryptomator_${PPA_VERSION}_source.changes
mv cryptomator_${PPA_VERSION}_source.changes.gpg cryptomator_${PPA_VERSION}_source.changes

# upload
#dput ppa:sebastian-stenzel/cryptomator cryptomator_${PPA_VERSION}_source.changes

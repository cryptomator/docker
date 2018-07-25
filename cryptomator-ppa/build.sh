#!/bin/bash

# download and prepare sources
mkdir cryptomator_${PACKAGE_VERSION}
curl -o cryptomator-${APPIMG_VERSION}-x86_64.AppImage -L https://dl.bintray.com/cryptomator/cryptomator/cryptomator-${APPIMG_VERSION}-x86_64.AppImage
tar -czf cryptomator_${PACKAGE_VERSION}.orig.tar.gz cryptomator-${APPIMG_VERSION}-x86_64.AppImage
cp cryptomator-${APPIMG_VERSION}-x86_64.AppImage cryptomator_${PACKAGE_VERSION}/
cp -r debian cryptomator_${PACKAGE_VERSION}/debian
pushd cryptomator_${PACKAGE_VERSION}

# substitute variables
RFC2822_TIMESTAMP=`date --rfc-2822`
sed -i -e "s/##PACKAGE_VERSION##/${PACKAGE_VERSION}/g" debian/Cryptomator.desktop
sed -i -e "s/##PPA_VERSION##/${PPA_VERSION}/g" debian/changelog
sed -i -e "s/##RFC2822_TIMESTAMP##/${RFC2822_TIMESTAMP}/g" debian/changelog
sed -i -e "s/##APPIMG_VERSION##/${APPIMG_VERSION}/g" debian/cryptomator.links
sed -i -e "s/##APPIMG_VERSION##/${APPIMG_VERSION}/g" debian/source/include-binaries

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
dput ppa:sebastian-stenzel/cryptomator cryptomator_${PPA_VERSION}_source.changes

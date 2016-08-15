#!/bin/bash

# download and extract sources
curl -o cryptomator_${CRYPTOMATOR_VERSION}.orig.tar.gz -L https://github.com/cryptomator/cryptomator/releases/download/${CRYPTOMATOR_VERSION}/antkit.tar.gz
mkdir cryptomator_${CRYPTOMATOR_VERSION}
tar -xzf cryptomator_${CRYPTOMATOR_VERSION}.orig.tar.gz -C cryptomator_${CRYPTOMATOR_VERSION}
cp -r /var/build/debian cryptomator_${CRYPTOMATOR_VERSION}/debian
cd /var/build/cryptomator_${CRYPTOMATOR_VERSION}

# substitute variables
RFC2822_TIMESTAMP=`date --rfc-2822`
sed -i -e "s/##CRYPTOMATOR_VERSION##/${CRYPTOMATOR_VERSION}/g" debian/Cryptomator.desktop
sed -i -e "s/##CRYPTOMATOR_FULL_VERSION##/${CRYPTOMATOR_FULL_VERSION}/g" debian/changelog
sed -i -e "s/##RFC2822_TIMESTAMP##/${RFC2822_TIMESTAMP}/g" debian/changelog
sed -i -e "s/##CRYPTOMATOR_FULL_VERSION##/${CRYPTOMATOR_FULL_VERSION}/g" debian/files

# build source package
if [[ $CRYPTOMATOR_FULL_VERSION =~ .*ppa1$ ]]
then
  debuild -S -sa -uc -us
else
  debuild -S -sd -uc -us
fi

# sign .dsc file by hand (debsign would need a tty)
cd /var/build
DSC_SIZE_ORIG=`wc -c < cryptomator_${CRYPTOMATOR_FULL_VERSION}.dsc`
DSC_MD5_ORIG=`md5sum cryptomator_${CRYPTOMATOR_FULL_VERSION}.dsc | cut -d' ' -f1`
DSC_SHA1_ORIG=`sha1sum cryptomator_${CRYPTOMATOR_FULL_VERSION}.dsc | cut -d' ' -f1`
DSC_SHA256_ORIG=`sha256sum cryptomator_${CRYPTOMATOR_FULL_VERSION}.dsc | cut -d' ' -f1`
gpg --clearsign --no-tty --passphrase ${GPG_PASSPHRASE} --output cryptomator_${CRYPTOMATOR_FULL_VERSION}.dsc.gpg cryptomator_${CRYPTOMATOR_FULL_VERSION}.dsc
mv cryptomator_${CRYPTOMATOR_FULL_VERSION}.dsc.gpg cryptomator_${CRYPTOMATOR_FULL_VERSION}.dsc
DSC_SIZE_NEW=`wc -c < cryptomator_${CRYPTOMATOR_FULL_VERSION}.dsc | cut -d' ' -f1`
DSC_MD5_NEW=`md5sum cryptomator_${CRYPTOMATOR_FULL_VERSION}.dsc | cut -d' ' -f1`
DSC_SHA1_NEW=`sha1sum cryptomator_${CRYPTOMATOR_FULL_VERSION}.dsc | cut -d' ' -f1`
DSC_SHA256_NEW=`sha256sum cryptomator_${CRYPTOMATOR_FULL_VERSION}.dsc | cut -d' ' -f1`

# adjust and sign .changes file by hand
sed -i -e "s/${DSC_MD5_ORIG} ${DSC_SIZE_ORIG}/${DSC_MD5_NEW} ${DSC_SIZE_NEW}/g" cryptomator_${CRYPTOMATOR_FULL_VERSION}_source.changes
sed -i -e "s/${DSC_SHA1_ORIG} ${DSC_SIZE_ORIG}/${DSC_SHA1_NEW} ${DSC_SIZE_NEW}/g" cryptomator_${CRYPTOMATOR_FULL_VERSION}_source.changes
sed -i -e "s/${DSC_SHA256_ORIG} ${DSC_SIZE_ORIG}/${DSC_SHA256_NEW} ${DSC_SIZE_NEW}/g" cryptomator_${CRYPTOMATOR_FULL_VERSION}_source.changes
gpg --clearsign --no-tty --passphrase ${GPG_PASSPHRASE} --output cryptomator_${CRYPTOMATOR_FULL_VERSION}_source.changes.gpg cryptomator_${CRYPTOMATOR_FULL_VERSION}_source.changes
mv cryptomator_${CRYPTOMATOR_FULL_VERSION}_source.changes.gpg cryptomator_${CRYPTOMATOR_FULL_VERSION}_source.changes

cp * /var/build/dist

# upload
dput -ol ppa:sebastian-stenzel/cryptomator cryptomator_${CRYPTOMATOR_FULL_VERSION}_source.changes

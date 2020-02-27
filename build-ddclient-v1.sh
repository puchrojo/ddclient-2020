#!/bin/bash
DEBFULLNAME="Puch Rojo, Isaac" 
DEBEMAIL="puchrojo@gmail.com"

echo "Doku git-buildpackage: https://honk.sigxcpu.org/projects/git-buildpackage/manual-html/"
echo "ddclient Source Debian Package: https://packages.debian.org/source/buster/ddclient"

function cm {
    # print the command, bevor execute it. 
    echo $@
    $@
}

# Don't work for gbp
cat <<EOF >  ~/.pbuilderrc
AUTO_DEBSIGN=${AUTO_DEBSIGN:-no}
EOF
export AUTO_DEBSIGN=${AUTO_DEBSIGN:-no}
#echo $AUTO_DEBSIGN 

DEB_BUILD_OPTIONS="-us -uc -I -i"
export DEB_BUILD_OPTIONS="-us -uc -I -i"
# -uc -us  for no-sign 

# cat <<EOF > ~/.gbp.conf
# # the default build command
# builder=debuild -i\.git -I.git -us -uc 
# EOF

# For debsign ober ssh 
export GPG_TTY=$(tty)

rm -fr ddclient

# The old sources are buggy: 
# gbp import-dscs --debsnap  ddclient
# [...] UnicodeDecodeError: 'utf-8' codec can't decode byte 0xf6 in position 130: invalid start byte
# Maybe is better to start with git neu? Or ist not posible?

echo "Download Source Package ddclient_3.8.3-1.1.dsc"
wget --no-clobber http://deb.debian.org/debian/pool/main/d/ddclient/ddclient_3.8.3-1.1.dsc
wget --no-clobber http://deb.debian.org/debian/pool/main/d/ddclient/ddclient_3.8.3.orig.tar.gz
wget --no-clobber http://deb.debian.org/debian/pool/main/d/ddclient/ddclient_3.8.3-1.1.debian.tar.xz
cm gbp import-dsc ddclient_3.8.3-1.1.dsc

cd ddclient

# http://honk.sigxcpu.org/projects/git-buildpackage/manual-html/gbp.cfgfile.html
cat <<EOF > ./.git/.gbp.conf
# the default build command
builder=debuild -i\.git -I.git -us -uc 
EOF


# --------
# - main - 
# --------
cm gbp buildpackage

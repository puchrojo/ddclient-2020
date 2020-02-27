#!/bin/bash
echo "V4 try to build 3.9.1 without the old patch"

echo "ddclient homepage: https://ddclient.net/"
echo "ddclient git: https://github.com/ddclient/ddclient"
echo "The 3.8.3 is on sourceforge: https://sourceforge.net/p/ddclient/"
echo ""
function cm {
    # print the command, bevor execute it. 
    echo $@
    $@
}

echo "Clone the new ddclient git repo" 
if [ -d "ddclient-git.bk" ]; then echo source.bk is here ; else git clone https://github.com/ddclient/ddclient ddclient-git.bk ; fi

rm -fr ddclient-v4
cp -pr ddclient-git.bk  ddclient-v4

cm cd ddclient-v4

# http://honk.sigxcpu.org/projects/git-buildpackage/manual-html/gbp.cfgfile.html
cat <<EOF > ./.git/gbp.conf
[DEFAULT]
upstream-tag = v%(version)s
# the default build command
builder=debuild -i\.git -I.git -us -uc 
upstream-branch=v3.9.1
debian-branch=debian
EOF



echo "upstream branch v3.9.1"
cm git checkout -b v3.9.1 v3.9.1
echo "debian branch"
cm git checkout -b debian
echo "copy the debian conf from old version"
cm cp -r ../ddclient/debian ./

echo "Manuell debian/patches und so gelöscht"
rm -fr debian/patches/*
echo "Danach nur commit und gbp buildpackage"
echo "Die ganze History ist somit weg, quilt weg:"
sed -i 's/Build-Depends: debhelper (>= 5), po-debconf, xmlto, quilt/Build-Depends: debhelper (>= 5), po-debconf, xmlto/g' debian/control

echo "debian/ddclient files nicht ausgegliechen" 

echo "/etc/ddclient/ddclient.conf are the spected conf-file, but control generate the old one /etc/ddcleint.conf" 


# echo Dependences in control pflegen
# apt-get install perl libdata-validate-ip-perl libjson-any-perl
# in control
# Depends: perl, ${misc:Depends}, lsb-base (>= 3.1), libdata-validate-ip-perl, libjson-any-perl,
sed -i 's/Depends: perl, ${misc:Depends}, lsb-base (>= 3.1)/Depends: perl, ${misc:Depends}, lsb-base (>= 3.1), libdata-validate-ip-perl, libjson-any-perl,/g' debian/control


echo "Changelog manually edited"
cp ../changelog debian/changelog

# echo "Changelog wit gbp dch"
# #gbp dch
# # The Version are not from tags, I don't now why
# cm gbp dch --new-version=3.9.1

# #echo "doch nicht"
# #cm cp  /tmp/changelog-v3 debian/changelog

git add .
git commit -m"Build from git tag 3.9.1"

# echo "ignore patch or add it"
# ##cm dpkg-source --commit

# cm gbp pq import

# cm git add .
# git add .pc
# git commit -m"Build from git tag 3.9.1 (dpkg-source)"

cm gbp buildpackage




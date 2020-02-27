#!/bin/bash

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

rm -fr ddclient-git
cp -pr ddclient-git.bk  ddclient-git

cm cd ddclient-git

# http://honk.sigxcpu.org/projects/git-buildpackage/manual-html/gbp.cfgfile.html
cat <<EOF > ./.git/gbp.conf
[DEFAULT]
# the default build command
builder=debuild -i\.git -I.git -us -uc 
#--git-ignore-new
#git-upstream-branch=v3.8.3
#git-debian-branch=debian
# # Error: Use --git-ignore-branch to ignore or --git-debian-branch to set the branch name.

upstream-branch=v3.8.3
debian-branch=debian
EOF



echo "upstream branch v3.8.3"
cm git checkout -b v3.8.3 v3.8.3
echo "debian branch"
cm git checkout -b debian
cm cp -r ../ddclient/debian ./

echo "todo make with gbp dch"
gbp dch
echo "doch nicht"
#cm cp  /tmp/changelog-v3 debian/changelog


# echo "Manuell change the version in changelog"
# ed -s ./debian/changelog  << 'EOF'
# 0a
# ddclient (3.8.3-1.3) unstable; urgency=medium

#    * Build from git-tag 3.8.3 

# EOF


git add .
git commit -m"Build from git tag 3.8.3"

echo "ignore patch or add it"
cm dpkg-source --commit

#cm gbp pq import

cm git add .
git add .pc
git commit -m"Build from git tag 3.8.3 (dpkg-source)"

cm gbp buildpackage




#!/bin/bash

function cm {
    # print the command, bevor execute it. 
    echo $@
    $@
}

cd ddclient
# http://honk.sigxcpu.org/projects/git-buildpackage/manual-html/gbp.cfgfile.html
cat <<EOF > ./.git/.gbp.conf
# the default build command
builder=debuild -i\.git -I.git -us -uc --git-ignore-new
EOF

echo "Change the Version in changelog"
ed -s debian/changelog  << 'EOF'
0a
ddclient (3.8.3-1.2) unstable; urgency=medium

  * Test Build 

EOF


git add .
git commit -m"whatever"


cm gbp buildpackage

echo "ddclient_3.8.3-1.2_all.deb build with a new changelog version"


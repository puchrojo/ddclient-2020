
To build the Debian Package you need to execute

    cd workspace
    ./build-ddclient-v1.sh  # Build the old 3.8.3, I take the debian directory as basis
    ./build-ddclient-v4.sh  # Build the 3.9.1 Package

Now is only a really work in progress. You can install the package, but not upload in to Debian

# Bugs / ToDos

 * The configuration file is from /etc/ddclient.conf to /etc/ddclient/ddclient.conf moved.
 * The build don't apply the old paches, it build it without it. quilt is deactivated.
 * The offizial package don't build from git.



 
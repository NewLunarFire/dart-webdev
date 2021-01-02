#!/bin/bash

OS_NAME=`grep '^NAME=' /etc/os-release | sed -n -e 's/^NAME="\(.*\)"/\1/p'`

if [ "Ubuntu" = "$OS_NAME" ]; then
    if [[ -d /usr/lib/dart/bin ]]; then
        echo "Dart is already installed"
    else
        echo "Install dart"
        # Run only if using apt and if dart is not installed
        sudo apt-get update
        sudo apt-get install apt-transport-https
        sudo sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
        sudo sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'

        export PATH="$PATH:/usr/lib/dart/bin"
        echo 'Dart binaries have temporarily been added to path variable. Add them to your bash profile like this: echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> ~/.profile'
    fi

    # Install project
    dart pub get
else
    echo "This install script is only meant to be used on Ubuntu"
fi

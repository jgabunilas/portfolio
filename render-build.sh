#!/usr/bin/env bash
set -o errexit

# Set your desired Hugo version
HUGO_VERSION="0.148.1"
TAR_NAME="hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz"

# Download Hugo Extended
mkdir -p ~/tmp
wget -q -P ~/tmp https://github.com/gohugoio/hugo/releases/tag/v0.148.1/v${HUGO_VERSION}/${TAR_NAME}
tar -xzf ~/tmp/${TAR_NAME} -C ~/tmp

# Move Hugo binary to a safe location
mkdir -p "${HOME}/bin"
mv ~/tmp/hugo "${HOME}/bin/"
export PATH="${HOME}/bin:${PATH}"

# Build your site
hugo --gc --minify
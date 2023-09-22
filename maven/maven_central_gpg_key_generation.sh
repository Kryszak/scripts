#!/bin/bash

echo "Generate new gpg key"
gpg --gen-key

echo "Export private key to file"
gpg --export-secret-key -a "key user" > priv.key

echo "Send key to keyserver"
gpg --keyserver keyserver.ubuntu.com --send-keys "key id"


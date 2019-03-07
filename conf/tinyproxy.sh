#!/usr/bin/env bash

sed -e "s,%LISTEN_PORT%,$1," /opt/tinyproxy/tinyproxy.conf.template > ~/.tinyproxy.conf
sed -i -e "s,%TARGET_PORT%,$2," ~/.tinyproxy.conf
tinyproxy -d -c ~/.tinyproxy.conf

#!/usr/bin/env bash

sed -e "s,%PORT%,$1," /opt/tinyproxy/tinyproxy.conf.template > ~/.tinyproxy.conf
tinyproxy -d -c ~/.tinyproxy.conf

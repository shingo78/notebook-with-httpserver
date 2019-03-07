#!/usr/bin/env bash

sed -e "s,%PORT%,$1," tinyproxy.conf.template

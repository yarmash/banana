#!/bin/bash

find $(dirname $0)/../public/files -type d -empty |\
    xargs -r rmdir -v --ignore-fail-on-non-empty -p

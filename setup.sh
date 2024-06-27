#!/bin/bash

git submodule init
git submodule update --recursive

cd mavlink

echo "Generating mavlink 2.0 C library"
python3 -m pymavlink.tools.mavgen --lang=C --wire-protocol=2.0 --output=generated/include/mavlink/v2.0 message_definitions/v1.0/common.xml

cd -
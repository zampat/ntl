#!/bin/bash

# Script action:
# Copy all README file in NetEye documentation Module
#

# NTL plugin temp download DIR
WORK_DIR=/root/brst/

#Define the NTL monitoring-plugins to copy into PluginsContribDir/
NTL_DIR=${WORK_DIR}/ntl/

# Loop trough all Plugins
for README in $(find $NTL_DIR -name '*.md');
do
cp $README /usr/share/icingaweb2/modules/ntl/doc/
done


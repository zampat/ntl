#!/bin/bash

# Script action:
# Copy NTL monitoring plugins into PluginsContribDir/ folder
#

# NTL plugin temp download DIR
WORK_DIR=/root/brst/

#MONITORING_PLUGINS_CONTRIB_DIR="/neteye/shared/monitoring/plugins/"
DATE=`date +%Y%m%d`

#Define the NTL monitoring-plugins to copy into PluginsContribDir/
NTL_DIR=${WORK_DIR}/ntl/

# Valiation: Check existency of folder PluginsContrib and WORK_DIR

#if [ ! -d "${WORK_DIR}" ]
#then
#   mkdir -p ${WORK_DIR}
#fi

# Loop trough all Plugins
# Register all prefixes of Plugins to copy here
for PLUGIN in $(find $NTL_DIR -name '*.md');
do
cp $PLUGIN /usr/share/icingaweb2/modules/ntl/doc/
#echo $PLUGIN
done


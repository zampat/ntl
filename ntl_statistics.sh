#!/bin/bash

# Script action:
# Copy NTL monitoring plugins into PluginsContribDir/ folder
#

# NTL plugin temp download DIR
WORK_DIR=/tmp/ns

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
echo "[+] 099: install NTL monitoring plugins into PluginsContribDir/ [$MONITORING_PLUGINS_CONTRIB_DIR]"
COUNT_INVESTIGATED=0
for PLUGIN in $(find $NTL_DIR -name '*.json');
do
   INVESTIGATED=`/usr/bin/jq -r ."to_be_investigated" $PLUGIN`
   echo "INVESTIGATED=$INVESTIGATED"

   #echo "DOWNLOADABLE=$DOWNLOADABLE"
   if [ $INVESTIGATED == "yes" ]
	then
	COUNT_INVESTIGATED+=1
   fi
done

echo "COUNT_INVESTIGATED=$COUNT_INVESTIGATED"
echo "[i] 099: Done."
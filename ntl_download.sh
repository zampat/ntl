#!/bin/bash

# Script action:
# Check and download all "ITL Contributed CheckCommand" plugins into {PluginsContribDir}/ntl folder
# If a plugin already exists, a backup copy of the old one is created.

# NTL plugin temp download DIR
WORK_DIR=/tmp/ns

# Define the PluginContribDir - standard path on NetEye 4 is /neteye/shared/monitoring/plugins/
MONITORING_PLUGINS_CONTRIB_DIR="/neteye/shared/monitoring/plugins/"

#Define the NTL monitoring-plugins to copy into PluginsContribDir/
NTL_DIR=${WORK_DIR}/ntl/contributed_plugin_check_commands/

DATE=`date +%Y%m%d`

# Valiation: Check existency of folder PluginsContrib and WORK_DIR
if [ ! -d "${MONITORING_PLUGINS_CONTRIB_DIR}" ]
then
   mkdir -p ${MONITORING_PLUGINS_CONTRIB_DIR}
fi

if [ ! -d "${WORK_DIR}" ]
then
   mkdir -p ${WORK_DIR}
fi

# Loop trough all Plugins
# Register all prefixes of Plugins to copy here
echo "[+] 099: install NTL monitoring plugins into PluginsContribDir/ [$MONITORING_PLUGINS_CONTRIB_DIR]"

for PLUGIN in $(find $NTL_DIR -name '*.json');
do
   #Explore json file using jq to identify plugin_url, plugin_file_name, downloadable field 
   PLUGIN_SRC=`/usr/bin/jq -r ."plugin_url" $PLUGIN`
   PLUGIN_FILE=`/usr/bin/jq -r ."plugin_url" $PLUGIN | /usr/bin/rev | /usr/bin/cut -d / -f 1 | /usr/bin/rev`
   DOWNLOADABLE=`/usr/bin/jq -r ."downloadable" $PLUGIN`
   #The plugin download depends on downloadable field 
   if [ $DOWNLOADABLE == "yes" ]
   then
        echo "[+] Copying Monitoring Plugin ${!PLUGIN_FILE} from git to Plugins contrib dir: ${MONITORING_PLUGINS_CONTRIB_DIR}"
        cd $WORK_DIR
        wget $PLUGIN_SRC -O $PLUGIN_FILE

        # Check if Plugin already exists. If yes: backup first
        if [ -f ${MONITORING_PLUGINS_CONTRIB_DIR}/${PLUGIN_FILE} ]
        then
             #Verify if existing version is already up-to-date
             diff ${MONITORING_PLUGINS_CONTRIB_DIR}/${PLUGIN_FILE} ${WORK_DIR}/${PLUGIN_FILE} > /dev/null
             RES=$?
             if [ $RES -eq 0 ]
             then
                continue
             fi

             echo "[+] Creating Backup of ${PLUGIN_FILE}"
             cp --force ${MONITORING_PLUGINS_CONTRIB_DIR}/${PLUGIN_FILE} ${MONITORING_PLUGINS_CONTRIB_DIR}/${PLUGIN_FILE}.${DATE}_bak
        fi
        cp ${WORK_DIR}/${PLUGIN_FILE} ${MONITORING_PLUGINS_CONTRIB_DIR}
        echo "[i] Copied ${!PLUGIN_FILE}"
   else
        echo "[i] Plugin ${PLUGIN_FILE} not downloadable! Skipped!"
   fi
done

echo "[i] 099: Done."

#!/bin/bash

# Script action:
# Copy NTL monitoring plugins into PluginsContribDir/ folder
#

# the directory of the script
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# the temp directory used, within $DIR
# omit the -p parameter to create a temporal directory in the default location
#WORK_DIR=`mktemp -d -p "$DIR"`

# NTL plugin temp download DIR
WORK_DIR=/var/tmp

## check if tmp dir was created
#if [[ ! "$WORK_DIR" || ! -d "$WORK_DIR" ]]; then
#  echo "Could not create temp dir"
#  exit 1
#fi
#
## deletes the temp directory
#function cleanup {
#  rm -rf "$WORK_DIR"
#  echo "Deleted temp working directory $WORK_DIR"
#}
#
## register the cleanup function to be called on the EXIT signal
#trap cleanup EXIT

MONITORING_PLUGINS_CONTRIB_DIR="/neteye/shared/monitoring/plugins"
#MONITORING_PLUGINS_CONTRIB_DIR="$1"
DATE=`date +%Y%m%d`

#Define the NTL monitoring-plugins to copy into PluginsContribDir/
NTL_DIR=${WORK_DIR}/ntl/contributed_plugin_check_commands/

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
   PLUGIN_SRC=`/usr/bin/jq -r ."plugin_url" $PLUGIN`
   echo "PLUGIN_SRC=$PLUGIN_SRC"
   PLUGIN_FILE=`/usr/bin/jq -r ."plugin_url" $PLUGIN | /usr/bin/rev | /usr/bin/cut -d / -f 1 | /usr/bin/rev`
   echo "PLUGIN_FILE=$PLUGIN_FILE"
   DOWNLOADABLE=`/usr/bin/jq -r ."downloadable" $PLUGIN`
   echo "DOWNLOADABLE=$DOWNLOADABLE"
   if [ $DOWNLOADABLE == "yes" ]
   then
        echo "[+] Copying Monitoring Plugin ${!PLUGIN_FILE} from git to Plugins contrib dir: ${MONITORING_PLUGINS_CONTRIB_DIR}"
        #wget $PLUGIN_SRC -O $PLUGIN_FILE -P $WORK_DIR
        cd $WORK_DIR
        wget $PLUGIN_SRC -O $PLUGIN_FILE
        echo "WORK_DIR/PLUGIN_FILE=${WORK_DIR}/${PLUGIN_FILE}"

        # Check if Plugin already exists. If yes: backup first
        if [ -f ${MONITORING_PLUGINS_CONTRIB_DIR}/${!PLUGIN_FILE} ]
        then
             #Verify if existing version is already up-to-date
             diff ${MONITORING_PLUGINS_CONTRIB_DIR}/${!PLUGIN_FILE} ${WORK_DIR}/${!PLUGIN_FILE} > /dev/null
             RES=$?
             if [ $RES -eq 0 ]
             then
                continue
             fi

             echo "[+] Creating Backup of ${!PLUGIN_FILE}"
             cp --force ${MONITORING_PLUGINS_CONTRIB_DIR}/${!PLUGIN_FILE} ${MONITORING_PLUGINS_CONTRIB_DIR}/${!PLUGIN_FILE}.${DATE}_bak
        fi
        #cp ${!PLUGIN_SRC} ${MONITORING_PLUGINS_CONTRIB_DIR}
        cp ${WORK_DIR}/${PLUGIN_FILE} ${MONITORING_PLUGINS_CONTRIB_DIR}
        echo "[i] Copied ${!PLUGIN_FILE}"
   else
        echo "[i] Plugin ${PLUGIN_FILE} not downloadable! Skipped!"
   fi
done


echo "[i] 099: Done."

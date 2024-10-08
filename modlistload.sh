#!/bin/bash

# File containing mod information
MOD_FILE="dayz/223350/modlist.html"
GENERIC_MODULE_FILE="GenericModule.kvp"
STEAMCMD_PLUGIN_FILE="steamcmdplugin.kvp"

# Remove old backup files if they exist
rm -f ${GENERIC_MODULE_FILE}.old
rm -f ${STEAMCMD_PLUGIN_FILE}.old

# Create backup copies of the original files
cp ${GENERIC_MODULE_FILE} ${GENERIC_MODULE_FILE}.old
cp ${STEAMCMD_PLUGIN_FILE} ${STEAMCMD_PLUGIN_FILE}.old

# Check if the modlist file exists and is valid
if [[ -f ${MOD_FILE} ]]; then
    # Parse mod IDs from the file, remove the '@' symbol
    allMods=$(grep 'id=' ${MOD_FILE} | cut -d'=' -f3 | cut -d'"' -f1 | xargs printf '%s;')
    mod_list_semicolons=$(echo $allMods | sed -e 's/;$//')  # Remove trailing semicolon
    mod_list_workshop=$(echo $allMods | sed -e 's/;/","/g' | sed -e 's/;$//')  # Format for steamcmdplugin

    # Replace the mod list in GenericModule.kvp
    sed -i -E '/App\.AppSettings=\{.*"mod":/s/("mod":"[^"]*")/"mod":"'"${mod_list_semicolons}"'"/' ${GENERIC_MODULE_FILE}

    # Replace the mod list in steamcmdplugin.kvp
    sed -i "s/\(SteamWorkshop.WorkshopItemIDs=\)\(\[.*\]\)/\1\[\"${mod_list_workshop}\"\]/" ${STEAMCMD_PLUGIN_FILE}

else
    echo "Modlist file (${MOD_FILE}) not found!"
fi

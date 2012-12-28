#!/bin/bash
function usage() {
	echo
	echo Usage: $0 [DIRECTORY]
	echo
	echo Example: $0 ~/files
	exit 1
}

if [ "$1" = "" ]; then
	echo
	echo "No argument specified."
	usage
else
	if [ ! -d "$1" ]; then
		echo
		echo "Directory doesn't exist."
		usage
	fi
	DIRECTORY=$1
	SAVEIFS=$IFS
	IFS=$(echo -en "\n\b")
	for FILE in `find $DIRECTORY -maxdepth 1 -type f -exec ls -1 {} \;`; do
		#don't move this script, if it is in the current directory
		if [ "$FILE" = "$0" ]; then 
			continue 
		fi
		FILEISODATE=`ls -l --full-time "$FILE" | cut -d" " -f 6`
		if [ ! -d "$DIRECTORY/$FILEISODATE" ]; then
			echo Making the \"$DIRECTORY/$FILEISODATE\" directory.
			echo
			mkdir "$DIRECTORY/$FILEISODATE"
		fi
		echo Moving "$FILE" to "$DIRECTORY/$FILEISODATE"...
		echo
		mv "$FILE" "$DIRECTORY/$FILEISODATE"
	done
fi

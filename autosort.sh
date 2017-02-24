#!/usr/bin/env bash

function usage() {
  printf '\n'
  printf 'Usage: %s [DIRECTORY]\n' "$0"
  printf '\n'
  printf 'Example: %s ~/files\n' "$0"

  exit 1
}

if [[ "$1" == '' ]]; then
  printf '\n'
  printf 'No argument specified.\n'

  usage
else
  if [[ ! -d "$1" ]]; then
    printf '\n'
    printf "Directory doesn't exist.\n"

    usage
  fi

  readonly DIRECTORY="$1"
  IFS=$(echo -en "\n\b")
  for FILE in $(find "$DIRECTORY" -maxdepth 1 -type f -exec ls -1 {} \;); do
    #don't move this script, if it is in the current directory
    if [[ "$FILE" = "$0" ]]; then
      continue;
    fi

    declare FILEISODATE
    FILEISODATE=$(ls -l --full-time "$FILE" | cut -d" " -f 6)

    if [ ! -d "$DIRECTORY/$FILEISODATE" ]; then
      printf 'Making the "%s/%s" directory.' "$DIRECTORY" "$FILEISODATE"
      printf '\n'

      mkdir "$DIRECTORY/$FILEISODATE"
    fi

    printf 'Moving "%s" to "%s/%s"...' "$FILE" "$DIRECTORY" "$FILEISODATE"
    printf '\n'

    mv "$FILE" "$DIRECTORY/$FILEISODATE"
  done
fi

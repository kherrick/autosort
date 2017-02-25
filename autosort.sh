#!/usr/bin/env bash

function usage() {
  printf '\nUsage: %s [DIRECTORY]\n' "$0"
  printf '\nExample: %s ~/files\n' "$0"

  exit 1
}

function isGnuStatAvailable()
{
  if [[ $(printf '%s' "$(stat --format "%Y" . > /dev/null 2>&1; echo $?)") -eq 0 ]]; then
    printf 'true'
  else
    printf 'false'
  fi
}

function isGnuDateAvailable()
{
  if [[ $(printf '%s' "$(date -d @0000000000 > /dev/null 2>&1; echo $?)") -eq 0 ]]; then
    printf 'true'
  else
    printf 'false'
  fi
}

if [[ "$1" == '' ]]; then
  printf '\nNo argument specified.\n'

  usage
else
  if [[ ! -d "$1" ]]; then
    printf "\nDirectory doesn't exist.\n"

    usage
  fi

  readonly DIRECTORY="$1"

  for FILE in "$DIRECTORY"/*; do
    #don't move this script, if it is in the current directory
    if [[ "$FILE" = "$0" ]]; then
      continue;
    fi

    declare file_timestamp
    declare file_iso_8601_date_string

    #determine stat support
    if [[ $(isGnuStatAvailable) == 'true' ]]; then
      file_timestamp=$(stat --format "%Y" "$FILE")
    else
      file_timestamp=$(stat -f "%m" "$FILE")
    fi

    #determine date support
    if [[ $(isGnuDateAvailable) == 'true' ]]; then
      file_iso_8601_date_string=$(date -d "@$file_timestamp" +'%Y-%m-%d')
    else
      file_iso_8601_date_string=$(date -r "$file_timestamp" +'%Y-%m-%d')
    fi

    if [ ! -d "$DIRECTORY/$file_iso_8601_date_string" ]; then
      printf 'Making the "%s/%s" directory.\n' "$DIRECTORY" "$file_iso_8601_date_string"

      mkdir "$DIRECTORY/$file_iso_8601_date_string"
    fi

    printf 'Moving "%s" to "%s/%s"...\n' "$FILE" "$DIRECTORY" "$file_iso_8601_date_string"

    mv "$FILE" "$DIRECTORY/$file_iso_8601_date_string"
  done
fi

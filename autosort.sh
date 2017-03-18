#!/usr/bin/env bash

function usage()
{
  printf '\n'
  printf 'Usage: %s [DIRECTORY]\n' "$0"
  printf '\n'
  printf 'Example: %s ~/files\n' "$0"
  printf '\n'

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

readonly DIRECTORY="$1"

if [[ "$DIRECTORY" == '' ]]; then
  printf '\n'
  printf 'No argument specified.\n'

  usage
fi

if [[ ! -d "$DIRECTORY" ]]; then
  printf '\n'
  printf "Directory doesn't exist.\n"

  usage
fi

for FILE in "$DIRECTORY"/*; do
  # there are no files to process
  if [[ "$FILE" == "$DIRECTORY/*" ]]; then
    continue;
  fi

  # don't move this script, if it is in the current directory
  if [[ "$FILE" == "$0" ]]; then
    continue;
  fi

  declare file_timestamp
  declare file_iso_8601_date_string

  # determine stat support
  if [[ $(isGnuStatAvailable) == 'true' ]]; then
    file_timestamp=$(stat --format "%Y" "$FILE")
  else
    file_timestamp=$(stat -f "%m" "$FILE")
  fi

  # determine date support
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

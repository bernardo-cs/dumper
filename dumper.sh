#!/bin/bash

DOT_VERSION=".dump_version"
DOWNLOAD_LOCATION="/path/to/dump"
APP_NAME="heroku_app_name"

if [ ! -z $1 ] 
then 
  # get dump version if passed as first argument
  DUMP_VERSION=$1
  echo "$DUMP_VERSION" > "$DOT_VERSION"
else
  if [ -f "$DOT_VERSION" ]
  then
    # if dotfile exists, read version to download from there
    DUMP_VERSION=$(head -n 1 $DOT_VERSION)

    echo "===================================="
    echo "Resuming dump download:" $DUMP_VERSION
    echo "===================================="
  else
    # fetch latest dump version from heroku and store it on the dot_file
    DUMP_VERSION=`heroku pg:backups --app $APP_NAME | grep Completed | grep -Eo '^[^ ]+' | head -1`
    echo "$DUMP_VERSION" > "$DOT_VERSION"

    echo "===================================="
    echo "Getting dump version:" $DUMP_VERSION
    echo "===================================="
  fi
fi

# Trap Ctrl c
function trap_ctrlc ()
{
  echo "Ctrl-C caught...performing clean up"
  exit 2
}

trap "trap_ctrlc" 2

function get_new_url {
  DOWNLOAD_URL=`heroku pg:backups public-url $DUMP_VERSION --app $APP_NAME`
  echo "Dump public url: " $DOWNLOAD_URL
}

function download {
  get_new_url
  aria2c -c -x 10 -s 10 --summary-interval 0 -o $DUMP_VERSION -d $DOWNLOAD_LOCATION $DOWNLOAD_URL
}

function cleanup {
  # remove dot file on success
  rm $DOT_VERSION 2> /dev/null  
}

download
until [ $? -eq 0 ]
do
  download
done

cleanup

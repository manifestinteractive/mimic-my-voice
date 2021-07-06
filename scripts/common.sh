#!/bin/bash
#
# description: Common Scripts used in Bash Files
#
# author: Peter Schmalfeldt <me@peterschmalfeldt.com>

# Get Directory Info
CWD=$(dirname $(dirname "$0"))
ENV="$CWD/.env"
STUDIO="$CWD/mimic-recording-studio"
TTS="$CWD/TTS"
AUDIO_FILES="$STUDIO/backend/audio_files/default_user"

# Repo URLs
REPO_STUDIO='https://github.com/manifestinteractive/mimic-recording-studio.git'
REPO_TTS='https://github.com/manifestinteractive/TTS.git'

function make_header(){
  TEXT=$( echo $1 | tr '\n' ' ')
  echo -e "\n\033[48;5;22m  $TEXT  \033[0m\n"
}

function error(){
  TEXT=$( echo $1 | tr '\n' ' ')
  echo -e "\033[38;5;196m✖\033[0m $TEXT"
}

function notice(){
  TEXT=$( echo $1 | tr '\n' ' ')
  echo -e "\033[38;5;220m→\033[0m $TEXT"
}

function output(){
  TEXT=$( echo $1 | tr '\n' ' ')
  echo -e "› $TEXT"
}

function success(){
  TEXT=$( echo $1 | tr '\n' ' ')
  echo -e "\n\033[38;5;86;1m✔\033[0m $TEXT\n"
}

# Check if we have a custom config file
function mimic_has_config(){
  if [ -f $ENV ]; then
    true
    return
  fi

  false
}

# Load config into the environment
function load_config(){
  # Import Environmental Settings
  if [ -f $ENV ]; then
    export $(cat $ENV | sed 's/#.*//g' | xargs)
  else
    error "Missing $ENV File"
    notice "Try Running: mimic config"
    exit
  fi
}

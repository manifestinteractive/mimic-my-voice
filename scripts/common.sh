#!/bin/bash
#
# description: Common Scripts used in Bash Files
#
# author: Peter Schmalfeldt <me@peterschmalfeldt.com>

# Get Directory Info
CWD=$(dirname $(dirname "$0"))
ENV="$CWD/.env"
MRS="$CWD/mimic-recording-studio"
TTS="$CWD/TTS"
AUDIO_FILES="$MRS/backend/audio_files/$MRS_USERNAME"

# Repo URLs
REPO_MRS='https://github.com/manifestinteractive/mimic-recording-studio.git'
REPO_TTS='https://github.com/manifestinteractive/TTS.git'

# Docker Info
DOCKER=""
DOCKER_INSTALLED=false
DOCKER_NVIDIA_INSTALLED=false
DOCKER_RUNNING=false
DOCKER_NVIDIA_RUNNING=false
NVIDIA_SMI_INSTALLED=false

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

function check_docker(){
  DOCKER_INSTALLED=$(type docker > /dev/null 2>&1 && echo 'true' || echo 'false')
  DOCKER_NVIDIA_INSTALLED=$(type nvidia-docker > /dev/null 2>&1 && echo 'true' || echo 'false')
  DOCKER_RUNNING=$(docker info > /dev/null 2>&1 && echo 'true' || echo 'false')
  DOCKER_NVIDIA_RUNNING=$(nvidia-docker info > /dev/null 2>&1 && echo 'true' || echo 'false')
  NVIDIA_SMI_INSTALLED=$(type nvidia-smi > /dev/null 2>&1 && echo 'true' || echo 'false')

  # Check if we have either supported versions of docker installed
  if [[ $DOCKER_INSTALLED == 'false' && $DOCKER_NVIDIA_INSTALLED == 'false' ]]; then
    error 'Docker is Not Installed'

    # Check if user has suppoerted NVIDIA Drivers installed
    if [ $NVIDIA_SMI_INSTALLED == 'true' ]; then
      notice 'Need to Install Docker? Looks like you have an NVIDIA GPU【ツ】'
      output 'Install Docker NVIDIA: https://github.com/NVIDIA/nvidia-docker\n'
    else
      notice 'Need to Install Docker? https://www.docker.com/products/docker-desktop\n'
    fi

    exit
  fi

  # Set which docker to use
  if [ $DOCKER_INSTALLED == 'true' ]; then
    DOCKER=$(which docker)
  elif [ $DOCKER_NVIDIA_INSTALLED == 'true' ]; then
    DOCKER=$(which nvidia-docker)
  fi

  # Check if we have docker installed, but it's not running
  if [[ $DOCKER_INSTALLED == 'true' && $DOCKER_RUNNING == 'false' ]]; then
    error 'Docker does not seem to be running.'
    notice 'Start Docker and rerun: mimic train\n'
    exit
  fi

  # Check if we have NVIDIA Docker installed, but it's not running
  if [[ $DOCKER_NVIDIA_INSTALLED == 'true' && $DOCKER_NVIDIA_RUNNING == 'false' ]]; then
    error 'NVIDIA Docker does not seem to be running.'
    notice 'Start NVIDIA Docker and rerun: mimic train\n'
    exit
  fi
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

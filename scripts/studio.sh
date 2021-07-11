#!/bin/bash
#
# description: Mimic Recording Studio
#
# author: Peter Schmalfeldt <me@peterschmalfeldt.com>

# Load Common Functions
. "$(dirname "$0")/common.sh"

# Run Docker Instance
function start_docker(){
  # Copy .env
  cp $ENV $MRS/.env
  cp $ENV $MRS/frontend/.env
  cp $ENV $MRS/backend/.env

  # Track Number of Recordings
  TOTAL_FILES=0

  # Get Total Recordings
  if [ -d $AUDIO_FILES ]; then
    while read -rd ''; do ((TOTAL_FILES++)); done < <(find $AUDIO_FILES -name "*.wav" -print0)
  fi

  cd $MRS

  # Check if docker is running
  if ! docker info > /dev/null 2>&1; then
    echo
    error 'Docker does not seem to be running, run it first and retry'
    notice 'Need to Install Docker? https://www.docker.com/products/docker-desktop'
    echo
    exit
  fi

  echo
  output 'Starting Mimic Recording Studio Docker Container'
  echo

  # Check if we are doing a clean docker install
  if [[ "$(docker images -q mimic-recording-studio_frontend 2> /dev/null)" == "" ]]; then
    # Open Docker Container in Browser
    echo
    output 'Opening Browser'
    notice 'Browser will reload after Dockers First Build Completes ( this will take a while )'

    # If we already have recordings, then let's take the user to the record page
    if (( $TOTAL_FILES == 0 )); then
      open http://localhost:$MRS_PORT_FRONTEND
    else
      open http://localhost:$MRS_PORT_FRONTEND/record
    fi

    make_header 'Creating Docker Build'
    notice 'We only need to create this once'
    echo

    # This is the First Build, which takes a long time, so let's show the output for this one
    docker compose up

    # If we got here in this script, the user terminated the docker CLI
    success 'Mimic Recording Studio Docker Container Stopped'
    exit
  else
    # Launch Docker in a Detached State and do not recreate it if it's already been built
    docker compose up --no-recreate --detach

    echo
    success 'Mimic Recording Studio Docker Container Started'

    # Wait a little bit for Docker Container to finish initializing
    sleep 30

    # Open Docker Container in Browser
    output 'Opening Browser'
    notice 'Browser will reload after Docker Build Completes'

    # If we already have recordings, then let's take the user to the record page
    if (( $TOTAL_FILES == 0 )); then
      open http://localhost:$MRS_PORT_FRONTEND
    else
      open http://localhost:$MRS_PORT_FRONTEND/record
    fi

    make_header 'MIMIC RECORDING MRS STARTED'
    exit
  fi
}

# Start Script for Linux
function studio_linux(){
  notice 'Linux Support Coming Soon'
  exit
}

# Start Script for MacOS
function studio_macos(){
  # Import Environmental Settings
  load_config

  make_header 'Mimic My Voice - MacOS'

  output 'Starting Mimic Recording Studio'
  if [ -d $MRS ]; then
    # Start Docker Containers for MRS
    start_docker
  else
    error 'Missing Mimic Recording Studio - Run: mimin setup'
  fi

  exit
}

# Start Script for Windows
function studio_windows(){
  notice 'Windows Support Coming Soon'
  exit
}

# Check which OS we are using
case "$(uname -s)" in
  Linux*)
    studio_linux
  ;;
  Darwin*)
    studio_macos
  ;;
  MINGW*)
    studio_windows
  ;;
  *)
    error 'Unsupported Operating System'
  ;;
esac

#!/bin/bash
#
# description: Mimic Recording Studio
#
# author: Peter Schmalfeldt <me@peterschmalfeldt.com>

__make_header(){
  TEXT=$( echo $1 | tr '\n' ' ')
  echo -e "\n\033[48;5;22m  $TEXT  \033[0m\n"
}

__error(){
  TEXT=$( echo $1 | tr '\n' ' ')
  echo -e "\033[38;5;196m✖\033[0m $TEXT"
}

__notice(){
  TEXT=$( echo $1 | tr '\n' ' ')
  echo -e "\033[38;5;220m→\033[0m $TEXT"
}

__output(){
  TEXT=$( echo $1 | tr '\n' ' ')
  echo -e "› $TEXT"
}

__success(){
  TEXT=$( echo $1 | tr '\n' ' ')
  echo -e "\033[38;5;86;1m✔\033[0m $TEXT\n"
}

# Start Script for Linux
__studio_linux(){
  __notice 'Linux Support Coming Soon'
  exit
}

# Start Script for MacOS
__studio_macos(){
  # Get Directory Info
  CWD=$(dirname $(dirname "$0"))
  ENV="$CWD/.env"
  STUDIO="$CWD/mimic-recording-studio"
  AUDIO_FILES="$STUDIO/backend/audio_files"

  # Import Environmental Settings
  if [ -f $ENV ]; then
    export $(cat $ENV | sed 's/#.*//g' | xargs)
  else
    __error "Missing $ENV File ( Copy $CWD/.env.example to $CWD/.env & Update )"
    exit
  fi

  __make_header 'Mimic My Voice - MacOS'

  __output 'Starting Mimic Recording Studio'
  if [ -d $STUDIO ]; then
    # Track Number of Recordings
    TOTAL_FILES=0

    # Get Total Recordings
    if [ -d $AUDIO_FILES ]; then
      while read -rd ''; do ((TOTAL_FILES++)); done < <(find $AUDIO_FILES/*/ -name "*.wav" -print0)
    fi

    cd $STUDIO

    # Check if docker is running
    if ! docker info > /dev/null 2>&1; then
      echo
      __error 'Docker does not seem to be running, run it first and retry'
      __notice 'Need to Install Docker? https://www.docker.com/products/docker-desktop'
      echo
      exit
    fi

    echo
    __output 'Starting Mimic Recording Studio Docker Container'
    echo

    # Check if we are doing a clean docker install
    if [[ "$(docker images -q mimic-recording-studio_frontend 2> /dev/null)" == "" ]]; then
      __make_header 'Creating Docker Build'
      __notice 'We only need to create this once'
      echo
    fi

    # Launch Docker in a Detached State and do not recreate it if it's already been built
    docker compose up --no-recreate --detach

    echo
    __success 'Mimic Recording Studio Docker Container Started'

    # Wait a little bit for Docker Container to finish initializing
    sleep 30

    # Open Docker Container in Browser
    echo
    __output 'Opening Browser'
    __notice 'Browser will reload after Docker Build Completes'

    # If we already have recordings, then let's take the user to the record page
    if (( $TOTAL_FILES == 0 )); then
      open http://localhost:$PORT_STUDIO_FRONTEND
    else
      open http://localhost:$PORT_STUDIO_FRONTEND/record
    fi

    __make_header 'MIMIC RECORDING STUDIO STARTED'
    exit
  else
    __error 'Missing Mimic Recording Studio - Run: mimin setup'
    exit
  fi
}

# Start Script for Windows
__studio_windows(){
  __notice 'Windows Support Coming Soon'
  exit
}

# Check which OS we are using
case "$(uname -s)" in
  Linux*)
    __studio_linux
  ;;
  Darwin*)
    __studio_macos
  ;;
  MINGW*)
    __studio_windows
  ;;
  *)
    __error 'Unsupported Operating System'
  ;;
esac

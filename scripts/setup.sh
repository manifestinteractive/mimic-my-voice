#!/bin/bash
#
# description: Initial Setup for Mimic Trainer & Mimic Recording Studio
#
# author: Peter Schmalfeldt <me@peterschmalfeldt.com>

# Load Common Functions
. "$(dirname "$0")/common.sh"

# Clone Git Repos
function clone_repos(){
  output 'Downloading Mimic Recording Studio'
  echo

  cd $CWD

  # Check if Repo Already Cloned
  if [ -d $STUDIO ]; then
    # Confirm Delete of Old Repo
    read -p "Mimic Recording Studio Already Downloaded. Delete Existing Install (y/n)? " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo
      rm -fr $STUDIO
      git clone $REPO_STUDIO
    fi
  else
    git clone $REPO_STUDIO
  fi

  success 'Download Complete'

  output 'Downloading Coqui TTS'
  echo

  # Check if Repo Already Cloned
  if [ -d $TTS ]; then
    # Confirm Delete of Old Repo
    read -p "Coqui TTS Already Downloaded. Delete Existing Install (y/n)? " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo
      rm -fr $TTS
      git clone $REPO_TTS
    fi
  else
    git clone $REPO_TTS
  fi

  success 'Download Complete'
}

# Setup Script for Linux
function setup_linux(){
  load_config

  make_header 'Mimic My Voice - Linux Setup'

  ##################################################
  # Python Setup
  ##################################################

  output 'Checking if Python is Installed'
  if [[ $(command -v python3) == "" ]]; then
    # Confirm Install of Python
    echo
    read -p "Would you like to Install Python (y/n)? " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
      output 'Installing Python'

      echo
      notice 'We Need to install system packages that will request your password'
      echo

      sudo apt-get install python3 python3-pip python3-setuptools python3-gi python3-xlib python3-dbus gir1.2-glib-2.0 gir1.2-gtk-3.0 gir1.2-wnck-3.0
    else
      error 'Exiting Setup'
      notice 'Python is Required for Linux Installation'
      exit
    fi
  fi

  success 'Python Setup Complete'

  # Clone Git Repos
  clone_repos

  # Install MRS Dependencies
  output 'Installing Mimic Recording Studio Back-end Dependencies'
  echo

  cd $STUDIO/backend
  pip install -r requirements.txt

  output 'Installing Mimic Recording Studio Front-end Dependencies'
  echo

  cd $STUDIO/frontend
  npm install

  # Install Coqui TTS Dependencies
  output 'Installing Coqui TTS Dependencies'
  echo

  cd $TTS
  pip install -r requirements.txt
  pip install -r requirements.tf.txt
  pip install ffmpeg-python

  # Do a quick update for Python
  pip3 install pip setuptools wheel --upgrade

  # Run Setup on TTS
  python3 ./setup.py install --user

  echo
  notice 'We Need to install a system package "espeak-ng" that will request your password'
  echo

  sudo apt install espeak-ng -y
  sudo apt install ffmpeg -y

  # Update Cloned Repos
  output 'Updating Port Configs'

  # TODO: Update these files to use environmental variables
  sed -i "s/localhost:5000/localhost:$PORT_STUDIO_BACKEND/g" $STUDIO/frontend/src/App/api/index.js
  sed -i "s/5000/$PORT_STUDIO_BACKEND/g" $STUDIO/docker-compose.yml
  sed -i "s/3000/$PORT_STUDIO_FRONTEND/g" $STUDIO/docker-compose.yml
  sed -i "s/english_corpus.csv/$CORPUS/g" $STUDIO/docker-compose.yml

  make_header 'SETUP COMPLETE'

  exit
}

# Setup Script for MacOS
function setup_macos(){
  # Import Environmental Settings
  load_config

  make_header 'Mimic My Voice - MacOS Setup'

  # Clone Git Repos
  clone_repos

  # Update Cloned Repos
  output 'Updating Port Configs'

  # TODO: Update these files to use environmental variables
  sed -i '' "s/localhost:5000/localhost:$PORT_STUDIO_BACKEND/g" $STUDIO/frontend/src/App/api/index.js
  sed -i '' "s/5000/$PORT_STUDIO_BACKEND/g" $STUDIO/docker-compose.yml
  sed -i '' "s/3000/$PORT_STUDIO_FRONTEND/g" $STUDIO/docker-compose.yml
  sed -i '' "s/english_corpus.csv/$CORPUS/g" $STUDIO/docker-compose.yml

  # All Done
  make_header 'SETUP COMPLETE'

  exit
}

# Setup Script for Windows
function setup_windows(){
  notice 'Windows Support Coming Soon'
  exit
}

# Check which OS we are using
case "$(uname -s)" in
  Linux*)
    setup_linux
  ;;
  Darwin*)
    setup_macos
  ;;
  MINGW*)
    setup_windows
  ;;
  *)
    error 'Unsupported Operating System'
  ;;
esac

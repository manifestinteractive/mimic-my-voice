#!/bin/bash
#
# description: Initial Setup for Mimic Trainer & Mimic Recording Studio
#
# author: Peter Schmalfeldt <me@peterschmalfeldt.com>

REPO_STUDIO='https://github.com/manifestinteractive/mimic-recording-studio.git'
REPO_TRAINER='https://github.com/manifestinteractive/mimic2.git'

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
  echo -e "\n\033[38;5;86;1m✔\033[0m $TEXT\n"
}

# Setup Script for Linux
__setup_linux(){
  __notice 'Linux Support Coming Soon'
  exit
}

# Setup Script for MacOS
__setup_macos(){
    # Get Directory Info
  CWD=$(dirname $(dirname "$0"))
  ENV="$CWD/.env"
  STUDIO="$CWD/mimic-recording-studio"
  TACOTRON="$CWD/tacotron"
  TRAINER="$CWD/mimic2"

  __make_header 'Mimic My Voice - MacOS Setup'

  ##################################################
  # Homebrew Setup
  ##################################################

  __output 'Checking if Homebrew is Installed'
  if [[ $(command -v brew) == "" ]]; then
    # Confirm Install of Homebrew
    echo
    read -p "Would you like to Install Homebrew (y/n)? " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
      __output 'Installing Homebrew'
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
      __error 'Exiting Setup'
      __notice 'Homebrew is Required for MacOS Installation'
      exit
    fi
  else
    # Confirm Update of Homebrew
    echo
    read -p "Homebrew Detected. Would you like to Update Homebrew before Continuing (y/n)? " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo
      __output 'Updating Homebrew'
      echo
      brew update
    fi
  fi

  echo
  __output 'Installing Homebrew Dependencies'

  brew install pkg-config automake libtool portaudio icu4c 2>/dev/null && true

  __success 'Brew Setup Complete'

  ##################################################
  # Clone Git Repos
  ##################################################

  __output 'Downloading Mimic Recording Studio'
  echo

  # Check if Repo Already Cloned
  if [ -d $STUDIO ]; then
    # Confirm Delete of Old Repo
    read -p "Mimic Recording Studio Already Downloaded. Delete Existing Install (y/n)? " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo
      rm -fr $STUDIO
      git clone $REPO_STUDIO $STUDIO
    fi
  else
    git clone $REPO_STUDIO $STUDIO
  fi

  __success 'Download Complete'

  __output 'Downloading Mimic Trainer'
  echo

  # Check if Repo Already Cloned
  if [ -d $TRAINER ]; then
    # Confirm Delete of Old Repo
    read -p "Mimic Trainer Already Downloaded. Delete Existing Install (y/n)? " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo
      rm -fr $TRAINER
      git clone $REPO_TRAINER $TRAINER
    fi
  else
    git clone $REPO_TRAINER $TRAINER
  fi

  __success 'Download Complete'

  ##################################################
  # Update Cloned Repos
  ##################################################

  __output 'Updating Port Configs'

  sed -i '' "s/localhost:5000/localhost:$PORT_STUDIO_BACKEND/g" $STUDIO/frontend/src/App/api/index.js
  sed -i '' "s/5000/$PORT_STUDIO_BACKEND/g" $STUDIO/docker-compose.yml
  sed -i '' "s/3000/$PORT_STUDIO_FRONTEND/g" $STUDIO/docker-compose.yml
  sed -i '' "s/default=3002/default=$PORT_DEMO/g" $TRAINER/demo_server.py

  ##################################################
  # Create Required Directories
  ##################################################

  __output 'Creating Mimic Training Folder'
  mkdir -p $TACOTRON/training

  ##################################################
  # Python Setup
  ##################################################

  __output 'Checking of Python is Installed'
  which -s pip3
  if [[ $? != 0 ]]; then
    # Confirm Install of Python
    echo
    read -p "Would you like to Install Python (y/n)? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      __output 'Installing Python'
      brew install python
    else
      __error 'Exiting Setup'
      __notice 'Python is Required for MacOS Installation'
      exit
    fi
  fi

  # Install Python 3 Requirements
  __output 'Installing Mimic Python Dependencies'
  echo

  pip3 install -r $TRAINER/requirements.txt 2>/dev/null && true
  pip3 install tensorflow 2>/dev/null && true
  pip3 install matplotlib 2>/dev/null && true
  pip3 install seaborn 2>/dev/null && true

  __success 'Python Setup Complete'

  ##################################################
  # Download Phoneme Dictionary
  ##################################################

  __output 'Downloading Phoneme Dictionary'
  curl -o $TACOTRON/training/cmudict-0.7b https://raw.githubusercontent.com/Alexir/CMUdict/master/cmudict-0.7b
  __success 'Download Complete'

  ##################################################
  # All Done
  ##################################################

  __make_header 'SETUP COMPLETE'

  exit
}

# Setup Script for Windows
__setup_windows(){
  __notice 'Windows Support Coming Soon'
  exit
}

# Check which OS we are using
case "$(uname -s)" in
  Linux*)
    __setup_linux
  ;;
  Darwin*)
    __setup_macos
  ;;
  MINGW*)
    __setup_windows
  ;;
  *)
    __error 'Unsupported Operating System'
  ;;
esac

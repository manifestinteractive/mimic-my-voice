#!/bin/bash
#
# description: Mimic Training
#
# author: Peter Schmalfeldt <me@peterschmalfeldt.com>

# Load Common Functions
. "$(dirname "$0")/common.sh"

# Run Docker Instance
function start_docker(){
  check_docker

  # "${DOCKER}" run
}

# Train Script for Linux
function train_linux(){
  notice 'Linux Support Coming Soon'
  exit
}

# Train Script for MacOS
function train_macos(){
  echo
  error 'Coqui TTS - Training Not Supported on macOS \n'

  notice 'Training requires a computer with a supported NVIDIA GPU.'
  notice 'GPU processing is currently not supported by Apple, not even via Docker.'
  notice 'LINK: https://github.com/NVIDIA/nvidia-docker/wiki#is-macos-supported \n'

  output 'Consider running Coqui TTS Training on Windows or a Lunux Distro with Supported GPU.'
  output 'LINK: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#platform-requirements \n'

  exit
}

# Train Script for Windows
function train_windows(){
  notice 'Windows Support Coming Soon'
  exit

  # Import Environmental Settings
  load_config

  make_header 'Mimic My Voice - Train Windows'

  output 'Starting Coqui TTS Trainer\n'

  if [ -d $TTS ]; then
    # Start Docker Containers for MRS
    start_docker
  else
    error 'Missing Coqui TTS - Run: mimin setup'
    exit
  fi
}

# Check which OS we are using
case "$(uname -s)" in
  Linux*)
    train_linux
  ;;
  Darwin*)
    train_macos
  ;;
  MINGW*)
    train_windows
  ;;
  *)
    error 'Unsupported Operating System'
  ;;
esac

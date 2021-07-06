#!/bin/bash
#
# description: Mimic Training
#
# author: Peter Schmalfeldt <me@peterschmalfeldt.com>

# Load Common Functions
. "$(dirname "$0")/common.sh"

# Train Script for Linux
function train_linux(){
  notice 'Linux Support Coming Soon'
  exit
}

# Train Script for MacOS
function train_macos(){
  notice 'MacOS Support Coming Soon'
  exit
}

# Train Script for Windows
function train_windows(){
  notice 'Windows Support Coming Soon'
  exit
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

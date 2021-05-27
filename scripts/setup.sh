#!/bin/bash
#
# description: Initial Setup for Mimic Trainer & Mimic Recording Studio
#
# author: Peter Schmalfeldt <me@peterschmalfeldt.com>

MIMIC='https://github.com/MycroftAI/mimic2.git'
STUDIO='https://github.com/MycroftAI/mimic-recording-studio.git'

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

# Setup Script for Linux
__setup_linux(){
    __notice 'Linux Support Coming Soon'
}

# Setup Script for MacOS
__setup_macos(){
    __make_header 'Mimic Recording Studio - MacOS Setup'

    __output 'Checking of Homebrew is Installed'
    which -s brew
    if [[ $? != 0 ]]; then
        # Confirm Install of Homebrew
        read -p "Would you like to Install Homebrew? " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          __output 'Installing Homebrew'
          ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        else
          __error 'Exiting Setup'
          __notice 'Homebrew is Required for MacOS Installation'
          exit 1
        fi
    else
        # Confirm Update of Homebrew
        read -p "Would you like to Update Homebrew before Installing? " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          __output 'Updating Homebrew'
          brew update
        fi
    fi

    __output 'Installing Homebrew Dependencies'
    brew install pkg-config automake libtool portaudio icu4c

    __output 'Downloading Mimic Recording Studio'
    # Check if Repo Already Cloned
    if [ -d mimic-recording-studio ]; then
      # Confirm Delete of Old Repo
      read -p "Mimic Recording Studio Already Downloaded. Delete Existing Install? " -n 1 -r
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -fr mimic-recording-studio
        git clone $STUDIO
      fi
    else
      git clone $STUDIO
    fi

    __output 'Downloading Mimic Trainer'
    # Check if Repo Already Cloned
    if [ -d mimic2 ]; then
      # Confirm Delete of Old Repo
      read -p "Mimic Trainer Already Downloaded. Delete Existing Install? " -n 1 -r
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -fr mimic2
        git clone $MIMIC
      fi
    else
      git clone $MIMIC
    fi

    ##################################################
    # Mimic Trainer
    ##################################################

    __make_header 'Mimic Trainer - MacOS Setup'

    __output 'Fixing Docker Config in Mimic for MacOS'
    sed -i '' 's/"\/bin\/bash"/"\/bin\/bash", "-c"/g' mimic2/cpu.Dockerfile
    sed -i '' 's/COPY \. \/root\/mimic2/COPY mimic2 \/root\/mimic2/g' mimic2/cpu.Dockerfile
    sed -i '' 's/apt-get install -y llvm-8/apt-get install -y llvm-8 python3-tk/g' mimic2/cpu.Dockerfile

    __output 'Fixing Analyzer'
    sed -i '' 's/plt.show/# plt.show/g' mimic2/analyze.py

    __output 'Creating Mimic Training Folder'
    mkdir -p tacotron/training

    __output 'Checking of Python is Installed'
    which -s pip3
    if [[ $? != 0 ]]; then
        # Confirm Install of Python
        read -p "Would you like to Install Python? " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          __output 'Installing Python'
          brew install python
        else
          __error 'Exiting Setup'
          __notice 'Python is Required for MacOS Installation'
          exit 1
        fi
    fi

    # Install Python 3 Requirements
    __output 'Installing Mimic Python Dependencies'
    pip3 install -r mimic2/requirements.txt
    pip3 install tensorflow
    pip3 install matplotlib
    pip3 install seaborn

    __output 'Downloading Phoneme Dictionary'
    curl -o tacotron/training/cmudict-0.7b https://raw.githubusercontent.com/Alexir/CMUdict/master/cmudict-0.7b
}

# Setup Script for Windows
__setup_windows(){
    __notice 'Windows Support Coming Soon'
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

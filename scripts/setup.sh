#!/bin/bash
#
# description: Initial Setup for Mimic Trainer & Mimic Recording Studio
#
# author: Peter Schmalfeldt <me@peterschmalfeldt.com>

MIMIC='https://github.com/manifestinteractive/mimic2.git'
STUDIO='https://github.com/manifestinteractive/mimic-recording-studio.git'

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

# Import Environmental Settings
if [ -f .env ]; then
  export $(cat .env | sed 's/#.*//g' | xargs)
else
  __error "Missing .env File in Root ( Copy .env.example to .env & Update )"
  exit
fi

# Setup Script for Linux
__setup_linux(){
    __notice 'Linux Support Coming Soon'

    exit
}

# Setup Script for MacOS
__setup_macos(){
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
    if [ -d mimic-recording-studio ]; then
      # Confirm Delete of Old Repo
      read -p "Mimic Recording Studio Already Downloaded. Delete Existing Install (y/n)? " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo
        rm -fr mimic-recording-studio
        git clone $STUDIO
      fi
    else
      git clone $STUDIO
    fi

    __success 'Download Complete'

    __output 'Downloading Mimic Trainer'
    echo

    # Check if Repo Already Cloned
    if [ -d mimic2 ]; then
      # Confirm Delete of Old Repo
      read -p "Mimic Trainer Already Downloaded. Delete Existing Install (y/n)? " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo
        rm -fr mimic2
        git clone $MIMIC
      fi
    else
      git clone $MIMIC
    fi

    __success 'Download Complete'

    ##################################################
    # Update Cloned Repos
    ##################################################

    __output 'Updating Docker Configs'
    sed -i '' 's/"\/bin\/bash"/"\/bin\/bash", "-c"/g' mimic2/cpu.Dockerfile
    sed -i '' 's/COPY \. \/root\/mimic2/COPY mimic2 \/root\/mimic2/g' mimic2/cpu.Dockerfile
    sed -i '' 's/apt-get install -y llvm-8/apt-get install -y llvm-8 python3-tk/g' mimic2/cpu.Dockerfile

    __output 'Updating Port Configs'
    sed -i '' "s/localhost:5000/localhost:$PORT_STUDIO_BACKEND/g" mimic-recording-studio/frontend/src/App/api/index.js
    sed -i '' "s/\*\*5000\*\*/\*\*$PORT_STUDIO_BACKEND\*\*/g" mimic-recording-studio/frontend/CRA.md
    sed -i '' "s/\`5000\`/\`$PORT_STUDIO_BACKEND\`/g" mimic-recording-studio/README.md
    sed -i '' "s/5000/$PORT_STUDIO_BACKEND/g" mimic-recording-studio/docker-compose.yml

    sed -i '' "s/3000/$PORT_STUDIO_FRONTEND/g" mimic-recording-studio/docker-compose.yml
    sed -i '' "s/localhost:3000/localhost:$PORT_STUDIO_FRONTEND/g" mimic-recording-studio/README.md
    sed -i '' "s/localhost:3000/localhost:$PORT_STUDIO_FRONTEND/g" mimic-recording-studio/frontend/CRA.md
    sed -i '' "s/port 3000/port $PORT_STUDIO_FRONTEND/g" mimic-recording-studio/frontend/CRA.md

    sed -i '' "s/3000/$PORT_STUDIO_FRONTEND/g" mimic2/README.md

    sed -i '' "s/default=3000/default=$PORT_DEMO/g" mimic2/demo_server.py

    __output 'Updating Analyzer'
    sed -i '' 's/plt.show/# plt.show/g' mimic2/analyze.py
    sed -i '' 's/plt.xlabel("character lengths", fontsize=30)/plt.subplots_adjust(bottom=0.22)\n    plt.xlabel("character lengths", fontsize=30)/g' mimic2/analyze.py

    __output 'Updating Trainer'
    sed -i '' 's/print(hparams_debug_string())/#print(hparams_debug_string())/g' mimic2/preprocess.py
    sed -i '' 's/log(hparams_debug_string())/#log(hparams_debug_string())/g' mimic2/train.py
    sed -i '' 's/None/mimic-my-voice/g' mimic2/train.py
    sed -i '' 's/ at commit//g' mimic2/train.py
    sed -i '' 's/print(msg)/print(msg, flush=True)/g' mimic2/util/infolog.py

    ##################################################
    # Create Required Directories
    ##################################################

    __output 'Creating Mimic Training Folder'
    mkdir -p tacotron/training

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

    pip3 install -r mimic2/requirements.txt 2>/dev/null && true
    pip3 install tensorflow 2>/dev/null && true
    pip3 install matplotlib 2>/dev/null && true
    pip3 install seaborn 2>/dev/null && true

    __success 'Python Setup Complete'

    ##################################################
    # Download Phoneme Dictionary
    ##################################################

    __output 'Downloading Phoneme Dictionary'
    curl -o tacotron/training/cmudict-0.7b https://raw.githubusercontent.com/Alexir/CMUdict/master/cmudict-0.7b
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

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

# Import Environmental Settings
if [ -f .env ]; then
  export $(cat .env | sed 's/#.*//g' | xargs)
else
  __error "Missing .env File in Root ( Copy .env.example to .env & Update )"

  exit
fi

# Start Script for Linux
__studio_linux(){
    __notice 'Linux Support Coming Soon'

    exit
}

# Start Script for MacOS
__studio_macos(){
    __make_header 'Mimic My Voice - MacOS'

    __output 'Starting Mimic Recording Studio'
    if [ -d mimic-recording-studio ]; then
        cd mimic-recording-studio

        # Check if docker is running
        if ! docker info > /dev/null 2>&1; then
            echo
            __error 'Docker does not seem to be running, run it first and retry'
            __notice 'Need to Install Docker? https://www.docker.com/products/docker-desktop'
            echo
            exit
        fi

        echo
        __output 'Opening Browser'
        __notice 'Browser will reload after Docker Build Completes'
        open http://localhost:$PORT_STUDIO_FRONTEND

        echo
        __output 'Starting Mimic Recording Studio [CTRL+C to Cancel]'

        # Check if we are doing a clean docker install
        if [[ "$(docker images -q mimic-recording-studio_frontend 2> /dev/null)" == "" ]]; then
          __make_header 'Creating Docker Build'
          __notice 'We only need to create this once'
        fi

        docker-compose up

        echo
        __success 'Mimic Recording Studio Terminated'
    else
        __error 'Missing Mimic Recording Studio - Run: mimin setup'
    fi

    exit
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

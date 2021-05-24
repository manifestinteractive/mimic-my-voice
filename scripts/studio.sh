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
}

# Start Script for MacOS
__studio_macos(){
    __make_header 'My Voice - MacOS'

    __output 'Starting Mimic Recording Studio'
    if [ -d mimic-recording-studio ]; then
        cd mimic-recording-studio

        # Check if docker is running
        if ! docker info > /dev/null 2>&1; then
            __error 'Docker does not seem to be running, run it first and retry'
            __notice 'Need to Install Docker? https://www.docker.com/products/docker-desktop'
            exit 1
        fi

        __output 'Opening Browser'
        __notice 'Browser will reload after Docker Compiles'
        open http://localhost:3000

        __success 'Starting Mimic Recording Studio [CTRL+C to Cancel]'
        docker-compose up

        __success 'Mimic Recording Studio Terminated'
    else
        __error 'Missing Mimic Recording Studio - Run ./scripts/start.sh'
    fi
}

# Start Script for Windows
__studio_windows(){
    __notice 'Windows Support Coming Soon'
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

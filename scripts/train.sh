#!/bin/bash
#
# description: Mimic Training
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

# Train Script for Linux
__train_linux(){
    __notice 'Linux Support Coming Soon'
}

# Train Script for MacOS
__train_macos(){
    __notice 'MacOS Support Coming Soon'
}

# Train Script for Windows
__train_windows(){
    __notice 'Windows Support Coming Soon'
}

# Check which OS we are using
case "$(uname -s)" in
    Linux*)
        __train_linux
    ;;
    Darwin*)
        __train_macos
    ;;
    MINGW*)
        __train_windows
    ;;
    *)
        __error 'Unsupported Operating System'
    ;;
esac

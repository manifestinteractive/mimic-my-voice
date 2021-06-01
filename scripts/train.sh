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
  echo -e "\n\033[38;5;86;1m✔\033[0m $TEXT\n"
}

# Train Script for Linux
__train_linux(){
  __notice 'Linux Support Coming Soon'
  exit
}

# Train Script for MacOS
__train_macos(){
  # Get Directory Info
  CWD=$(dirname $(dirname "$0"))
  ENV="$CWD/.env"
  STUDIO="$CWD/mimic-recording-studio"
  TACOTRON="$CWD/tacotron"
  TRAINER="$CWD/mimic2"
  AUDIO_FILES="$STUDIO/backend/audio_files"

  # Import Environmental Settings
  if [ -f $ENV ]; then
    export $(cat $ENV | sed 's/#.*//g' | xargs)
  else
    __error "Missing $ENV File ( Copy $CWD/.env.example to $CWD/.env & Update )"
    exit
  fi

  __make_header 'Mimic My Voice - MacOS'

  # Track Number of Recordings
  TOTAL_FILES=0

  # Get Total Recordings
  if [ -d $AUDIO_FILES ]; then
    while read -rd ''; do ((TOTAL_FILES++)); done < <(find $AUDIO_FILES/*/ -name "*.wav" -print0)
  fi

  # If there are no Recordings, then we've got nothing to train
  if (( $TOTAL_FILES == 0 )); then
    echo
    __error 'No Audio Recordings Located'
    __notice 'Looks like you may need to do some recording first: mimic studio'
    echo

    exit
  fi

  # If there are no Recordings, then we've got nothing to train
  if (( $TOTAL_FILES < 1000 )); then
    FORMATTED=$(numfmt --grouping $TOTAL_FILES)

    __notice "You will need a minimum of 1,000 Recordings to Generate a TTS Model ( $FORMATTED Recordings Located )"
    __output 'Mimic Trainer will still process recordings, but you will not be able to test your TTS voice in a browser.'
    echo
  fi

  # Clean Up Old Log Files
  rm -fr $TACOTRON/logs-tacotron/events.out.tfevents.*
  rm -fr $TACOTRON/logs-tacotron/*.log
  rm -fr $TACOTRON/training/*.npy
  rm -fr $TACOTRON/training/*.txt
  rm -fr $TACOTRON/visuals/*.png

  __output 'Starting Mimic Trainer'
  if [ -d $TRAINER ]; then
    # Check if docker is running
    if ! docker info > /dev/null 2>&1; then
      __error 'Docker does not seem to be running, run it first and retry'
      __notice 'Need to Install Docker? https://www.docker.com/products/docker-desktop'
      exit
    fi

    # Check if Docker Build needs to be created
    if [[ "$(docker images -q mycroft/mimic2:cpu 2> /dev/null)" == "" ]]; then
      __make_header 'Creating Docker Build'
      __notice 'We only need to create this once'
      docker build -t mycroft/mimic2:cpu -f $TRAINER/cpu.Dockerfile .
      __success 'Docker Build Complete'
    fi

    # Process Data from Mimic Recording Studio
    __make_header 'Processing Mimic Recording Studio Data'
    docker run --rm --name=mimic-my-voice \
      --mount type=bind,source=$STUDIO,target=/root/mimic-recording-studio \
      --mount type=bind,source=$TACOTRON,target=/root/tacotron \
      -p $PORT_TRAINER:$PORT_TRAINER mycroft/mimic2:cpu \
      "python3 -W ignore preprocess.py --dataset=mrs --mrs_dir=/root/mimic-recording-studio"

    __success 'Processing Data Complete'

    # Start Training Model
    __make_header 'Training Model'

    # Monitor the Training Process in Browser Window
    which -s tensorboard
    if [[ $? == 0 ]]; then
      # Kill Monitor if it's already running
      lsof -i TCP:6006 | grep LISTEN | awk '{print $2}' | xargs kill -9

      # Start Monitor
      tensorboard --logdir $TACOTRON/logs-tacotron --window_title "Mimic My Voice" &> $CWD/tensorboard.log &

      __output 'Opening Monitor in Browser to Track Model Training Progress'
      open http://localhost:6006
    fi

    # Train Model from Processed Recording Studio Data
    __output 'Starting Training on Mimic Recording Studio'
    docker run --rm --name=mimic-my-voice \
      --mount type=bind,source=$STUDIO,target=/root/mimic-recording-studio \
      --mount type=bind,source=$TACOTRON,target=/root/tacotron \
      -p $PORT_TRAINER:$PORT_TRAINER mycroft/mimic2:cpu \
      "python3 -W ignore train.py"

    __success 'Model Training Complete'

    # Gernatate Analytics ff we have a local version of Python Running
    # NOTE: This is using the NATIVE computer to generate the charts, as Docker does not generate Graphics
    #       unless you install X11 and configure a Display which requires some pretty serious changes
    #       to the users Operating System which I was not comfortable making a Requirement
    which -s python3
    if [[ $? == 0 ]]; then
      __make_header 'Generating Training Model Graphics'
      python3 -W ignore $TRAINER/analyze.py --train_file_path=$TACOTRON/training/train.txt --save_to=$TACOTRON/visuals --cmu_dict_path=$TACOTRON/training/cmudict-0.7b

      __output 'Opening Training Graphics in Preview'
      open $TACOTRON/visuals/*.png

      __success 'Model Graphics Generated'
    fi

    # TODO: Open Server to Test TTS Model ( Appears to Require at least 1,000 Recordings )

    # __output 'Opening Browser'
    # open http://localhost:$PORT_DEMO

    # TODO: Need to see how the `185000` "Chekpoint" portion works, and how I can use it to auto launch a server and test the TTS with text input

    # docker run --rm --name=mimic-my-voice \
    #  --mount type=bind,source=$STUDIO,target=/root/mimic-recording-studio \
    #  --mount type=bind,source=$TACOTRON,target=/root/tacotron \
    #   -p $PORT_TRAINER:$PORT_TRAINER mycroft/mimic2:cpu \
    #   "python3 -W ignore demo_server.py --checkpoint /root/tacotron/logs-tacotron/model.ckpt-185000"

    # TODO: There also appears to be an evaluation script that checks "alignment" so I will be interested to see what this actually does, but here is the code to run it

    # docker run --rm --name=mimic-my-voice \
    #  --mount type=bind,source=$STUDIO,target=/root/mimic-recording-studio \
    #  --mount type=bind,source=$TACOTRON,target=/root/tacotron \
    #   -p $PORT_TRAINER:$PORT_TRAINER mycroft/mimic2:cpu \
    #   "python3 -W ignore eval.py --checkpoint /root/tacotron/logs-tacotron/model.ckpt-185000

    __make_header 'TRAINING COMPLETE'
  else
    __error 'Missing Mimic Trainer - Run: mimin setup'
  fi

  exit
}

# Train Script for Windows
__train_windows(){
  __notice 'Windows Support Coming Soon'
  exit
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

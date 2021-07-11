#!/bin/bash
#
# description: Configuration for Mimic My Voice
#
# author: Peter Schmalfeldt <me@peterschmalfeldt.com>

# Load Common Functions
. "$(dirname "$0")/common.sh"

# Setup Script for Linux
function config_linux(){
  notice 'Windows Support Coming Soon'
  exit
}

# Setup Script for MacOS
function config_macos(){
  make_header 'Configuration Editor'

  # If no config detected, copy over template
  if ! mimic_has_config; then
    cp "$ENV.example" $ENV
  fi

  notice 'Need Help? https://github.com/manifestinteractive/mimic-my-voice/blob/main/docs/cmd-config.md \n'

  load_config

  # ==================================================

  # CONFIGURE AWS_ACCESS_KEY
  [[ $AWS_ACCESS_KEY ]] && DEFAULT=" [$AWS_ACCESS_KEY]" || DEFAULT=""
  read -p "AWS_ACCESS_KEY$DEFAULT: " VALUE
  VALUE=${VALUE:-$AWS_ACCESS_KEY}

  # Check if there was an update
  if [[ "$AWS_ACCESS_KEY" != "$VALUE" ]]; then
    REGEX='^[A-Z0-9]{20}$'

    if [[ $VALUE =~ $REGEX ]]; then
      sed -i '' "s/AWS_ACCESS_KEY=$AWS_ACCESS_KEY/AWS_ACCESS_KEY=$VALUE/g" $ENV
    else
      error 'Invalid Value for AWS_ACCESS_KEY'
      notice 'Must be 20 Characters, Uppercase & Alpha-Numeric'
    fi
  fi

  # ==================================================

  # CONFIGURE AWS_SECRET_KEY
  [[ $AWS_SECRET_KEY ]] && DEFAULT=" [$AWS_SECRET_KEY]" || DEFAULT=""
  read -p "AWS_SECRET_KEY$DEFAULT: " VALUE
  VALUE=${VALUE:-$AWS_SECRET_KEY}

  # Check if there was an update
  if [[ "$AWS_SECRET_KEY" != "$VALUE" ]]; then
    REGEX='^[A-Za-z0-9/+=]{40}$'

    if [[ $VALUE =~ $REGEX ]]; then
      # Escape possible slash characters in string
      VALUE=`echo $VALUE|sed 's/\//\\\\\//g'`
      sed -i '' "s/AWS_SECRET_KEY=$AWS_SECRET_KEY/AWS_SECRET_KEY=$VALUE/g" $ENV
    else
      error 'Invalid Value for AWS_SECRET_KEY'
      notice 'Must be 40 Characters, Alpha-Numeric & might contain /+= characters'
    fi
  fi

  # ==================================================

  # CONFIGURE AWS_S3_BUCKET
  [[ $AWS_S3_BUCKET ]] && DEFAULT=" [$AWS_S3_BUCKET]" || DEFAULT=""
  read -p "AWS_S3_BUCKET$DEFAULT: " VALUE
  VALUE=${VALUE:-$AWS_S3_BUCKET}

  # Check if there was an update
  if [[ "$AWS_S3_BUCKET" != "$VALUE" ]]; then
    REGEX='^[A-Za-z0-9][A-Za-z0-9\-]{1,61}[A-Za-z0-9]$'

    if [[ $VALUE =~ $REGEX ]]; then
      sed -i '' "s/AWS_S3_BUCKET=$AWS_S3_BUCKET/AWS_S3_BUCKET=$VALUE/g" $ENV
    else
      error 'Invalid Value for AWS_S3_BUCKET'
      notice 'Must be 3-63 Characters, Alpha-Numeric and can contain dashes'
    fi
  fi

  # ==================================================

  # CONFIGURE AWS_S3_REGION
  [[ $AWS_S3_REGION ]] && DEFAULT=" [$AWS_S3_REGION]" || DEFAULT=""
  read -p "AWS_S3_REGION$DEFAULT: " VALUE
  VALUE=${VALUE:-$AWS_S3_REGION}

  # Check if there was an update
  if [[ "$AWS_S3_REGION" != "$VALUE" ]]; then
    REGEX='^us-east-2$|^us-east-1$|^us-west-1$|^us-west-2$|^af-south-1$|^ap-east-1$|^ap-south-1$|^ap-northeast-3$|^ap-northeast-2$|^ap-southeast-1$|^ap-southeast-2$|^ap-northeast-1$|^ca-central-1$|^cn-north-1$|^cn-northwest-1$|^eu-central-1$|^eu-west-1$|^eu-west-2$|^eu-south-1$|^eu-west-3$|^eu-north-1$|^me-south-1$|^sa-east-1$'

    if [[ $VALUE =~ $REGEX ]]; then
      sed -i '' "s/AWS_S3_REGION=$AWS_S3_REGION/AWS_S3_REGION=$VALUE/g" $ENV
    else
      error 'Invalid Value for AWS_S3_REGION'
      notice 'Must be a supported AWS region ( SEE: https://docs.aws.amazon.com/general/latest/gr/rande.html ) '
    fi
  fi

  # ==================================================

  # CONFIGURE MRS_PORT_BACKEND
  [[ $MRS_PORT_BACKEND ]] && DEFAULT=" [$MRS_PORT_BACKEND]" || DEFAULT=""
  read -p "MRS_PORT_BACKEND$DEFAULT: " VALUE
  VALUE=${VALUE:-$MRS_PORT_BACKEND}

  # Check if there was an update
  if [[ "$MRS_PORT_BACKEND" != "$VALUE" ]]; then
    REGEX='^[0-9]+$'

    if [[ $VALUE =~ $REGEX ]]; then
      sed -i '' "s/MRS_PORT_BACKEND=$MRS_PORT_BACKEND/MRS_PORT_BACKEND=$VALUE/g" $ENV
    else
      error 'Invalid Value for MRS_PORT_BACKEND'
      notice 'Use Numbers Only.'
    fi
  fi

  # ==================================================

  # CONFIGURE MRS_PORT_FRONTEND
  [[ $MRS_PORT_FRONTEND ]] && DEFAULT=" [$MRS_PORT_FRONTEND]" || DEFAULT=""
  read -p "MRS_PORT_FRONTEND$DEFAULT: " VALUE
  VALUE=${VALUE:-$MRS_PORT_FRONTEND}

  # Check if there was an update
  if [[ "$MRS_PORT_FRONTEND" != "$VALUE" ]]; then
    REGEX='^[0-9]+$'

    if [[ $VALUE =~ $REGEX ]]; then
      sed -i '' "s/MRS_PORT_FRONTEND=$MRS_PORT_FRONTEND/MRS_PORT_FRONTEND=$VALUE/g" $ENV
    else
      error 'Invalid Value for MRS_PORT_FRONTEND'
      notice 'Use Numbers Only.'
    fi
  fi

  # ==================================================

  # CONFIGURE MRS_CORPUS_CSV
  [[ $MRS_CORPUS_CSV ]] && DEFAULT=" [$MRS_CORPUS_CSV]" || DEFAULT=""
  read -p "MRS_CORPUS_CSV$DEFAULT: " VALUE
  VALUE=${VALUE:-$MRS_CORPUS_CSV}

  # Check if there was an update
  if [[ "$MRS_CORPUS_CSV" != "$VALUE" ]]; then
    REGEX='^[a-zA-Z_.]+csv$'

    if [[ $VALUE =~ $REGEX ]]; then
      sed -i '' "s/MRS_CORPUS_CSV=$MRS_CORPUS_CSV/MRS_CORPUS_CSV=$VALUE/g" $ENV
    else
      error 'Invalid Value for MRS_CORPUS_CSV'
      notice 'A-Z, dash or underscore characters only.  Must end with .csv'
    fi
  fi

  # ==================================================

  # CONFIGURE MRS_USERNAME
  [[ $MRS_USERNAME ]] && DEFAULT=" [$MRS_USERNAME]" || DEFAULT=""
  read -p "MRS_USERNAME$DEFAULT: " VALUE
  VALUE=${VALUE:-$MRS_USERNAME}

  # Check if there was an update
  if [[ "$MRS_USERNAME" != "$VALUE" ]]; then
    REGEX='^[a-zA-Z0-9_-]$'

    if [[ $VALUE =~ $REGEX ]]; then
      sed -i '' "s/MRS_USERNAME=$MRS_USERNAME/MRS_USERNAME=$VALUE/g" $ENV
    else
      error 'Invalid Value for MRS_USERNAME'
      notice 'Username can only contain A-Z, 0-9, underscores and dashes'
    fi
  fi

  # ==================================================

  success 'Configation Saved'

  # Update Environment with New Confic
  load_config

  exit
}

# Setup Script for Windows
function config_windows(){
  notice 'Windows Support Coming Soon'
  exit
}

# Check which OS we are using
case "$(uname -s)" in
  Linux*)
    config_linux
  ;;
  Darwin*)
    config_macos
  ;;
  MINGW*)
    config_windows
  ;;
  *)
    error 'Unsupported Operating System'
  ;;
esac

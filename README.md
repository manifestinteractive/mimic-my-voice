![Logo](docs/img/mycroft-logo.png "Logo")

Mimic My Voice
===

> Text to Speech Engine using My Voice using Mycroft Mimic Trainer & Mimic Recording Studio.

### NOTE:  This is a Work in Progress

![Audio](docs/img/audio.png "Audio")
## Features

- [X] [Mycroft Mimic Trainer](https://github.com/MycroftAI/mimic2) Automation
- [X] [Mycroft Recording Studio](https://github.com/MycroftAI/mimic-recording-studio) Automation
- [X] [AWS S3](https://aws.amazon.com/s3/) Backup & Restore

## Requirements

- [X] [Node v12+](https://nodejs.org/en/download/)
- [X] [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [X] [AWS S3 Account](https://aws.amazon.com/s3) _( only required for Backup & Restore )_

## Developer Overview

#### Commands

Command                                | Description
---------------------------------------|--------------------------
[`mimic setup`](docs/cmd-setup.md)     | Install Mimic & Mimic Studio
[`mimic studio`](docs/cmd-studio.md)   | Launch Mimic Recording Studio
[`mimic train`](docs/cmd-train.md)     | Launch Mimic Training
[`mimic backup`](docs/cmd-backup.md)   | Backup Mimic Sessions to AWS S3
[`mimic restore`](docs/cmd-restore.md) | Restore Mimic Sessions from AWS S3
[`mimic help`](docs/cmd-help.md)       | Get Help with Mimic My Voice

#### Additional Information

- [X] [Troubleshooting](docs/troubleshooting.md)

#### Install via NPM

```bash
npm install -g mimic-my-voice
mimic setup
```

#### Install via Clone

```bash
git clone git@github.com:manifestinteractive/mimic-my-voice.git
cd mimic-my-voice
npm install -g
mimic setup
```

## Disclaimer

The trademarks and product names of Mycroft, including the Mycroft mark, are the property of [Mycroft.ai](https://mycroft.ai). Peter Schmalfeldt is not affiliated with Mycroft, nor does Mycroft sponsor or endorse Peter Schmalfeldt's projects or website. The use of the Mycroft trademark on this project does not indicate an endorsement, recommendation, or business relationship between Mycroft and Peter Schmalfeldt.

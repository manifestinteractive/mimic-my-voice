![Header Logo](img/header.png "Header Logo")

**[↤ Developer Overview](../README.md#developer-overview)**

`mimic config`
---

> Application Configuration Made Easy

Easily configure everything your project needs by entering the following command ( NOTE: This is required before running `mimic setup` ):

```bash
mimic config
```

AWS S3 Configuration
---

Before you can perform a backup or restore, you will need to provide the following AWS Credentials:

Name           | Example                                    | Definition
---------------|--------------------------------------------|-----------------------------------------------
AWS_ACCESS_KEY | `AKIAIOSFODNN7EXAMPLE`                     | [\[?\]](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html) AWS Access Key
AWS_SECRET_KEY | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` | [\[?\]](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html) AWS Secret Key
AWS_S3_BUCKET  | `mimic-my-voice`                           | [\[?\]](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html) AWS S3 Bucket Name
AWS_S3_REGION  | `us-east-1`                                | [\[?\]](https://docs.aws.amazon.com/general/latest/gr/s3.html) AWS S3 Bucket Region

Mimic Recording Studio Configuration
---

Name                        | Example              | Definition
----------------------------|----------------------|-----------------------------------------------
MRS_CORPUS_CSV <sup>1</sup> | `english_corpus.csv` | Name of the CSV file to use in the prompts directory
MRS_PORT_BACKEND            | `5000`               | This is the Port you want use for Mimic Recording Studios Back-end API
MRS_PORT_FRONTEND           | `3000`               | This is the Port you want use for Mimic Recording Studios Front-end Client
MRS_PROMPT_SPEED            | `0.9`                | [\[?\]](https://developer.mozilla.org/en-US/docs/Web/API/SpeechSynthesisUtterance/rate) Speed to use for Browsers TTS when Reading Prompt
MRS_PROMPT_VOICE            | `Google US English`  | [\[?\]](https://developer.mozilla.org/en-US/docs/Web/API/SpeechSynthesis/getVoices) Voice to use for Browsers TTS when Reading Prompt
MRS_USERNAME                | `default_user`       | Username you are using for Mimic Recording Studio _( only A-Z, underscore or dashes )_

Footnotes
---

1. If you have a custom CSV file you want to read from, place it in the `mimic-my-voice/mimic-recording-studio/backend/prompts/` directory and set the `MRS_CORPUS_CSV` configuration option to be just the file name.

![Logo](img/mycroft-logo.png "Logo")

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

Name                 | Example              | Definition
---------------------|----------------------|-----------------------------------------------
PORT_STUDIO_BACKEND  | `5000`               | This is the Port you want use for Mimic Recording Studios Back-end API
PORT_STUDIO_FRONTEND | `3000`               | This is the Port you want use for Mimic Recording Studios Front-end Client
CORPUS <sup>1</sup>  | `english_corpus.csv` | Name of the CSV file to use in the prompts directory

Footnotes
---

1. If you have a custom CSV file you want to read from, place it in the `mimic-my-voice/mimic-recording-studio/backend/prompts/` directory and set the `CORPUS` configuration option to be just the file name.

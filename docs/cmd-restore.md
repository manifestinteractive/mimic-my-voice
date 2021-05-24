![Logo](img/mycroft-logo.png "Logo")

**[↤ Developer Overview](../README.md#developer-overview)**

`mimic restore`
---

> Restore Mimic Sessions from AWS S3

Restore your Mimic Recording Sessions from Amazon AWS S3 using one of the following commands:

```bash
mimic restore
mimic restore --dry-run
mimic restore --no-delete
```

**FLAGS:**

Name      | Flag          | Required | Definition
----------|---------------|----------|----------------------------------------------
Dry Run   | `--dry-run`   | No       | Perform Dry Run of Backup
No Delete | `--no-delete` | No       | Skip Deleting Local Files not in Backup

AWS S3 Configuration
---

In order to use AWS S3, you will need to provide your AWS credentials in the `.env` file.  If you have not already done so, duplicate the `.env.example` file and name it `.env` in the same directory.

Before you can perform a backup, you will need to edit your `.env` file and provide the following AWS Credentials:

Name           | Example                                    | Definition
---------------|--------------------------------------------|-----------------------------------------------
AWS_ACCESS_KEY | `AKIAIOSFODNN7EXAMPLE`                     | [\[?\]](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html) AWS Access Key
AWS_SECRET_KEY | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` | [\[?\]](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html) AWS Secret Key
AWS_S3_BUCKET  | `mimic-my-voice`                           | [\[?\]](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html) AWS S3 Bucket Name
AWS_S3_REGION  | `us-east-1`                                | [\[?\]](https://docs.aws.amazon.com/general/latest/gr/s3.html) AWS S3 Bucket Region

#### SAMPLE `.env`

```
AWS_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
AWS_S3_BUCKET=mimic-my-voice
AWS_S3_REGION=us-east-1
```

This ansible cookbook is responsible for provisioning the needed accessory resources.

### Requirements

- Ansible >= 2.4
- boto libs
- AWS cli already configured with your credentials

### Run it!

First, ensure your AWS credentials are working using the AWS cli.

Then, run the playbook with `./playbook.yml`.

### What it does

At the moment, the playbook only serves as a wrapper to execue a [CloudFormation template](templates/main.template.yml) which will:
- Create an S3 bucket for the application
- Create an IAM user able only to operate on the S3 bucket
- Create a pair of AWS credentials for the IAM user
- Return the S3 Bucket and the AWS credentials

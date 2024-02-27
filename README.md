# Balance reporter

**Author: CesarF**

Application to process transactions data (including debit and credit transactions) that belongs to a account.

## Project structure
```
/
│
├── app # application code
│
├── config # initial configurations for some images
|
├── data # folder that will be mounted in the local execution. Contains the csv file.
│
├── images # assets
|
├── infra # TBI
|
├── docker-compose.yml # local deployment
|
└── README.md # you are here
```

## Local implementation

The local implementation allows to run the application locally using technologies in containers. Instead using cloud provider services, it uses mongodb and fastapi.

### Implementation details

- database: mongodb
- runtime: fastapi, uvicorn
- email: smpt implementation
- file: load file from volume

Check the docker compose file for more details

### How to run

Install Docker in your environment if they are not already installed. Then, create a file named `local.env` in the root of this repository and include the next environment variables:

```
# local.env
EMAIL_SENDER=<email>
EMAIL_SENDER_PWD=<email password>
EMAIL_RECIPIENT=<email>
SMTP_SERVER=<smtp host>
SMTP_PORT=<smtp port>
```

Execute:

```bash
# create the image for local execution
make build

# execute docker compose
make run

# open another terminal (it is not using detach mode) and execute

curl -XPOST "http://localhost:9000/execute" -d '{}'
```

If everything worked as expected, you should see a response like this:

```
{'result':{'Message sent to <recipient email>':true}}
```

The recipient should have received an email like this one:

![email](./images/email_example.png)

Also, you can see the information stored in the database entering the url `http://0.0.0.0:8081` in your browser; username `admin` password `pass`. Navigate to `accounts` database and select the record:

![email](./images/mongo_db_example.png)

Update the data in `./data/txns.csv` and execute again the curl command.

### How to test

Just execute

```bash
make test
```

## AWS Implementation

The AWS implementation allows to run the application on a cloud provider using AWS services.

### Implementation details

- database: dynamodb
- runtime: Lambda function
- email: SES
- file: S3 Bucket

### How to deploy

To deploy this in your own account, follow the next steps:

First, install the next tools:

- Terraform
- AWS CLI
- Docker
- Access to a AWS account

First you need to configure your AWS user. Use `aws configure` to set an access key and a secret key to your account. Note: your user requires enough permissions to manage s3, Dynamo, SES, Lambda, API Gateway and IAM.

Take into account all the components will be deployed in us-east-1 region.

After configure your user, create the registry for the lambda function container image.

```bash
STACK=registry make tf-init

STACK=registry make tf-plan

STACK=registry make tf-deploy
```

Next, you will need to upload the image using the next commands:

```bash
# create the image for aws execution
make build STAGE=aws

# login with ECR repository
make login ACCOUNT=<your account id>

# upload your image
make push ACCOUNT=<your account id>
```

It is time to create the rest of the infrastructure. Create a file named `aws.env` in the root folder and add the next content:

```
# aws.env
email_sender="<email>"
email_recipient="<email>"
```

Then, execute the next commands

```bash
STACK=app make tf-init

STACK=app EXTRA_VARS=-var-file=${PWD}/aws.env make tf-plan

STACK=app make tf-deploy
```

If everything works, you should see this output in your terminal:

```bash
...
Apply complete! Resources: x added, x changed, 0 destroyed.

Outputs:

bucket_name = "balance-processor-dev--<random-value>"
```

Copy the bucket name and execute the next command. The csv file will be uploaded to the s3 bucket

```bash
make upload BUCKET=<bucket-name>
```

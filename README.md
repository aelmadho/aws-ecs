# ECS Cluster

This is a reference architecture describing best practices when deploying services with AWS EC2 Container Services (ECS).  It is a collection of Cloudformation templates and scripts that customizes an ECS cluster, and and a sample webservice running httpd.  The list below describes the list of artifacts used in this process:

1. Cloudformation templates to launch a VPC, networking, security-groups, ECS cluster and repositories.
2. Customized ECS cluster with logging support and EFS for supporting file-system stateful services
3. Sample web service

### Requirements:

1. Place the cloudformation scripts in an S3 bucket and update TemplateURL under root/parameters/dev.json to reflect that value.
2. Create an EC2 keypair, upload it to the AWS console on the region in context, and update the dev.json with the keypair name.

The following commands can be used to upload the files

```
aws s3 cp . s3://<TemplateBucket>/
```

### Cloudformation

1. Update bootstrap.sh with AWS profile, region, cloudformation S3 bucket details
2. Run bootstrap.sh or Run the command below for a specific environment

The following cloudformation templates provide a sekelton to provision a secure ECS platform.  The command below provisions the full infrastructure and ECS setup for the environment listed.  Ensure to update the <TemplateBucket> value as well as your <AWS_PROFILE> to use with aws-cli.

```
export environment="dev"
aws cloudformation create-stack --stack-name ${environment} --template-url https://s3.amazonaws.com/<TemplateBucket>/root/init.yaml --parameters file://root/parameters/${environment}.json --capabilities CAPABILITY_NAMED_IAM --profile <AWS_PROFILE> --region us-east-1  --disable-rollback || true
```

You can also bootstrap the environment once you have updated the bootstrap.sh with the S3 buckets and proper values/profile.

```
bash bootstrap.sh
```


### Verification

Once the stack is deployed, you can navigate to the cloudformation console, and under exports, browse to the URL that is exposed under '"dev-ALBDnsUrl"', which will point to our webservice.  You should see "It Works!".



#!/bin/bash
set -o pipefail -e


# Update these to reflect your environment
# AWS profile, Region, S3 Bucket, SSH Key for instances and bastion host
aws_profile="isengard"
aws_region="us-east-1"
aws_s3_bucket="aelmadho-ecs-cluster"
aws_key_name="aelmadho-ecs-cluster"
aws_bastion_key_name="aelmadho-ecs-cluster"

# Add to the list as many environments as you need
environments=(dev)

# Create bucket if it does not exist and don't fail.
aws s3api create-bucket --bucket ${aws_s3_bucket} --profile ${aws_profile} --region ${aws_region} || true 

# Update bucket
echo "Update bucket with cloudformation scripts"
aws s3 sync . s3://${aws_s3_bucket} --profile ${aws_profile} --exclude=.git

# provision environments
for environment in ${environments[@]}; do
	aws cloudformation create-stack \
		--stack-name ${environment} \
		--template-url https://s3.amazonaws.com/${aws_s3_bucket}/root/init.yaml \
		--parameters file://root/parameters/${environment}.json \
		--capabilities CAPABILITY_NAMED_IAM \
		--profile ${aws_profile} \
		--region ${aws_region} \
		--disable-rollback || true
done

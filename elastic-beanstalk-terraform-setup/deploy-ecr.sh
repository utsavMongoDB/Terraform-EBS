#!/bin/bash
# usage: ./deploy-ecr.sh terraform-partner test us-east-1
echo Creating deployment plan............
terraform plan -out plan.tfplan

echo Applying plan............
terraform apply plan.tfplan    

# Name of your application, should be the same as in setup
NAME=$1

# Stage/environment e.g. `staging`, `test`, `production``
STAGE=$2

# AWS Region where app should be deployed e.g. `us-east-1`, `eu-central-1`
REGION=$3

EB_BUCKET=$NAME-deployments
ENV=$NAME-$STAGE
VERSION=$STAGE-$(date +%s)
ZIP=$VERSION.zip

# Zip up the Dockerrun file
echo Zipping Dockerrun.aws.json............
zip -r $ZIP Dockerrun.aws.json

# Send zip to S3 Bucket
echo Uploading Zip file to S3 bucket............
aws s3 cp $ZIP s3://$EB_BUCKET/$ZIP

# Create a new application version with the zipped up Dockerrun file
echo Using latest s3 file to create new application version on elasticbeanstalk............
aws elasticbeanstalk create-application-version --application-name $NAME --version-label $VERSION --source-bundle S3Bucket=$EB_BUCKET,S3Key=$ZIP

# Update the environment to use the new application version
echo Updating environment............
aws elasticbeanstalk update-environment --environment-name $ENV --version-label $VERSION

echo Deploy ended with success!!!
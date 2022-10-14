# Terraform-EBS

#### Pre-requisites:
1. Add AWS Credentials in ~/.aws/credentials
2. Add aws-cli credentials

#### Push Docker image to ECR
 - Add the ECR URI in Dockerrun.aws.json 

#### Run script:

 ```./deploy-ecr.sh <application-name>```


 - This will plan terraform deployment
 - Apply the plan and deploy changes to AWS environment
 - ZIP the Dockerrun.aws.json file and push to S3 bucket, then apply the changes to beanstalk using aws cli

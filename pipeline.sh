#!/bin/bash
#script used to deploy applications to AWS Elastic Beanstalk

set -e
start=`date +%s`

NAME=$1
# Stage
STAGE=$2
# AWS Region 
REGION=$3
# Hash of commit 
SHA1=$4

EB_BUCKET=$NAME-deployments
ENV=$NAME-$STAGE
VERSION=$STAGE-$SHA1-$(date +%s)
ZIP=$VERSION.zip

aws configure set default.region $REGION
aws configure set default.output json

# Login into AWS 
eval $(aws ecr get-login)

# --------- docker part comes later ---------
# Build the image
#docker build -t $NAME:$VERSION .
# Tag it
#docker tag $NAME:$VERSION $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$NAME:$VERSION
# Push to AWS Elastic Container Registry
#docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$NAME:$VERSION

zip -r $ZIP Dockerrun.aws.json
# Send zip to S3 Bucket
aws s3 cp $ZIP s3://$EB_BUCKET/$ZIP

# create new app with dockerfile 
aws elasticbeanstalk create-application-version --application-name $NAME --version-label $VERSION --source-bundle S3Bucket=$EB_BUCKET,S3Key=$ZIP
# update env  
aws elasticbeanstalk update-environment --environment-name $ENV --version-label $VERSION

# plan and apply terraform
.\terraform plan
.\terraform apply

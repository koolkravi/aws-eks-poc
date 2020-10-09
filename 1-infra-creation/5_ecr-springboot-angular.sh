#!/bin/sh

AWS_ACCOUNT_ID=XXXXXXXXXXXX
# Step 1:ECR Repository for spring boot appication 
aws ecr create-repository \
     --repository-name  spring-boot-postgres-poc \
     --region us-west-2

aws ecr get-login-password \
     --region us-west-2 | docker login \
     --username AWS \
     --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/spring-boot-postgres-poc
	 
# Step 2:ECR Repository for Angular appication 
aws ecr create-repository \
   --repository-name  eks-angular-poc \
   --region us-west-2

aws ecr get-login-password \
   --region us-west-2 | docker login \
   --username AWS \
   --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/eks-angular-poc
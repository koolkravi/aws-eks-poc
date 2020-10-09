#!/bin/sh

VERSION=v0.0.1
AWS_ACCOUNT_ID=XXXXXXXXXXXX

# Step 2: Create Docker Image
docker build -t $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/eks-angular-poc:$VERSION .

# Step 3: Push Image to ECR repository
docker push  $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/eks-angular-poc:$VERSION

# Step 4: Deploy application to EKS 
kubectl apply -f manifest/angular-app.yaml

# Step 5 : LoadBalancer (External URL)
POD=$(kubectl get svc -l app=eks-angular-poc-loadbalancer | grep LoadBalancer | awk '{print $4}')
echo "${POD}"


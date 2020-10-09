#!/bin/sh

# Step 1: Delete Angular
cd 2-deploy-poc-application/3-frontend-angular
kubectl delete -f manifest/angular-app.yaml
cd ../..

# Step 2: Delete Spring boot
cd 2-deploy-poc-application/2-backend-springboot
kubectl delete -f manifest/spring-boot-app.yaml
cd ../..

# Step 3: Delete  Config map
kubectl delete cm hostname-config

# Step 4: Delete DB POstgress
cd 2-deploy-poc-application/1-db
kubectl delete -f postgres.yaml
cd ../..

# Step 5: Delete ECR
aws ecr delete-repository \
    --repository-name  eks-angular-poc \
    --force
aws ecr delete-repository \
    --repository-name  spring-boot-postgres-poc \
    --force



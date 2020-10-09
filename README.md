* AWS EKS Infrastructure creation using Cloud formation and POC Application Deployment

* High Level Tasks
# Step A : Create EKS Cluster using Cloud formation - Infrastructure
# Step B : Create EKS Worker Nodes using kubernetes manifest - Infrastructure
# Step C : Deploy POC application using kubernetes manifest 

* Implementation

# Pre requisite:

- Create Dedicated VPC for the EKS Cluster

  Stack name 		: **eks-vpc** 
  ```
  CloudFormation Template: 
  0_cloudFormation_amazon-eks-vpc-private-subnets.yaml
  ```

# Step A : Step A : Create EKS Cluster using Cloud formation - Infrastructure

## Step 1: Create IAM role for EKS Cluster 

Stack name: **eksClusterRole**
```
CloudFormation Template:  
1_cloudFormation_eksClusterRole.yaml
```

## Step 2: Create EKS Cluster
Stack name 		: **eks-cluster** 
Cluster name 	: **eks-cluster**
```
CloudFormation Template:  
2_cloudFormation_ekscluster.yaml
```

### Test Cluster
Note : install aws cli and install kubectl on your local machine
```
aws  eks --region us-west-2 update-kubeconfig --name eks-cluster
kubectl get svc
```

# Step B : Create EKS Worker Nodes using kubernetes manifest - Infrastructure

## Step 3: Create IAM Role for EKS Worker Nodes
Stack name 		: **eksWorkerNodeGroupRole** 

Below  template will create amazon eks nodegroup role along with needed Node group cluster autoscaler policy
```
CloudFormation Template:  
3_cloudFormation_amazon-eks-nodegroup-role_with_cluster_autoscaler_policy.yaml
```

## Step 4: Create Worker nodes
Stack name 		: **eks-worker-node-group** 

```
CloudFormation Template:  
4_cloudFormation_amazon-eks-nodegroup-role_with_cluster_autoscaler_policy.yaml
```

### Test Cluster
```
kubectl get nodes -o wide
```

# Step C : Deploy POC application using kubernetes manifest 

## Step 1: Deploy PostgreSQL DB cluster into EKS

### Step 1.1: Execute below kubernetes manifest
Service Name	: **postgres**
```
kubectl create -f resources/postgres.yaml
```

## Step 1.2: Create a config map with the hostname of Postgres
This config map will be used in Spring Boot Application as part of JDBC connection URL
```
kubectl create configmap hostname-config --from-literal=postgres_host=$(kubectl get svc postgres -o jsonpath="{.spec.clusterIP}")
```

## Step 2: Deploy Spring Boot Application into EKS

### Pre-requisite

- Create ECR Repository and authenticate Docker

  Repository name : **spring-boot-postgres-poc**
  update script placeholder XXXXXXXXXXXX with AWS ACCOUNT ID and Execute below script
  ```
  ./resources/5_ecr-springboot-angular.sh
  ```
  
### Step 2.1. Build Spring boot docker image, push to ECR and Deploy to EKS

Service Name	: **spring-boot-postgres-poc**
update script placeholder XXXXXXXXXXXX with AWS ACCOUNT ID and Execute below script
```
6_backend-springboot-build-push-to-ecr.sh
```

Test
```
kubectl get svc spring-boot-postgres-poc
OPEN FROM BROWSER: 
http://<External IP Address>:8080

REST APIs - Test FROM Postman
API http://<External IP Address>:8080/api/v2/employees
```

### Step 3: Deploy frontend(Angular) into EKS

### Pre-requisite
- Create ECR Repository and authenticate Docker
  Repository name : **eks-angular-poc**
  This is alreday created from script in Step C->Step 2->Pre-requisite->5_ecr-springboot-angular.sh

### Step 3.1. Build Angular docker image, push to ECR and Deploy to EKS

Service Name	: **eks-angular-poc-loadbalancer**
importtant files **custom-nginx.conf** and *Dockerfile*
update script placeholder XXXXXXXXXXXX with AWS ACCOUNT ID and Execute below script

```
7_front-angular-build-push-to-ecr.sh
```

Test
```
kubectl get svc eks-angular-poc-loadbalancer
http://<External IP Address>
```


# Reference
```
kubectl scale deployment spring-boot-postgres-poc --replicas=3

```
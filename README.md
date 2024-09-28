# Terraform AWS Project: Web Servers with Proxy and Load Balancers 

This Terraform project sets up an AWS infrastructure with proxy servers and web servers, along with load balancers to manage traffic. The infrastructure includes a **Virtual Private Cloud (VPC)**, public and private subnets, **NAT Gateway**, and **Internet Gateway** for seamless internet access. It also uses an **S3 bucket** for state storage and **DynamoDB** for state locking.

## 📊Project Overview

### Main Components:

1.  **VPC and Subnets**:
    
    -   A custom **VPC** is created to host the resources.
    -   **2 Public Subnets**: These subnets host the proxy servers and NAT Gateway.
    -   **2 Private Subnets**: These subnets host the web servers.
2.  **Internet Gateway** (IGW):
    
    -   The Internet Gateway allows resources in the public subnets (e.g., proxy servers) to have internet access.
3.  **NAT Gateway**:
    
    -   Deployed in the public subnet, the NAT Gateway allows resources in the private subnets (e.g., web servers) to initiate outbound connections to the internet (for updates or downloads) without exposing them to inbound internet traffic.
4.  **Proxy Servers** (Public Subnet):
    
    -   Managed by a **Network Load Balancer (NLB)**.
    -   ![tf7111](https://github.com/user-attachments/assets/41f8bbdb-2c13-4648-bb7c-edf5a4081e7e)

5.  **Web Servers** (Private Subnet):
    
    -   Managed by an **Application Load Balancer (ALB)**.
      
 ![tf6](https://github.com/user-attachments/assets/76a69e8a-45c0-4a69-9d74-800aeeecfdd6)

6.  **State Management**:
    -   State is stored in an S3 bucket (`terraform-project-backend-s3`).
    -   Locking is handled by DynamoDB to prevent conflicts during updates.

### Architecture Summary
![terraform-project drawio](https://github.com/user-attachments/assets/61717f49-e4ef-4ad0-ad43-ac036f7401aa)


## 📋Prerequisites

-   **AWS CLI** installed.
-   **Terraform** version 1.x.x.
-   S3 bucket for storing state.
-   DynamoDB for state locking.
-   AWS credentials with required permissions.

## 🌐VPC and Networking Setup

The project sets up a **Virtual Private Cloud (VPC)** with the following network configuration:

1.  **VPC**:
    -   A custom VPC is created to host all the resources.
2.  **Public Subnets**:
    -   Two public subnets in different availability zones (`us-east-1a` and `us-east-1b`) for the proxy servers and NAT Gateway.
3.  **Private Subnets**:
    -   Two private subnets in the same availability zones (`us-east-1a` and `us-east-1b`) for the web servers. These private subnets do not have direct internet access for security reasons.
4.  **Internet Gateway** (IGW):
    -   An Internet Gateway is attached to the VPC to allow internet access for the public subnets.
5.  **NAT Gateway**:
    -   The NAT Gateway is deployed in one of the public subnets to provide internet access to the web servers in the private subnets. This ensures that the private instances can initiate outbound internet traffic (for updates, etc.) but are not exposed to incoming internet traffic.

![tf8](https://github.com/user-attachments/assets/bc92dea0-b280-4992-9a56-7f37099cd923)

### Routing:

-   **Public Subnets**: Associated with a route table that sends internet-bound traffic through the **Internet Gateway (IGW)**.
-   **Private Subnets**: Associated with a route table that sends outbound internet-bound traffic through the **NAT Gateway**.

## Provisioners

-   **Remote-exec provisioner**: Configures web servers remotely.
-   **File provisioner**: Copies files to web servers.
-   **Local-exec provisioner**: Extracts private IPs into `IPs.txt`.


## How to Use

### 1. Clone the Repository

```
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
``` 

### 2. Initialize Terraform

`terraform init` 

### 3. Select the Workspace

```
terraform workspace select Dev
``` 

### 4. Apply the Configuration

```
terraform apply
``` 
![tf1](https://github.com/user-attachments/assets/efb60bd7-8d70-4025-880d-e6af32dc343a)

### 5. Get Web Server IPs

```
cat IPs.txt
```
----------

## Accessing the Web Servers via NLB DNS

After applying the Terraform configuration, the **Network Load Balancer (NLB)** will have a DNS name that you can use to access the web servers. You can get the NLB DNS name from the Terraform output.

### 🔍How to Find the NLB DNS Name in Terraform Output:

1.  After the `terraform apply` command completes, the output will display the **NLB DNS Name**. Look for a line like this:
    
    `nlb_dns_name = "nlb-1234567890abcdef.elb.amazonaws.com"` 
    
2.  Copy the **NLB DNS Name** from the output.
    

### ✔️Testing the Connection

-   Open your browser and paste the NLB DNS name into the address bar. You should see the web application hosted on the private web servers.
- Since you have **two web servers**, refreshing the page will distribute the traffic across both servers via the **Application Load Balancer (ALB)**. Each refresh may connect you to a different web server depending on the load balancing algorithm.

![tf2](https://github.com/user-attachments/assets/94830e9e-4359-43d3-bdab-f89a69bac93d)

![tf3](https://github.com/user-attachments/assets/8d45ad1e-fc0e-44ab-bb2e-e5fef7c08891)

----------


## Project Breakdown

-   **VPC**: A virtual private cloud that contains all resources.
-   **Public Subnets**: Host proxy servers and NAT Gateway.
-   **Private Subnets**: Host web servers and do not have direct internet access.
-   **NAT Gateway**: Allows outbound internet access for private instances.
-   **NLB (Network Load Balancer)**: Distributes traffic to proxy servers.
-   **ALB (Application Load Balancer)**: Distributes traffic from the proxy servers to the web servers.
-   **S3 Bucket**: Stores the Terraform state.
-   **DynamoDB Table**: Locks the state to prevent conflicts.

## 📈State Management

State is stored and locked using the following configuration:
```
terraform {
  backend "s3" {
    bucket         = "terraform-project-backend-s3"
    key            = "state/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
} 
```
![tf4](https://github.com/user-attachments/assets/6fc647ed-aa2c-4ba1-9c9c-e228ebe49c69)

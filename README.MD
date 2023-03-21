# Framework for Automated Distributed Cloud Web Application Honeypot Deployment and Attack Data Analytics

This project provides a framework for deploying a distributed cloud-based honeypot and analyzing attack data. 
The honeypot is based on a containerized Python application that can be deployed anywhere, and the infrastructure is created using Terraform.
The controller also acts as an XDs server.

## Project Structure
The project has the following file structure:
```
├── controllers
│   ├── Dockerfile
│   ├── app.py
│   ├── listener.py
│   └── proto
│       ├── ads.proto
│       ├── base.proto
│       ├── discovery.proto
│       └── listener_components.proto
├── docker-compose.yaml
├── docker-install.sh
├── kubernetes
│   ├── deployment.yaml
│   ├── helm.sh
│   ├── ingress.yaml
│   ├── mirror-deployment.yaml
│   ├── nginx-ingress.yaml
│   └── values-prom.yaml
├── pyattack
│   ├── Dockerfile
│   └── test-attack.py
└── terraform
    └── EKS-Fargate
        ├── aws_eks
        │   ├── data.tf
        │   ├── local.tf
        │   ├── main.tf
        │   └── variables.tf
        ├── aws_vpc
        │   ├── main.tf
        │   ├── output.tf
        │   ├── terraform.tfvars
        │   └── variables.tf
        └── main.tf
```

# controllers
This directory contains the Python controller application that runs the honeypot. It includes a Dockerfile for building the container image, app.py for the main controller logic, listener.py for handling incoming requests, and a proto directory for the protocol buffer definitions used by the controller.

# docker-compose.yaml
This file is used to start up the controller application, along with any required dependencies, using Docker Compose.

# docker-install.sh
This script installs the necessary dependencies for running Docker and Docker Compose on the host system.

# kubernetes
This directory contains Kubernetes deployment files for running the honeypot on a Kubernetes cluster. It includes deployment and ingress files, as well as a values file for configuring Prometheus monitoring.

# pyattack
This directory contains a Python script for testing the honeypot. It includes a Dockerfile for building the container image.

# terraform
This directory contains the Terraform code for creating the cloud infrastructure necessary for running the honeypot. It includes directories for creating an AWS VPC and an EKS-Fargate cluster.

# Deployment
To deploy the honeypot, follow these steps:

* Clone the repository to your local machine.
* Install Docker and Docker Compose.
* Navigate to the controllers directory and run docker build -t honeypot-controller . to build the container image.
* Navigate to the project root directory and run docker-compose up -d to start the controller and any required dependencies.
* Use the Terraform code in the terraform directory to create the necessary cloud infrastructure.
* Use the Kubernetes deployment files in the kubernetes directory to deploy the honeypot to a Kubernetes cluster.
* Once the honeypot is deployed, you can use the test-attack.py script in the pyattack directory to test the honeypot and generate attack data.


# Conclusion
This project provides a framework for automating the deployment of a distributed cloud-based honeypot
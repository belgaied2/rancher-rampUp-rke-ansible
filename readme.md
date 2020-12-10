# Automation scripts for the deployment of K8s cluster using RKE (Rancher Kubernetes Engine)
This repository contains automation scripts based on Terraform and Ansible that aim to deploy an RKE Cluster on AWS.

## Folder Structure
```
.
+-- terraform
|   +-- tpl
|       +-- cluster.yml.tmpl        # Template for cluster.yml
|   +-- main.tf                     # main Terraform configuration file 
+-- ansible
|   +-- rke.yaml
|   +-- hosts                       # will be created by Terraform    
|   +-- roles
|       +-- docker                  # contains playbook for installing Docker
|       +-- kernel_modules          # contains playbook for configuration kernel modules
|       +-- rke                     # contains playbook for running RKE 
````
## Pre-requisites
In order to run this configuration it is best to have the following tools on your current machine:
- Terraform: v0.13
- Ansible:   v2.10
- RKE:       v1.2.1
## How it works
The configuration works as follows:
- Terraform creates AWS EC2 instances, their number is configurable using the variable  `instance_count`.
- Terraform generates the `hosts` file (inventory) for Ansible, and the `cluster.yml` file for RKE
- Terraform then runs `ansible-playbook` command locally using the `local_exec` provisioner
- From there, Ansible takes over to apply the following playbooks on all instances present in the `hosts` file:
    - docker : will install docker-ce, docker-ce-cli and containerd on the instances
    - kernel_modules : will check presence of necessary kernel modules on the instances
    - rke : will run `rke up` locally to deploy RKE cluster on the instances.
## Variables

These are the variables that can be overriden for this configuration.

````
variable "region" { 
   type = string
   description = "AWS Region to be used for creating RKE instances"
   default = "eu-central-1"
}


variable "email" {
   type = string
   description = "Email to be used as a tag in the AWS instances"
   default =   "user@company.com"
}

variable "owner" {
   type = string
   description = "Person to be used as owner tag on the AWS instances"
   default = "user"
  
}

variable "keyname" {
   type = string
   description = "Keypair name in AWS" 

}

variable "instance_count" {
   type = number
   description = "Number of AWS instances for RKE to be provisioned"
   default = 3  # default for a Highly available cluster.
  
}

variable "ansible_inventory" {
   type = string
   description = "Relative Path to the Ansible inventory file"
   default =   "../ansible/hosts"
}


variable "ssh_username" { 
   type = string
   description = "Username to be used for SSH access to the AWS instances"
   default     = "ubuntu"
}

variable "ssh_private_key_path" {
   type = string
   description = "Path to the SSH private key to be used for RKE machines"
}

variable "security_groups" {
   type = list(string)
   description = "List of security group names to be used with the AWS instances"
   default = [ "SSH from the world","rancher-nodes" ]
}

variable "aws_instance_type" {
   type = string
   description = "Type of instance in AWS to be used for RKE instances"
   default     = "t2.xlarge"
}

variable "availability_zone" {
   type = string
   description = "Availability Zone in which the AWS instances with be placed"
   default     = "eu-central-1b"
}

variable "aws_ami_selector" {
   description = "String to select AMI to be used with RKE instances"
   default     = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
}

variable "aws_ami_owner_id" {
   description = "AMI Owner ID used to filter AMIs"
   default     = "099720109477"  # Default AMI Owner used : Canonical, for Ubuntu AMIs
}

variable "aws_disk_size" {
   type = number
   description = "Disk Size to be used for RKE instances in FB"
   default     = 25
}
````


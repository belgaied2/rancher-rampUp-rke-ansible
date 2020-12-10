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








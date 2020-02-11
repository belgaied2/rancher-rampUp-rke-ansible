provider "aws" {
   access_key = "${var.aws_key}"
   secret_key = "${var.aws_secret}"
   region = "${var.region}"
}

data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }
    
    owners = ["099720109477"]
}
resource "aws_instance" "rke_master" {
    ami_id = "S{data.aws_ami.ubuntu}"
    instance_type = "t2.xlarge"
    availability_zone = "eu-central-1b"
    key_name = "${var.keyname}"
    security_groups = [ "sg-06e947054061ee326" ]
    associate_public_ip_address = true


    tags = {
        Name = "RampUp-RKE01"
        Email = "${var.email}"
        Owner = "${var.owner}"
    }




}





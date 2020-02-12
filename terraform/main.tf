provider "aws" {
   access_key = "${var.aws_key}"
   secret_key = "${var.aws_secret}"
   region = "${var.region}"
}

provider "template" {
  
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
    count  = "${var.instance_count}"
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.xlarge"
    availability_zone = "eu-central-1b"
    key_name = "${var.keyname}"
    security_groups = [ "SSH from the world","rancher-nodes" ]
    associate_public_ip_address = true


    tags = {
        Name = "RampUp-RKE0${count.index+1}"
        Email = "${var.email}"
        Owner = "${var.owner}"
    }

    root_block_device {
        volume_type = "gp2"
        volume_size = 25
    }


}

resource "null_resource" "rke_master" {
    
    provisioner "local-exec" {
        command = "echo '[aws]' > ${var.ansible_inventory} && echo '${join("\n",aws_instance.rke_master.*.public_ip)}' >> ${var.ansible_inventory} && echo '\n[rke_source]\n${aws_instance.rke_master[0].public_ip}' >> ${var.ansible_inventory}  && echo '\n[aws:vars]\nansible_ssh_private_key_file=/Users/mhassine/Downloads/mbh.pem\nansible_ssh_user=ubuntu' >> ${var.ansible_inventory}"
    }

    provisioner "local-exec" {
        working_dir = "../ansible"
        command = "sleep 30 && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts rke.yaml"
    }

    depends_on = ["template_dir.cluster_yaml"]

}

resource  "template_dir" "cluster_yaml" {
    source_dir = "tpl"
    destination_dir = "../ansible/roles/rke/files"
    
    vars = {
        rke01_public_ip = aws_instance.rke_master[0].public_ip
        rke02_public_ip = aws_instance.rke_master[1].public_ip
        rke03_public_ip = aws_instance.rke_master[2].public_ip
        rke04_public_ip = aws_instance.rke_master[3].public_ip
        rke05_public_ip = aws_instance.rke_master[4].public_ip
        rke01_private_ip = aws_instance.rke_master[0].private_ip
        rke02_private_ip = aws_instance.rke_master[1].private_ip
        rke03_private_ip = aws_instance.rke_master[2].private_ip
        rke04_private_ip = aws_instance.rke_master[3].private_ip
        rke05_private_ip = aws_instance.rke_master[4].private_ip
    }

}









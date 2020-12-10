data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name = "name"
        values = [var.aws_ami_selector]
    }
    
    owners = [var.aws_ami_owner_id]
}
resource "aws_instance" "rke_master" {
    count  = var.instance_count
    ami = data.aws_ami.ubuntu.id
    instance_type = var.aws_instance_type
    availability_zone = var.availability_zone
    key_name = var.keyname
    security_groups = var.security_groups
    associate_public_ip_address = true


    tags = {
        Name = "RKE_0${count.index+1}"
        Email = var.email
        Owner = var.owner
    }

    root_block_device {
        volume_type = "gp2"
        volume_size = var.aws_disk_size
    }


}

resource  "local_file" "cluster_yaml" {
    content = templatefile("${path.module}/tpl/cluster.yml.tmpl", 
    {  
        nodes = aws_instance.rke_master, 
        ssh_private_key_path = var.ssh_private_key_path,
        ssh_username = var.ssh_username
        }
    )
    filename = "${path.module}/../ansible/roles/rke/files/cluster.yml"

}

resource  "local_file" "hosts_inventory" {
    content = templatefile("${path.module}/tpl/hosts.tmpl", 
    {  
        nodes = aws_instance.rke_master
        }
    )
    filename = "${path.module}/../ansible/hosts"

}

resource "null_resource" "rke_master" {

    provisioner "local-exec" {
        working_dir = "../ansible"
        command = "sleep 30 && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts rke.yaml"
    }

    depends_on = [local_file.cluster_yaml, local_file.hosts_inventory]

}







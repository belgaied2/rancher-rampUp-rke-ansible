# Terraform configurations  
This folder contains the terraform configuration to create aws instances and generate the `hosts` inventory file for ansible and the `cluster.yml` configuration file for RKE.
Both these files are a necessary pre-requisite to run the ansible playbooks in the ansible folder.
## File descriptions
This configuration is organized as follows:
- the `tpl` folder contains the templates that will be used to generate the above files
- the `main.tf` is the main configuration file for Terraform, it contains the AWS resource definitions.
- the `config.tf` file contains the S3 Backend configuration (*!!! this needs to be overriden in your environment !!!*)
- the `providers.tf` file contains the Terraform providers information (in this case, only AWS)
- the `variables.tf` file contains the variable definitions with their default values: notice that some variables do not have default values, that means it is necessary to add your own values. It is recommended to create your own `.tfvars` file to complement this configuration.

## How it works
In order to execute this configuration:
- Position yourself in this folder
- Modify the `config.tf` to use your own backend
- Add a `.tfvars` file or put your variable values as options in the `terraform` command.
- Run `terraform apply`  

# Terraform
Collection of terraform code ive created from various projects

The migration-project directory is an example setup for a multi evn project that i worked on. 



## Terraform Usefull Commands:
```
terraform init
terraform plan
terraform validate
terraform apply
terraform destroy
```

### terraform init
To initializes a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.

### terraform plan
creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure. By default, when Terraform creates a plan it:
- Reads the current state of any already-existing remote objects to make sure that the Terraform state is up-to-date.
- Compares the current configuration to the prior state and noting any differences.
- Proposes a set of change actions that should, if applied, make the remote objects match the configuration.
##### Syntax: `terraform plan [options]`

### terraform validate
To validate the configuration files in a directory, referring only to the configuration and not accessing any remote services such as remote state, provider APIs, etc.

### terraform apply
command executes the actions proposed in a Terraform plan.
##### Syntax: `terraform apply [options] [plan file]`

### terraform destroy
The command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.
##### Syntax: `terraform destroy [options]`

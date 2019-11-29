# Terraform & Azure
This repo contains some simple terraform scripts to deploy some modules.  
The modules in this repo right now are:  
- network
- vpn (this creates a VM that I want to use as a VPN host)

## Getting started   
To start with one of the scripts, you need to complete a few steps:  

### Install Terraform
[Check docs here](https://learn.hashicorp.com/terraform/getting-started/install.html)  
I use MacOS and installed it via Brew:  
```bash
$ brew update
$ brew install terraform
# Validate installation
$ terraform -version
``` 

### Log in to Azure
I do not like to use variables for my Azure CLI credentials, however, this means I will need to authenticate another way.  
To do this, I use the Azure CLI to login *before* running Terraform
```bash
# This will open a browser window through which you can login
$ az login
# To ensure you are using the correct subscription or to change
$ az account list # Shows available subscripts
$ az account set --subscription <subscription-id>
```

### Run Terraform  
To create a desired plan and/or apply the desired situation, you should follow these steps
Find which one you want to run, for this example I will plan and apply the Network state
```bash
# Go to the directory containing the desired state, in this case, I will run the dev network in West Europe so...
$ cd live/dev/we/network
# Initialize Terraform
$ terraform init
# Plan the state - this is NOT required, but highly recommended, as it will show you what it will do before doing anything
# I use the -var-file options to pass in an extra file containing variables, these are common variables required for all runs
$ terraform plan -out network.plan -var-file=../common.tfvars
# Apply the generated plan if it contains what I would want/expect
$ terraform apply network.plan
```

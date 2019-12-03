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

### Set environment
Unfortunately, I need the subscription ID for some of the full IDs - ex. vnet/subnet.
To do this, I made a simple export script that you can fill - and then source - to include all the required variables.
The example is found - unfilled - at the root of this project as `set-env.sh-sample`
```bash
# In the root dir of the project
$ cp set-env.sh-sample set-env.sh
# Fill the variables with your own credentials
$ source set-env.sh
```

### Ensure KeyVault exists with required data
I use an Azure Key Vault to store some sensitive data, like auth credentials.
However, I do not have this set to create (yet) - so you will have to make sure it exists before running Terraform.
The KeyVault required depends on the environment you are running in/on.
For me, the Key Vault looks like this:
`resource-group: rg-dev-we-vaults`
`name: vault-terraform`  
You should be able to follow the pattern `rg-ENV-LOCATION-vaults` and get it working.  
Fill the vault with these secrets:
`admin-username`
`admin-pub-key`

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

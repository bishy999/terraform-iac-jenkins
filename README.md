# terraform-iac-jenkins
Jenkins setup in multi region AWS using Terraforms. Working off a linux academy base tutorial.


## Status
[![Build Status](https://travis-ci.com/bishy999/terraform-iac-jenkins.svg?branch=main)](   )
![GitHub Repo size](https://img.shields.io/github/repo-size/bishy999/terraform-iac-jenkins)
[![GitHub Tag](https://img.shields.io/github/tag/bishy999/terraform-iac-jenkins.svg)](https://github.com/bishy999/terraform-iac-jenkins/latest)
[![GitHub Activity](https://img.shields.io/github/commit-activity/m/bishy999/terraform-iac-jenkins)](https://github.com/bishy999/terraform-iac-jenkins)
[![GitHub Contributors](https://img.shields.io/github/contributors/bishy999/terraform-iac-jenkins)](https://github.com/bishy999/terraform-iac-jenkins)


## Pre-Requisites
   * [Terraform](https://www.terraform.io/) - Install
   * [AWS access](https://console.aws.amazon.com/) - With admin priviliges and ensure your [AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) is working
   * AWS IAM permissions - iam.yaml
   * Allow Terraform to use your `AWS` credentials in `~/.aws/credentials`
   * [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html/) - Install
   * [Route 53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/registrar.html)  - Register a new domain



## Version Requirements
| Name | Version |
|------|---------|
| terraform | ~> 0.12.29 |
| aws | ~> v3.26.0 |


## How to create
### Example golang-hello-world-webapp-ec2
```terraform

git clone https://github.com/bishy999/terraform-iac-jenkins .
Update specific values to your setup in variables.tf
```


### Initialize a new or existing Terraform working directory by creating initial files, loading any remote state, downloading modules, etc
```terraform
terraform init
```

### Preview of what it’s  going to create
```terraform
terraform plan
```


### Create stack
```terraform
terraform apply 

or

terraform apply -auto-approve
```


### check app is working via browser/cli
 
```
https://{domain_name}
curl https://{{domain_name}}
Example: https://jenkins.devopscork.com
```

### Reads an output variable from a Terraform state file and prints the value
```terraform
terraform output 
```

### Delete stack
```terraform
terraform destroy
```
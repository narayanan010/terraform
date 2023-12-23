# EKS running config reference for Terraform module 'eks-onboading' on sandbox environment

This is an example all-in-one of how to use 'eks-onboarding' Terraform module that will create new k8s resources into a new EKS cluster. 

Following running-config folders structure are examples for reference purpose only within `sandbox` environment:

```
├── README.md
├── cluster
│   ├── backend.tf
│   ├── eks_cluster.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── terraform.tfvars
│   ├── terragrunt.hcl
│   ├── variables.tf
│   └── vpc.tf
└── sample
    ├── backend.tf
    ├── main.tf
    ├── outputs.tf
    ├── provider.tf
    ├── terraform.tfvars
    ├── terragrunt.hcl
    └── variables.tf
```


&nbsp;
### What this PoC is gonna to do?
* Create EKS cluster and network resources in `sandbox account`
* Create new k8s resources based on 'eks-onboarding' module

&nbsp;
### Understanding folder structure

In folder structure exist main folders `cluster`and `sample`. In `cluster` folder there are Terraform code for the EKS cluster and Networking. In `sample` folder there are Terraform code for each k8s resource created by this module.

- sample: Running config for each k8s resource created by this module
- cluster: Running config for the EKS cluster & Networking

&nbsp;

## How to run this PoC

In folder structure exist main folders `cluster`and `sample`. In `cluster` folder there are Terraform code for the EKS cluster and Networking. In `sample` folder there are Terraform code for each k8s resource created by this module.

In folder structure exist main folders:

`sample` code folder

&nbsp;

### 1. Deploy demo in sandbox account

There are one dependency deploying `sample`stack. Previous step is to deploy `cluster` stack in sandbox account.

* Deploy Order: `cluster` -> `sample`


To deploy all Terraform stack using Terragrunt and 'aws-vault' tool, run:
```
aws-vault exec default --no-session -- terragrunt run-all apply
```
Expected result:

```
INFO[0000] The stack at /Users/daoliva/repo/work/capterra/terraform/running_configs/eks/sandbox will be processed in the following order for command apply:
Group 1
- Module /Users/daoliva/repo/work/capterra/terraform/running_configs/eks/sandbox/cluster

Group 2
- Module /Users/daoliva/repo/work/capterra/terraform/running_configs/eks/sandbox/sample
 
Are you sure you want to run 'terragrunt apply' in each folder of the stack described above? (y/n) y
..
..
Apply complete! Resources: X added, 0 changed, 0 destroyed.
```
&nbsp;

### 2. Enjoy your Poc in sandbox account

You can now try by yourself create a new sample of code with some new namespaces and services.

### 3. Destroy Poc in sandbox account

Once you have been tested and happy with the PoC, you can destroy all resources deployed in sandbox account.

There are one dependency destroying resources. Previous step is to destroy `sample` stack in sandbox account and then destroy `cluster` stack.

* Destroy Order: `sample` -> `cluster`


To destroy all Terraform stack using Terragrunt and 'aws-vault' tool, run:
```
aws-vault exec default --no-session -- terragrunt run-all destroy
```
Expected result:

```
INFO[0000] The stack at /Users/daoliva/repo/work/capterra/terraform/running_configs/eks/sandbox will be processed in the following order for command destroy:
Group 1
- Module /Users/daoliva/repo/work/capterra/terraform/running_configs/eks/sandbox/sample

Group 2
- Module /Users/daoliva/repo/work/capterra/terraform/running_configs/eks/sandbox/cluster
 
WARNING: Are you sure you want to run `terragrunt destroy` in each folder of the stack described above? There is no undo! (y/n) y
..
..
Destroy complete! Resources: X destroyed.
```

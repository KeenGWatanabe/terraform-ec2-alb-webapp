#terraform clean up
Delete the .terraform directory:

bash
Copy
rm -rf .terraform
Delete the terraform.tfstate and terraform.tfstate.backup files (if they exist):

bash
Copy
rm -f terraform.tfstate terraform.tfstate.backup
Reinitialize Terraform:

bash
Copy
terraform init
Run terraform plan to verify the changes.
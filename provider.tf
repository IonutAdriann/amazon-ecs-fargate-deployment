# The provider needs to be specified in the provider.tf file. The provider is the cloud provider that we are going to use to deploy our infrastructure. 
# In this case, we are using AWS. The provider block specifies the access key, secret key, and region that we are going to use to deploy our infrastructure.

provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region     = var.aws_region

}
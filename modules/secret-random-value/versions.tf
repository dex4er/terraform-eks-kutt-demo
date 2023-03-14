## The strict versions of Terraform and providers.
## Run `terraform init -upgrade` after changes.

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    ## https://github.com/hashicorp/terraform-provider-aws/blob/master/CHANGELOG.md
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 5.0.0"
    }
  }
}

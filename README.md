# FatZebra ECR terraform module

This module supports the creation of an AWS Elastic Container Registry (ECR) repository with:

* a well defined and consistent naming standard
* a consistent lifecycle policy
* a default set of permissions for permissions on the repository
* ensure image scanning is enabled on repos

## Usage

* Here is an example of the usage for a service that runs within the default set of FatZebra accounts:

    ```
    module "repo" {
        source  = "app.terraform.io/fatzebra/fz-ecr/aws"
        version = "x.x.x"

        context = module.context
    }
    ```
  * This setup has a dependy on the [terraform-null-context module](https://github.com/fatzebra/terraform-null-context) which is used to ensure consistent naming and tagging standards

* Here is an example of the usage of this module for a service that runs in a different account (`integrations` account):

    ```
    module "repo" {
        source  = "app.terraform.io/fatzebra/fz-ecr/aws"
        version = "1.1.8"

        context = module.context

        read_aws_principals = [
            "arn:aws:iam::748746525051:root", # FZ Test
            "arn:aws:iam::340752817472:root", # Int Staging
            "arn:aws:iam::881490128486:root", # Int Sbox
            "arn:aws:iam::872515254883:root", # Int Prod
        ]
    }
    ```
  * This setup has explicitly defined the read principals to set the AWS account from which the container might get pulled
    * this _includes_ `FZ Test` to support any usages of this container in a test within buildkite - see TODO below




## TODO

* for now, anything that is still using [buildkite](https://buildkite.com/fat-zebra) to build the container requires the `FZ Test` account to have write permissions - once we finally migrate off of buildkite, we can remove this
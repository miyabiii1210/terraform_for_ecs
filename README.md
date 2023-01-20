## ecs-task-terraform
---
```
$ terraform version
Terraform v1.2.0
```

<br>

. /config.tfvars
```
# ---------------------------
# Configure the AWS Provider Variable
# ---------------------------
# [ profile ]
account_id = "xxxxxxxxxx"
access_key = "xxxxxxxxxx"
secret_key = "xxxxxxxxxx"
region     = "xxxxxxxxxx"
zone       = "xxxxxxxxxx"

# [ General ]
project     = "xxxxxxxxxx"
environment = "xxxxxxxxxx"
```

```
terraform init
```
```
terraform plan --var-file=./config.tfvars
```
```
terraform apply --var-file=./config.tfvars
```
```
terraform destroy --var-file=./config.tfvars
```

<br>

### *.tfstate to be managed in S3
---

<br>

./backend/production.tfbackend
```
# ---------------------------
# Terraform Backend Environment
# ---------------------------
bucket  = "xxxxxxxxxx"
key     = "xxxxxxxxxx"
region  = "xxxxxxxxxx"
profile = "xxxxxxxxxx"
```
<br>

./main.tf
```
terraform {
    required_version = ">=0.13" # Specify version 0.13 or higher.
    required_providers {
        aws = {
        source  = "hashicorp/aws" # Specify the module name.
        version = "~>3.0"         # 3.0 or higher (ignore minor versions).
        }
    }

    backend "s3" {
    }
}
```
```
terraform init -reconfigure -backend-config=./backend/production.tfbackend
```

<br>

### ecs container env
---
./task-definitions/sample.json
```
[
    {
        "name": "[container-name]",
        "image": "[container-image-uri]",
        "cpu": 0,
        "memoryReservation": [],
        "portMappings": [],
        "essential": true,
        "environment": [
            {
                "name": "[container-env-name]",
                "value": "[container-env-value]"
            }
        ],
        "mountPoints": [],
        "volumesFrom": [],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "[cloudwatch-log-path]",
                "awslogs-region": "[cloudwatch-aws-region]",
                "awslogs-stream-prefix": "ecs"
            }
        }
    }
]
```
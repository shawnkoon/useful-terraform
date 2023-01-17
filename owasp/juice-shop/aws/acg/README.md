# Juice-shop AWS ACG

Deploy OWASP Juice-Shop on AWS within AcloudGuru Sandbox.

## Components

- Security Group
  - Allow port 80 from your IP address.
- EC2
  - With owasp juice-shop installed via user_data.

## How to Use

1. Set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY envs.

```bash
export AWS_ACCESS_KEY_ID=____ && export AWS_SECRET_ACCESS_KEY=_____
```

2. Initialize Terraform

```bash
terraform init
```

3. See what infrastructure Terraform will deploy

```bash
terraform plan
```

4. Apply Terraform

```bash
terraform apply -auto-approve
```

5. Once deployed, access the url `http://<ip_address>`

```bash
# Following should appear in output.
ec2_global_ips = [
    '<ip_address>',
]
```

6. When done, delete

```bash
terraform destroy
```

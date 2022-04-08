# Node.js, Express & MySQL: Simple Add, Edit, Delete, View (CRUD)

A CRUD application hosted in AWS EC2 provisioned via Terraform

## CI/CD Pipeline
## Architecture
![symbiosis_cicd](./diagram/symbiosis-cicd.drawio.png?raw=true)

### Current

![symbiosis_architecture](./diagram/symbiosis_infra_current.drawio.png?raw=true)

### Ideal (WIP)

![symbiosis_architecture](./diagram/symbiosis_infra.drawio.png?raw=true)

## API

Endpoint:
Description: To list all users in the database
Headers: Base64 encoded string with format <user:pass>
```
{
    Authorization: Basic YWhhbWlsdG9uQGFwaWdlZS5jb206bXlwYXNzdzByZAo
}
```

## Monitoring
[EC2 Cloudwatch Agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/QuickStartEC2Instance.html)
Useful Metric: 
1. CPU Utilization
2. Memory
3. Diskspace
# A CRUD Application hosted in AWS EC2 with a simple CI/CD Deployment Pipeline

## Architecture

### CI/CD Pipeline

![symbiosis_cicd](./diagram/symbiosis-cicd.drawio.png?raw=true)

### Infrastructure (Current)

![symbiosis_architecture](./diagram/symbiosis_infra_current.drawio.png?raw=true)

### Infrastructure (Ideal)

![symbiosis_architecture](./diagram/symbiosis_infra.drawio.png?raw=true)

## API

| Endpoints  | Authentication | Description              |
| ---------- | -------------- | ------------------------ |
| /api       | Basic          | Healthcheck              |
| /api/users | Basic          | List all available users |

> All API calls require Basic Authentication and can be set by passing in the Authorization headers

```bash
APP_API_STATUS=$(curl --get --silent --header "Authorization: Basic dGVzdDp0ZXN0MTIz" http://127.0.0.1:3000/api | jq .status)
```

## Monitoring

### Metrics

1. Mean Time To Recovery
2. Lead Time
3. Deployment Frequency

### Visualization Tools

1. Cloudwatch
2. Kubernetes Dashboard
3. Prometheus

### Statistics

1. CPU Utilization
2. Memory
3. Diskspace
4. Service Uptime
5. API Requests Errors

### Alarms & Alerting

1. Email: Outlook, Gmail
2. Messaging: Slack, Telegram

### References

1. https://aws.amazon.com/products/management-and-governance/use-cases/monitoring-and-observability
2. https://devops.com/top-5-best-practices-devops-monitoring/
3. https://www.atlassian.com/devops/devops-tools/devops-monitoring
4. https://www.atlassian.com/devops/frameworks/devops-metrics
5. https://stackify.com/15-metrics-for-devops-success/#post-14669-_2ljwt1mgqvyy

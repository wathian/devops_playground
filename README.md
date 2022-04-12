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

## Monitoring (Theoretical)

We have to identify the metrics that we want to focus on. In the context of our implementation, we chose the following under [Metrics](#metrics).

With those metrics in mind, we can determine what and how to measure, quantifying them into useful [Statistics](#statistics).

These can then be [Analysed and Visualized](#visualization-and-analytical-tools), giving us an overview of the system's health. We can also set [Alarms and Alerts](#alarms--alerting) to inform us if a certain threshold has been crossed.

### Metrics

1. Lead Time: Measures the time from implementation to testing to release/delivery
2. Mean Time To Recovery: Measures the ability to identify fault and resolve them
3. Deployment Frequency: Measures the amount of deployment (i.e. routine/bugfix/hotfix)

### Statistics

1. CPU Utilization: Exceeding >80% Usage
2. Memory: Exceeding >80% Usage
3. Storage/Diskspace: Exceeding >80% Usage
4. Service Uptime: Ensure <1% Downtime
5. API Requests Errors: Receive <10% Failure

### Analytical and Visualization Tools

1. [AWS Cloudwatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/QuickStartEC2Instance.html)
2. [AWS X-Ray](https://docs.aws.amazon.com/xray/latest/devguide/xray-sdk-nodejs-configuration.html)
3. [Prometheus](https://prometheus.io/docs/prometheus/latest/getting_started/)
4. [OpenTelemetry](https://opentelemetry.io/docs/instrumentation/js/getting-started/nodejs/)

### Alarms and Alerting

1. Email: Outlook, Gmail
2. Notification Bot: Slack, Telegram

### References

1. https://aws.amazon.com/products/management-and-governance/use-cases/monitoring-and-observability
2. https://devops.com/top-5-best-practices-devops-monitoring/
3. https://www.atlassian.com/devops/devops-tools/devops-monitoring
4. https://www.atlassian.com/devops/frameworks/devops-metrics
5. https://stackify.com/15-metrics-for-devops-success/#post-14669-_2ljwt1mgqvyy
6. https://www.digitalocean.com/community/tutorials/an-introduction-to-metrics-monitoring-and-alerting
7. https://cloud.google.com/architecture/devops/devops-measurement-monitoring-and-observability
8. https://devops.com/metrics-logs-and-traces-the-golden-triangle-of-observability-in-monitoring/
9. https://jenkins-x.io/blog/2019/07/29/jenkins-x-observability/

# WordPress on Kubernetes with Monitoring

This project deploys a production-grade WordPress application on Kubernetes with comprehensive monitoring using Prometheus and Grafana.

## Architecture

- **WordPress**: Custom PHP-FPM application
- **MySQL**: Custom MySQL database with optimized configuration
- **Nginx**: OpenResty with Lua scripting for advanced features
- **Prometheus**: Metrics collection and alerting
- **Grafana**: Visualization and dashboards

## Prerequisites

- Docker
- kubectl
- Minikube
- Helm

## Quick Start

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Ayanstringer2002/Infra-Intern-Syfe-Assignment.git
   cd wordpress-kubernetes
2. **Run automated deployment**:
   ```bash
   .\deploy.ps1
3. **Access your applications**:
   ```bash
   minikube service wordpress-nginx --url
   minikube service monitoring-grafana --url

## WordPress Metrics
- Page load time
- Requests per second
- Database query time
- PHP-FPM queue length
- Disk utilization

## Nginx Metrics
- Total request count
- Total 5xx error count
- Active connections
- Requests/sec
- Upstream response latency
- OpenResty Lua custom metrics

## MySQL Metrics
- QPS (Queries per second)
- Slow query count
- Buffer pool size
- Disk IOPS
- Replication lag (if configured)

## Scale Nginx
  ```bash
  kubectl scale deploy my-release-nginx --replicas=3
  ```

## Scale Wordpress
   ```bash
   kubectl scale deploy my-release-wordpress --replicas=3
   ```
## Project Structure
```
wordpress-kubernetes/
│
├── docker/
│   ├── wordpress/      # Custom PHP-FPM WordPress build
│   ├── nginx/          # OpenResty with Lua build
│   └── mysql/          # Custom MySQL image
│
├── helm/
│   └── wordpress-stack/
│       ├── charts/     # Subcharts (Prometheus, Grafana)
│       ├── templates/  # Kubernetes manifests
│       ├── values.yaml
│       └── Chart.yaml
│
├── monitoring/
│   ├── dashboards/     # Grafana dashboards JSON
│   └── alerts/         # Prometheus alert rules
│
└── README.md
```



   
    
  
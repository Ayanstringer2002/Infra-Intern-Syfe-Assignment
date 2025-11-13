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
   git clone <repository-url>
   cd wordpress-kubernetes
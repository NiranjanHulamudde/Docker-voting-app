# Production-Grade Container Monitoring & Observability Pipeline

An end-to-end cloud infrastructure monitoring framework demonstrating automated telemetry collection, time-series aggregation, and operational analytics for a containerized multi-tier web application stack.
This repository houses the declarative orchestration configuration to launch an active multi-tier web architecture alongside a real-time observability pipeline, leveraging kernel-level container statistics to ensure absolute visibility into system performance.

# 🏗️ System Architecture & Data Flow

The layout utilizes a fully isolated Docker bridge network. Services isolate public-facing routing tables while remaining accessible to the telemetry engine through internal DNS service aliases.

<img width="568" height="312" alt="image" src="https://github.com/user-attachments/assets/62a86e24-a960-44ff-a3a6-7e877f0396c1" />

## Infrastructure Lifecycle Components
• Application Services (voting-frontend & voting-backend): The functional business application core under observation. The frontend layer captures inbound traffic and pipes asynchronous computational data to the isolated API backend tier.
• cAdvisor (Container Advisor): A native daemon that mounts host core directories (/sys, /var/lib/docker) to hook directly into Linux namespaces and kernel cgroups. It dynamically extracts memory thresholds, continuous CPU processing times, network throughput, and hardware I/O statistics across all active containers.
• Prometheus Engine: An industry-standard time-series database running automated HTTP retrieval loops ("scrape configs") to pull metrics at high-resolution intervals from target nodes.
• Grafana Analytics Suite: The visualization abstraction tier. It handles authentication, structures dynamic query parameters, parses PromQL syntax, and formats data frames into analytical tracking grids.
🛠️ Infrastructure Declarative Source Files
To ensure strict compliance with Infrastructure as Code (IaC) design rules, the environment is fully declared within version-controlled structural definition files.

## 1. Unified Multi-Service Orchestrator (docker-compose.yml)

Note: Network boundaries are strictly structured to circumvent browser security constraints (e.g., modern browser restrictions on generic 5000/6000 ports) and ensure host-to-container routing parity.
yaml
version: '3.8'

services:
  frontend:
    build: ./frontend
    container_name: voting-frontend
    ports:
      - "5000:80"          # Maps safe external host port 5000 to internal web server port 80
    restart: unless-stopped
    networks:
      - monitoring-network

  backend:
    build: ./backend
    container_name: voting-backend
    ports:
      - "5001:5001"        # Maps host port 5001 to application runtime environment
    restart: unless-stopped
    networks:
      - monitoring-network

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
    restart: unless-stopped
    networks:
      - monitoring-network

  ### grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "6002:3000"        # Relocates Grafana to host port 6002 to bypass localized conflicts
    volumes:
      - grafana-data:/var/lib/grafana
    restart: unless-stopped
    networks:
      - monitoring-network

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:v0.49.1
    container_name: cadvisor
    ports:
      - "8001:8080"        # Exposes cAdvisor Web dashboard externally on port 8001
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /dev/disk/:/dev/disk:ro
    restart: unless-stopped
    networks:
      - monitoring-network

volumes:
  prometheus-data:
  grafana-data:

networks:
  monitoring-network:
    driver: bridge


## 2. Time-Series Scraping Directives (prometheus.yml)
Configured to target internal container service network namespaces directly, entirely isolated from external host interface variations.
yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']    # Communicates over the bridge network directly to container port 8080

  - job_name: 'voting-backend'
    static_configs:
      - targets: ['backend:5001']


## 📊 Telemetry Metrics Breakdown & PromQL Architectures
The custom-built Grafana operational control board contains a structured quad-grid layout utilizing specific PromQL (Prometheus Query Language) calculations designed to ensure platform stability under load.
1. Compute Infrastructure Allocation (CPU Core Performance)
Measures the per-second rate of processing acceleration slices used by individual container groups across a 5-minute aggregation window.
• Operational Value: Isolates runtime thread-locking bugs or performance spikes across microservice containers.

2. Real-Time Memory Footprint Analytics (RAM Consumption)
Extracts absolute memory byte measurements currently assigned to container tasks.
• Operational Value: Crucial for detecting memory leaks, assessing daemon overheads, and tuning Out-Of-Memory (OOM) kill parameters.
• Dashboard Formatting: Bound to Grafana's native layout engine using Data / Bytes (Metric) to enable automated vertical scaling (MB/GB).

3. Network Sockets Data Throughput (Network Stats)
Tracks input/output data transfer rates across physical container socket channels to calculate global bandwidth footprints.
• Operational Value: Identifies unexpected network traffic loops, external DDoS bottlenecks, and communication latency profiles.

4. Container Stability & System Longevity Tracker (Uptime Tracker)
Calculates exact time durations elapsed since the daemon container dropped a live structural event trace onto the node kernel.
• Operational Value: Instantly flags unstable, crashing microservices stuck in hidden container restart loops.
• Dashboard Formatting: Bound to the Time / Duration (hh:mm:ss) unit filter to render clear, human-readable uptimes.

### 🚀 Deployment Instructions
System Requirements
• Linux Environment (or VirtualBox running an actively bridged Ubuntu server instance).
• Docker Engine v20.10+ installed.
• Docker Compose V2 plugin active.
Execution Blueprint
To verify clean environment parsing, clear old networking states, build local application layers, and instantiate the stack in detached daemon mode, execute:
bash
# Terminate old container components and purge stale network paths
docker compose down

# Force an isolated cache-free image build and spin up the multi-tier topology
docker compose up -d --build

Verify Container Cluster Runtime
Execute the standard socket monitoring parameters to ensure network sockets are properly bound on your host interface:
bash
docker ps

Network Access Target Routing Matrix
Once deployment confirms successful container allocation, interfaces are accessible at these exact host parameters:
Component / Layer	Access URL Interface	Operational Target
Voting App UI	http://localhost:5000	End-User Interaction Web Portal
cAdvisor Stats UI	http://localhost:8001	Raw Cluster Node Metrics Visualizer
Prometheus DB Core	http://localhost:9090/targets	Data Collection Status Checks (All must read UP)
Grafana Dashboards	http://localhost:6002	Production Operational Analytics Control Center

Note - I have disabled the terraform part in the Jenkinsfile to avoid unnecessary infra build ups.

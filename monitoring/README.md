# Monitoring Stack - Prometheus & Grafana

## 🚀 Quick Start

```bash
# Start monitoring stack
docker compose up -d

# Stop monitoring stack
docker compose down

# View logs
docker logs prometheus
docker logs grafana

# Restart containers
docker compose restart
```

## 🔗 Access Points

- **Prometheus:** http://localhost:9090
- **Grafana:** http://localhost:3001 (admin/admin)
- **Spring Boot Metrics:** http://localhost:8080/actuator/prometheus

## 📊 What's Included

- **Prometheus**: Time-series metrics database
- **Grafana**: Metrics visualization platform
- **Persistent Volumes**: Data survives container restarts

## ⚙️ Configuration

### prometheus.yml

Scrapes metrics from:
- Prometheus itself (self-monitoring)
- Spring Boot app at `host.docker.internal:8080/actuator/prometheus`

### docker-compose.yml

Services:
- `prometheus`: Port 9090, scrapes metrics every 15s
- `grafana`: Port 3001, visualizes metrics

## 📈 Monitoring Metrics

- **JVM**: Heap, non-heap, GC stats
- **CPU**: Process and system usage
- **HTTP**: Request count, duration, status codes
- **Threads**: Active, peak, daemon threads
- **System**: Disk, memory, file descriptors

## 🎨 Grafana Dashboards

**Import these dashboard IDs:**
- **11378**: Spring Boot 2.1 System Monitor (recommended)
- **4701**: JVM (Micrometer)
- **12464**: Spring Boot Statistics

**How to import:**
1. Go to Grafana → Dashboards → Import
2. Enter dashboard ID
3. Select "Prometheus" as data source
4. Click "Import"

## 🔧 Troubleshooting

### Spring Boot target is DOWN

1. Ensure Spring Boot app is running: `curl http://localhost:8080/actuator/prometheus`
2. For Linux, change `host.docker.internal` to your machine's IP in `prometheus.yml`
3. Restart Prometheus: `docker compose restart prometheus`

### Grafana can't connect to Prometheus

1. Verify URL is `http://prometheus:9090` (use container name, not localhost)
2. Check both containers are on the same network: `docker network ls`
3. Test from Grafana container: `docker exec grafana wget -O- http://prometheus:9090`

### No metrics in dashboard

1. Check time range is recent (Last 15 minutes)
2. Generate traffic to your app
3. Verify Prometheus is scraping: http://localhost:9090/targets

## 📁 Data Persistence

Volumes:
- `prometheus-data`: Stores Prometheus time-series database
- `grafana-data`: Stores Grafana dashboards and settings

**To reset all data:**
```bash
docker compose down -v
docker compose up -d
```

## 🎯 Production Tips

1. **Increase retention:** Add to Prometheus command in docker-compose.yml:
   ```yaml
   command:
     - '--storage.tsdb.retention.time=90d'
   ```

2. **Add authentication:** Configure Grafana OAuth or LDAP

3. **Set up alerts:** Create alert rules in Prometheus

4. **Backup data:** Regularly backup volumes
   ```bash
   docker run --rm -v prometheus-data:/data -v $(pwd):/backup alpine tar czf /backup/prometheus-backup.tar.gz /data
   ```

## 📚 Documentation

See `MONITORING_GUIDE.md` in the project root for complete setup instructions.

---

**🎉 Monitoring stack ready! Access Grafana at http://localhost:3001**

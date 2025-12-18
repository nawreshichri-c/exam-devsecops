# Prometheus & Grafana Monitoring - Complete Guide

## 🎯 Overview

This guide shows you how to add **production-grade monitoring** to your Spring Boot application using:
- **Spring Boot Actuator**: Exposes application metrics
- **Prometheus**: Collects and stores time-series metrics
- **Grafana**: Visualizes metrics in beautiful dashboards

---

## 📊 What You'll Monitor

### Application Metrics
- **JVM Memory**: Heap usage, garbage collection
- **CPU Usage**: Application CPU consumption
- **Threads**: Active threads, thread states
- **HTTP Requests**: Request count, duration, status codes
- **Database**: Connection pool (if using DB)

### System Metrics
- **Process**: CPU, memory, file descriptors
- **Disk**: I/O operations  
- **Network**: Connections

---

## ✅ Part 1: Enable Metrics in Spring Boot

### Step 1: Dependencies Added

Your `pom.xml` now includes:

```xml
<!-- Spring Boot Actuator -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>

<!-- Prometheus Metrics -->
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>
```

**What these do:**
- **Actuator**: Exposes operational endpoints (health, metrics, info)
- **Micrometer Prometheus**: Formats metrics for Prometheus

### Step 2: Actuator Configuration

Your `application.properties` now configures:

```properties
# Expose all actuator endpoints
management.endpoints.web.exposure.include=*

# Enable Prometheus endpoint
management.endpoint.prometheus.enabled=true

# Show health check details
management.endpoint.health.show-details=always
```

### Step 3: Test Actuator Endpoints

**Build and run the application:**

```bash
# Build with Maven
mvn clean package

# Run the application
java -jar target/democyber-0.0.1-SNAPSHOT.jar

# OR use Maven
mvn spring-boot:run
```

**Test these endpoints:**

1. **Actuator Root**: http://localhost:8080/actuator
   ```json
   {
     "_links": {
       "self": {"href": "http://localhost:8080/actuator"},
       "health": {"href": "http://localhost:8080/actuator/health"},
       "prometheus": {"href": "http://localhost:8080/actuator/prometheus"}
     }
   }
   ```

2. **Health Check**: http://localhost:8080/actuator/health
   ```json
   {
     "status": "UP",
     "components": {
       "diskSpace": {"status": "UP"},
       "ping": {"status": "UP"}
     }
   }
   ```

3. **Prometheus Metrics**: http://localhost:8080/actuator/prometheus
   ```
   # HELP jvm_memory_used_bytes The amount of used memory
   # TYPE jvm_memory_used_bytes gauge
   jvm_memory_used_bytes{area="heap",id="G1 Old Gen",} 1.2345678E7
   jvm_memory_used_bytes{area="nonheap",id="Metaspace",} 3.456789E7
   
   # HELP http_server_requests_seconds  
   # TYPE http_server_requests_seconds summary
   http_server_requests_seconds_count{method="GET",uri="/actuator/health",} 5.0
   ```

---

## 🐳 Part 2: Deploy Prometheus & Grafana

### Project Structure

```
monitoring/
├── docker-compose.yml    # Container orchestration
└── prometheus.yml        # Prometheus configuration
```

### Step 1: Review Configuration Files

**`docker-compose.yml`** creates:
- **Prometheus** on port 9090
- **Grafana** on port 3001
- Shared `monitoring` network
- Persistent volumes for data

**`prometheus.yml`** configures:
- Scrape interval: 15 seconds (default), 5 seconds (Spring Boot)
- Job name: `spring-boot-app`
- Target: `host.docker.internal:8080/actuator/prometheus`

### Step 2: Start Monitoring Stack

```bash
# Navigate to monitoring folder
cd monitoring

# Start containers
docker compose up -d

# Verify containers are running
docker ps
```

**Expected output:**
```
CONTAINER ID   IMAGE                 PORTS                    NAMES
abc123...      prom/prometheus       0.0.0.0:9090->9090/tcp   prometheus
def456...      grafana/grafana       0.0.0.0:3001->3000/tcp   grafana
```

### Step 3: Check Logs

```bash
# Prometheus logs
docker logs prometheus

# Grafana logs
docker logs grafana
```

---

## 🔍 Part 3: Test Prometheus

### Step 1: Access Prometheus UI

**Open:** http://localhost:9090

### Step 2: Verify Targets

1. Go to **Status** → **Targets**
2. You should see:
   - `prometheus` (State: UP)
   - `spring-boot-app` (State: UP)

**If spring-boot-app is DOWN:**
- Ensure your Spring Boot app is running
- Check `host.docker.internal` works (Windows/Mac)
- For Linux, use your machine's IP instead

### Step 3: Query Metrics

**Go to:** http://localhost:9090/query

**Try these queries:**

1. **JVM Memory Usage:**
   ```promql
   jvm_memory_used_bytes{application="democyber"}
   ```

2. **HTTP Request Count:**
   ```promql
   http_server_requests_seconds_count{application="democyber"}
   ```

3. **CPU Usage:**
   ```promql
   process_cpu_usage{application="democyber"}
   ```

4. **Heap Memory Used:**
   ```promql
   jvm_memory_used_bytes{area="heap",application="democyber"}
   ```

**Click "Execute" and switch to "Graph" tab to see time-series data!**

---

## 📈 Part 4: Configure Grafana

### Step 1: Access Grafana

**Open:** http://localhost:3001

**Login:**
- Username: `admin`
- Password: `admin`

(You'll be prompted to change password - you can skip or set a new one)

### Step 2: Add Prometheus Data Source

1. **Go to:** Connections → Data Sources
   - Or: Hamburger menu → Connections → Data sources

2. **Click:** "Add new data source"

3. **Select:** Prometheus

4. **Configure:**
   - **Name:** Prometheus
   - **URL:** `http://prometheus:9090`
   - **Access:** Server (default)

5. **Scroll down** and click **"Save & Test"**

**Expected:** ✅ "Successfully queried the Prometheus API"

### Step 3: Import Spring Boot Dashboard

1. **Go to:** Dashboards → New → Import
   - Or: + icon → Import

2. **Enter Dashboard ID:** `11378`
   - This is the official "Spring Boot 2.1 System Monitor" dashboard

3. **Click:** "Load"

4. **Configure:**
   - **Name:** Spring Boot Metrics (or keep default)
   - **Prometheus:** Select "Prometheus" data source

5. **Click:** "Import"

**🎉 You now have a fully functional Spring Boot monitoring dashboard!**

---

## 📊 Understanding the Dashboard

### Panels You'll See

1. **JVM Memory**
   - Heap vs non-heap memory usage
   - Memory pools (Eden, Survivor, Old Gen)
   - Garbage collection metrics

2. **CPU Usage**
   - Process CPU percentage
   - System CPU load
   - CPU cores available

3. **HTTP Metrics**
   - Requests per second
   - Request duration (p50, p95, p99)
   - Status codes (200, 404, 500)

4. **Threads**
   - Active threads
   - Thread states (runnable, waiting, blocked)

5. **Database Connection Pool** (if applicable)
   - Active connections
   - Idle connections
   - Connection wait time

### Example Metrics

**JVM Heap Memory:**
```
Used: 128 MB / 512 MB (25%)
Max: 2048 MB
GC Count: 42
GC Time: 1.2s
```

**HTTP Requests:**
```
Total: 1,245 requests
Success (200): 1,200
Not Found (404): 40
Errors (500): 5
Avg Duration: 45ms
```

---

## 🧪 Testing the Monitoring

### Step 1: Generate Traffic

**Open multiple terminals and run:**

```bash
# Terminal 1: Continuous health checks
while ($true) { curl http://localhost:8080/actuator/health; sleep 1 }

# Terminal 2: Hit main endpoint
while ($true) { curl http://localhost:8080/; sleep 2 }

# Terminal 3: Generate 404 errors
while ($true) { curl http://localhost:8080/nonexistent; sleep 3 }
```

### Step 2: Watch Metrics Update

**In Grafana:**
- Refresh rate: Set to "5s" (top right)
- Time range: Last 15 minutes

**You should see:**
- ✅ HTTP request count increasing
- ✅ CPU usage spiking
- ✅ Thread count fluctuating
- ✅ GC activity

---

## 🎨 Additional Dashboards

### Other Recommended Dashboard IDs

1. **JVM (Micrometer)**: `4701`
   - Detailed JVM metrics
   - Class loader stats
   - Thread details

2. **Spring Boot Statistics**: `12464`
   - HTTP session stats
   - Tomcat metrics
   - Logback metrics

3. **Prometheus 2.0 Stats**: `3662`
   - Prometheus self-monitoring
   - Query performance
   - Storage metrics

**To import:** Dashboards → Import → Enter ID → Load → Import

---

## 🔧 Customization

### Create Custom Dashboards

1. **Click:** + → Create Dashboard
2. **Add Panel:** Click "Add visualization"
3. **Select:** Prometheus data source
4. **Enter PromQL query:**
   ```promql
   rate(http_server_requests_seconds_count[1m])
   ```
5. **Configure:**
   - Title: "HTTP Requests per Minute"
   - Panel type: Graph / Time series
   - Unit: requests/sec
6. **Save dashboard**

### Custom Metrics Examples

**Request Rate by URI:**
```promql
sum(rate(http_server_requests_seconds_count[5m])) by (uri)
```

**Error Rate:**
```promql
sum(rate(http_server_requests_seconds_count{status="500"}[1m]))
```

**Memory Usage Percentage:**
```promql
100 * (jvm_memory_used_bytes{area="heap"} / jvm_memory_max_bytes{area="heap"})
```

---

## 🎯 Alerting (Optional)

### Configure Prometheus Alerts

**Create:** `monitoring/alerts.yml`

```yaml
groups:
  - name: application_alerts
    interval: 30s
    rules:
      - alert: HighMemoryUsage
        expr: jvm_memory_used_bytes{area="heap"} / jvm_memory_max_bytes{area="heap"} > 0.9
        for: 1m
        labels:
          severity: warning
        annotations:
          summary: "High heap memory usage"
          description: "Heap memory is {{ $value | humanizePercentage }}"

      - alert: HighErrorRate
        expr: rate(http_server_requests_seconds_count{status="500"}[1m]) > 0.1
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "High HTTP error rate"
          description: "Error rate is {{ $value }} req/sec"
```

---

## 🆘 Troubleshooting

### Prometheus Can't Scrape Spring Boot

**Symptom:** Target shows as DOWN

**Solutions:**
1. **Check app is running:** `curl http://localhost:8080/actuator/prometheus`
2. **For Windows/Mac:** `host.docker.internal` should work
3. **For Linux:** Use your machine's IP:
   ```yaml
   - targets: ['192.168.1.100:8080']
   ```
4. **Firewall:** Ensure port 8080 is accessible

### Grafana Can't Connect to Prometheus

**Symptom:** "Bad Gateway" error

**Solutions:**
1. **Check URL:** Must be `http://prometheus:9090` (container name)
2. **Network:** Both containers must be on `monitoring` network
3. **Restart:** `docker compose restart`

### No Metrics in Dashboard

**Symptom:** Empty graphs

**Solutions:**
1. **Check time range:** Set to "Last 15 minutes"
2. **Generate traffic:** Access the app endpoints
3. **Verify data source:** Test Prometheus connection
4. **Check queries:** Go to panel → Edit → Query

### "host.docker.internal" Not Found (Linux)

**Solution:** Use your machine's IP address:

```bash
# Find your IP
ip addr show

# Update prometheus.yml
- targets: ['192.168.1.XXX:8080']
```

---

## 📊 Performance Metrics

### What to Monitor in Production

**Critical Metrics:**
1. **Response Time:** p95 < 200ms
2. **Error Rate:** < 1%
3. **CPU Usage:** < 70%
4. **Memory Usage:** < 80%
5. **GC Pause Time:** < 100ms

**Set up alerts for:**
- High memory usage (> 90%)
- High error rate (> 5%)
- Slow response times (p95 > 1s)
- High CPU usage (> 85%)

---

## 🎓 Best Practices

### 1. **Label Everything**
```properties
management.metrics.tags.application=democyber
management.metrics.tags.environment=production
management.metrics.tags.region=us-east-1
```

### 2. **Use Histograms for Latency**
```java
@Timed(value = "my.operation", histogram = true)
public void myOperation() { ... }
```

### 3. **Monitor Business Metrics**
```java
@Autowired
private MeterRegistry meterRegistry;

public void processOrder(Order order) {
    meterRegistry.counter("orders.processed",
        "status", order.getStatus()
    ).increment();
}
```

### 4. **Set Retention Policies**
```yaml
# prometheus.yml
global:
  scrape_interval: 15s
  
# Retention: 30 days
command:
  - '--storage.tsdb.retention.time=30d'
```

---

## 📋 Checklist

- [ ] Added Actuator & Prometheus dependencies
- [ ] Configured application.properties
- [ ] Tested /actuator/prometheus endpoint
- [ ] Created monitoring folder
- [ ] Created docker-compose.yml
- [ ] Created prometheus.yml
- [ ] Started Prometheus & Grafana containers
- [ ] Verified Prometheus targets
- [ ] Added Prometheus data source in Grafana
- [ ] Imported Spring Boot dashboard (11378)
- [ ] Generated test traffic
- [ ] Verified metrics appear in dashboard
- [ ] Documented findings

---

## 🔗 Links

- **Actuator Endpoints:** http://localhost:8080/actuator
- **Prometheus:** http://localhost:9090
- **Prometheus Targets:** http://localhost:9090/targets
- **Grafana:** http://localhost:3001
- **Official Dashboards:** https://grafana.com/grafana/dashboards

---

**🎉 You now have production-grade monitoring for your Spring Boot application!**

**Metrics visible:**
- ✅ JVM memory and GC
- ✅ CPU usage
- ✅ HTTP requests and latency
- ✅ Thread statistics
- ✅ System resources

**Next:** Generate load, watch real-time metrics, and take screenshots for your lab report!

#!/bin/bash

# =============================
# System Usage Monitoring Script
# =============================

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

# Log file
LOG_FILE="logs/resource_monitor.log"
mkdir -p logs  # Ensure log directory exists

# 1. CPU USAGE
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
cpu_usage=${cpu_usage%.*}  # convert float to int

# 2. MEMORY USAGE
mem_usage=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100)}')

# 3. DISK USAGE (root partition)
disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

# Timestamp
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

# Check and log
{
  echo "[$timestamp] CPU: $cpu_usage%, Memory: $mem_usage%, Disk: $disk_usage%"
  if (( cpu_usage > CPU_THRESHOLD )); then
    echo "[$timestamp] ⚠️ CPU usage above threshold ($cpu_usage%)"
  fi
  if (( mem_usage > MEM_THRESHOLD )); then
    echo "[$timestamp] ⚠️ Memory usage above threshold ($mem_usage%)"
  fi
  if (( disk_usage > DISK_THRESHOLD )); then
    echo "[$timestamp] ⚠️ Disk usage above threshold ($disk_usage%)"
  fi
  echo ""
} >> "$LOG_FILE"


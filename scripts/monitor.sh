#!/bin/bash
echo "=== System Monitor $(date) ==="
echo "--- CPU ---" && uptime
echo "--- MEMORY ---" && free -h
echo "--- DISK ---" && df -h / | tail -1
echo "--- DOCKER ---" && docker ps --format "table {{.Names}}\t{{.Status}}" 2>/dev/null
echo "--- TOP ---" && ps aux --sort=-%mem | head -6

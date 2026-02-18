Quick system health check.

Run these commands and summarize the results:

```bash
echo "=== System Health ==="
echo "Uptime: $(uptime -p)"
echo "Load: $(cat /proc/loadavg | cut -d' ' -f1-3)"
echo "Memory: $(free -h | awk '/Mem:/ {print $3"/"$2" ("int($3/$2*100)"%)"}')"
echo "Disk: $(df -h / | awk 'NR==2 {print $3"/"$2" ("$5")"}')"
echo "CPU Temp: $(sensors 2>/dev/null | grep -m1 'Package id 0' | awk '{print $4}' || echo 'N/A')"
echo "Failed Services: $(systemctl --failed --no-legend | wc -l)"
echo "Updates: $(pacman -Qu 2>/dev/null | wc -l) packages"
```

Report any issues or anomalies to the user.

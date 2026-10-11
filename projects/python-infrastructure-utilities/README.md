# Python Infrastructure Utilities

Small standard-library utility that prints hostname, OS/Python versions, root filesystem capacity, and CPU count.

## Run

```bash
python3 health_report.py
```

## Notes

- The script does not need third-party dependencies.
- It reports the root filesystem visible to the process; containers may see container-specific filesystem limits.
- Python's standard library does not expose a portable host uptime API, so the output deliberately does not claim to calculate real system uptime. Use `uptime` or platform-specific interfaces for that metric.
- Use the Linux shell toolkit for additional service and process checks.

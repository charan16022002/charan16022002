#!/usr/bin/env python3
"""Print a basic host health snapshot using the Python standard library."""

import os
import platform
import shutil
import socket
import time


def main() -> None:
    disk = shutil.disk_usage("/")
    print("=== Host health snapshot ===")
    print(f"Hostname: {socket.gethostname()}")
    print(f"OS: {platform.platform()}")
    print(f"Python: {platform.python_version()}")
    print("Uptime: use the host uptime command (not portable in the Python standard library)")
    print(f"Root filesystem total: {disk.total // (1024**3)} GiB")
    print(f"Root filesystem used: {disk.used // (1024**3)} GiB")
    print(f"Root filesystem free: {disk.free // (1024**3)} GiB")
    print(f"Disk usage: {disk.used / disk.total * 100:.1f}%")
    print(f"CPU count: {os.cpu_count() or 'unknown'}")



if __name__ == "__main__":
    main()

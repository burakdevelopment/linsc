import os
import subprocess
import pwd
import grp
import json
import re
from datetime import datetime

RED = "\033[0;31m"
GREEN = "\033[0;32m"
YELLOW = "\033[1;33m"
BLUE = "\033[0;34m"
NC = "\033[0m"

def banner():
    print(f"{YELLOW}=== LINUX SERVER SECURITY AUDIT ==={NC}")
    print(f"{BLUE}Timestamp: {datetime.now()} {NC}\n")

def require_root():
    if os.geteuid() != 0:
        print(f"{RED}Run this script as root{NC}")
        exit(1)

def run(cmd):
    return subprocess.getoutput(cmd)

def check_updates():
    print(f"{YELLOW}[1] System Updates{NC}")
    if os.path.exists("/usr/bin/apt"):
        updates = run("apt list --upgradable 2>/dev/null | grep -v Listing | wc -l")
        if int(updates) > 0:
            print(f"{RED}Upgradable packages: {updates}{NC}")
        else:
            print(f"{GREEN}System fully patched{NC}")
    elif os.path.exists("/usr/bin/yum"):
        print(f"{YELLOW}YUM based system – manual review recommended{NC}")

def sudo_users():
    print(f"\n{YELLOW}[2] Privileged Users{NC}")
    for g in ["sudo", "wheel"]:
        try:
            members = grp.getgrnam(g).gr_mem
            print(f"{RED if members else GREEN}{g}: {members}{NC}")
        except KeyError:
            pass

def empty_passwords():
    print(f"\n{YELLOW}[3] Empty Password Accounts{NC}")
    data = run("awk -F: '($2==\"\"){print $1}' /etc/shadow")
    print(f"{RED}{data}{NC}" if data else f"{GREEN}No empty passwords{NC}")

def ssh_hardening():
    print(f"\n{YELLOW}[4] SSH Hardening{NC}")
    ssh = "/etc/ssh/sshd_config"
    if not os.path.exists(ssh):
        print(f"{RED}SSH config not found{NC}")
        return
    cfg = open(ssh).read()
    checks = {
        "PermitRootLogin": "no",
        "PasswordAuthentication": "no",
        "X11Forwarding": "no",
        "PermitEmptyPasswords": "no"
    }
    for k,v in checks.items():
        if re.search(rf"^{k}\s+{v}", cfg, re.M):
            print(f"{GREEN}{k} OK{NC}")
        else:
            print(f"{RED}{k} WEAK{NC}")

def open_ports():
    print(f"\n{YELLOW}[5] Listening Ports{NC}")
    print(run("ss -tulnp"))

def dangerous_services():
    print(f"\n{YELLOW}[6] Dangerous Services{NC}")
    services = ["telnet", "ftp", "rsh", "rlogin", "rexec"]
    for s in services:
        status = run(f"systemctl is-enabled {s} 2>/dev/null")
        if "enabled" in status:
            print(f"{RED}{s} ENABLED{NC}")

def suid_files():
    print(f"\n{YELLOW}[7] SUID Files (Privilege Escalation Risk){NC}")
    print(run("find / -perm -4000 -type f 2>/dev/null | head -n 15"))

def writable_paths():
    print(f"\n{YELLOW}[8] World Writable Files{NC}")
    print(run("find /home /var -type f -perm -0002 2>/dev/null | head -n 10"))

def auth_logs():
    print(f"\n{YELLOW}[9] Failed Login Attempts{NC}")
    log = "/var/log/auth.log" if os.path.exists("/var/log/auth.log") else "/var/log/secure"
    print(run(f"grep 'Failed password' {log} | tail -n 10"))

def cron_jobs():
    print(f"\n{YELLOW}[10] Cron Jobs{NC}")
    print(run("ls -la /etc/cron*"))

def kernel_security():
    print(f"\n{YELLOW}[11] Kernel Security{NC}")
    settings = {
        "kernel.randomize_va_space": "2",
        "net.ipv4.ip_forward": "0",
        "net.ipv4.conf.all.accept_redirects": "0",
        "net.ipv4.conf.all.send_redirects": "0"
    }
    for k,v in settings.items():
        current = run(f"sysctl -n {k} 2>/dev/null")
        if current == v:
            print(f"{GREEN}{k} OK{NC}")
        else:
            print(f"{RED}{k} WEAK (current: {current}){NC}")

def audit_summary():
    print(f"\n{GREEN}=== SCAN COMPLETED ==={NC}")
    print(f"{BLUE}Review RED findings immediately{NC}")

def main():
    banner()
    require_root()
    check_updates()
    sudo_users()
    empty_passwords()
    ssh_hardening()
    open_ports()
    dangerous_services()
    suid_files()
    writable_paths()
    auth_logs()
    cron_jobs()
    kernel_security()
    audit_summary()

if __name__ == "__main__":
    main()

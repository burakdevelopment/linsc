# 🔐 Linsc  
### Linux Operating Systems & Servers – Fast Security Scan Tool (Bash)

**Linsc** is a lightweight and fast security scanning tool designed for Linux operating systems and servers.  
Written entirely in **Python**, it helps quickly identify **basic security weaknesses** and misconfigurations on a system with a single command.

Linsc is **not a full penetration testing framework**.  
It is intended for **quick security assessments**, initial audits, and rapid system hardening checks.

---

## 🚀 Features

Linsc performs the following security checks:

- 📦 **System Updates**
  - Detects outdated and upgradable packages

- 👤 **Privileged Users**
  - Lists users with `sudo` or `wheel` permissions

- 🔑 **Weak Accounts**
  - Detects user accounts with empty passwords

- 🌐 **Open Ports**
  - Displays listening TCP/UDP network ports

- ⚠️ **Insecure Services**
  - Checks for risky services such as Telnet, FTP, rsh, and similar

- 📝 **World-Writable Files**
  - Scans for files writable by all users

- 🔐 **SSH Configuration**
  - Checks if root login is enabled
  - Displays the SSH port in use

- 🧬 **Privilege Escalation Risks**
  - Lists SUID (Set User ID) files

- 🚨 **Suspicious Login Attempts**
  - Reports recent failed SSH login attempts

---

## 🎯 Purpose

The main goals of Linsc are:

- Quickly identify **basic security vulnerabilities** on Linux systems
- Provide an **initial security overview** before deeper audits
- Save time for system administrators and security engineers
- Perform fast security checks on newly deployed servers

---

## 🧑‍💻 Requirements

- Linux (Debian / Ubuntu / Kali / RHEL / CentOS compatible)
- Root privileges (`sudo`)

---

## ⚙️ Installation & Usage

```bash
git clone https://github.com/burakdevelopment/linsc.git
cd linsc
sudo python linsc.py
```

## ⚠️ Disclaimer

- This tool is intended for defensive and educational purposes only.
Do not use it on systems you do not own or have explicit permission to test.
The user is responsible for addressing any detected security issues.

## 🤝 Contributing

- Contributions, suggestions, and pull requests are welcome.
Feedback is highly appreciated and helps improve the project.

## 👤 Author

- Burak Akpınar
- GitHub: https://github.com/burakdevelopment

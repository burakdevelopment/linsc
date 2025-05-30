# Linsc - Linux OS's and Servers Fast System Scan Tool with Bash

- This bash script is designed to quickly detect basic vulnerabilities on your Linux server. It checks if there are any outdated packages, users with sudo privileges, and accounts with empty passwords on your system. It also checks if open network ports and insecure services (such as telnet or FTP) are running. It scans world-writable files to see if critical files are vulnerable to unauthorized access. It examines SSH settings to see if root can log in remotely and which port SSH is using. It lists privilege-elevating (SUID) files and reports the last failed SSH login attempts. This allows you to quickly see basic vulnerabilities that could threaten the security of your server.

## Features

- Checks if system packages are up to date.
  
- Lists users with sudo permissions.

- Detects user accounts with empty passwords.

- Shows open and listening network ports on the server.

- Checks if insecure services such as Telnet and FTP are running.

- Scans and lists world-writable files.

- Checks SSH configuration to show if root access is open and the port used.

- Detects privilege-elevating (SUID) files.

- Reports last failed SSH login attempts.

- ## Purpose

- The purpose of this script is to quickly identify basic vulnerabilities on a Linux server and summarize the security status of the system.

- ## How to use? (Linux OS)

- git clone https://github.com/burakdevelopment/linsc/
- cd linsc
- chmod +x svscanner.sh
- sudo ./svscanner.sh



- Your opinions are important to me :)

![markburakdevelopment](https://github.com/user-attachments/assets/1e516f06-f2db-4fd6-a80e-c203615f4084)

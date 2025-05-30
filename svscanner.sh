#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}--- Linux Server Security Scan Begins ---${NC}"
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}run this script as root${NC}"
  exit 1
fi
echo -e "${YELLOW}[1] checking for system updates${NC}"
if apt update -qq > /dev/null 2>&1; then
    UPDATES=$(apt list --upgradable 2>/dev/null | grep -v Listing | wc -l)
    if [ "$UPDATES" -gt 0 ]; then
        echo -e "${RED}number of packages to be updated: $UPDATES${NC}"
    else
        echo -e "${GREEN}all packages are up to date${NC}"
    fi
elif yum check-update > /dev/null 2>&1; then
    echo -e "${YELLOW}i recommend manual checking on RHEL based systems${NC}"
fi
echo -e "${YELLOW}[2] users with sudo privileges:${NC}"
getent group sudo || getent group wheel
echo -e "${YELLOW}[3] checking users with empty passwords${NC}"
awk -F: '($2==""){print $1 " -> boş şifre!"}' /etc/shadow
echo -e "${YELLOW}[4] open ports and connections:${NC}"
ss -tuln | grep LISTEN
echo -e "${YELLOW}[5] services are checked${NC}"
for svc in telnet vsftpd rsh rlogin xinetd; do
    if systemctl list-units --type=service --all | grep -q "$svc"; then
        echo -e "${RED}$svc service is installed or running${NC}"
    fi
done
echo -e "${YELLOW}[6] scanning for writable files (/home, /var)...${NC}"
find /home /var -type f -perm -0002 -exec ls -l {} \; 2>/dev/null | head -n 10
echo -e "${YELLOW}[7] checking SSH configuration...${NC}"
SSH_CONF="/etc/ssh/sshd_config"
if grep -q "^PermitRootLogin yes" $SSH_CONF; then
    echo -e "${RED}root login is enabled via SSH!${NC}"
else
    echo -e "${GREEN}root login is disabled via SSH.${NC}"
fi
grep -i "^Port" $SSH_CONF
echo -e "${YELLOW}[8] checking SUID privilege-elevating files${NC}"
find / -perm -4000 -type f 2>/dev/null | head -n 10
echo -e "${YELLOW}[9] suspicious login attempts:${NC}"
grep "Failed password" /var/log/auth.log 2>/dev/null | tail -n 5
echo -e "${GREEN}--- Scans completed. Reporting ended ---${NC}"


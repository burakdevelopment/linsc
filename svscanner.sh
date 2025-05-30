#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}--- Linux Sunucu Güvenlik Taraması Başlıyor ---${NC}"
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}bu scripti root olarak çalıştırın${NC}"
  exit 1
fi
echo -e "${YELLOW}[1] sistem güncellemeleri kontrol ediliyor${NC}"
if apt update -qq > /dev/null 2>&1; then
    UPDATES=$(apt list --upgradable 2>/dev/null | grep -v Listing | wc -l)
    if [ "$UPDATES" -gt 0 ]; then
        echo -e "${RED}güncellenmesi gereken paket sayısı: $UPDATES${NC}"
    else
        echo -e "${GREEN}Tüm paketler güncel${NC}"
    fi
elif yum check-update > /dev/null 2>&1; then
    echo -e "${YELLOW}RHEL tabanlı sistemlerde manuel kontrol öneririm${NC}"
fi
echo -e "${YELLOW}[2] Sudo yetkisine sahip kullanıcılar:${NC}"
getent group sudo || getent group wheel
echo -e "${YELLOW}[3] boş şifreli kullanıcılar kontrol ediliyor${NC}"
awk -F: '($2==""){print $1 " -> boş şifre!"}' /etc/shadow
echo -e "${YELLOW}[4] açık portlar ve bağlantılar:${NC}"
ss -tuln | grep LISTEN
echo -e "${YELLOW}[5] servisler kontrol ediliyor${NC}"
for svc in telnet vsftpd rsh rlogin xinetd; do
    if systemctl list-units --type=service --all | grep -q "$svc"; then
        echo -e "${RED}$svc servisi yüklü veya çalışıyor!${NC}"
    fi
done
echo -e "${YELLOW}[6] yazılabilir dosyalar taranıyor (/home, /var)...${NC}"
find /home /var -type f -perm -0002 -exec ls -l {} \; 2>/dev/null | head -n 10
echo -e "${YELLOW}[7] SSH yapılandırması kontrol ediliyor...${NC}"
SSH_CONF="/etc/ssh/sshd_config"
if grep -q "^PermitRootLogin yes" $SSH_CONF; then
    echo -e "${RED}SSH ile root girişi açık!${NC}"
else
    echo -e "${GREEN}root girişi SSH üzerinden kapalı.${NC}"
fi
grep -i "^Port" $SSH_CONF
echo -e "${YELLOW}[8] SUID yetki yükselten dosyalar kontrol ediliyor${NC}"
find / -perm -4000 -type f 2>/dev/null | head -n 10
echo -e "${YELLOW}[9] şüpheli oturum açma girişimleri:${NC}"
grep "Failed password" /var/log/auth.log 2>/dev/null | tail -n 5
echo -e "${GREEN}--- Taramalar tamamlandı. Raporlama sona erdi ---${NC}"


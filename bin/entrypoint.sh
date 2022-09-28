#!/bin/sh

set -eu  

if [ "$(id -u)" = '0' ]; then
  # test -f /usr/bin/envsubst || apk add gettext libintl
  
  chown "${PUID}:${PGID}" "${HOME}" \
    && exec su-exec "${PUID}:${PGID}" \
       env HOME="$HOME" $0 "$@"
else
  if [[ ! -d /var/syncthing/.config/syncthing ]]; then
    syncthing generate --skip-port-probing
    # mv /var/syncthing/.config/syncthing/config.xml /var/syncthing/.config/syncthing/config.xml.template
    # sed -i 's/127.0.0.1:8384/127.0.0.1:$ST_WEB_UI/' /var/syncthing/.config/syncthing/config.xml.template
    
    # sed -i 's/<address>dynamic<\/address>/$ST_ADDRESS/' /var/syncthing/.config/syncthing/config.xml.template
    
    # sed -i 's/<listenAddress>default<\/listenAddress>/$ST_ADDRESS/' /var/syncthing/.config/syncthing/config.xml.template    
    # sed -i 's/21027/$ST_LOCAL_DISCOVERY/' /var/syncthing/.config/syncthing/config.xml.template

    # sed -i 's/<address>dynamic<\/address>/$ST_ADDRESS/' /var/syncthing/.config/syncthing/config.xml.template
    sed -i 's/<urAccepted>0<\/urAccepted>/<urAccepted>-1<\/urAccepted>/' /var/syncthing/.config/syncthing/config.xml
    sed -i 's/<urSeen>0<\/urSeen>/<urSeen>3<\/urSeen>/' /var/syncthing/.config/syncthing/config.xml
    sed -i 's/<theme>default<\/theme>/<theme>dark<\/theme><user>admin<\/user><password>$2a$10$MatXa\/tuiXwk46Z7RueVBuDoz8hnVxACd.PxJ0NS7yoLaDgnzR1gu<\/password>/' /var/syncthing/.config/syncthing/config.xml

    mkdir -p /var/syncthing/config
    cp /var/syncthing/.config/syncthing/config.xml /var/syncthing/config/config.xml
    cp /var/syncthing/.config/syncthing/config.xml /var/syncthing/config/config.xml.v0
  fi  
  # export ST_ADDRESS="<listenAddress><address>tcp://0.0.0.0:$ST_TCP_FT</address><address>quic://0.0.0.0:$ST_QUICK_FT</address></listenAddress>"
  # envsubst < /var/syncthing/.config/syncthing/config.xml.template > /var/syncthing/.config/syncthing/config.xml

  exec "$@"
fi
#!/usr/bin/env bash

if (( $(id -u) != 0 )); then
  echo "I'm not root"
  exit 1
fi
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
#shellcheck source=./.env
source "${SCRIPT_DIR}/.env"

#Regex obtained from https://www.ditig.com/validating-ipv4-and-ipv6-addresses-with-regexp
ipv4ipv6regex='((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])|(([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4}|([0-9A-Fa-f]{1,4}:){1,7}:|:(:[0-9A-Fa-f]{1,4}){1,7}|([0-9A-Fa-f]{1,4}:){1,6}:[0-9A-Fa-f]{1,4}|([0-9A-Fa-f]{1,4}:){1,5}(:[0-9A-Fa-f]{1,4}){1,2}|([0-9A-Fa-f]{1,4}:){1,4}(:[0-9A-Fa-f]{1,4}){1,3}|([0-9A-Fa-f]{1,4}:){1,3}(:[0-9A-Fa-f]{1,4}){1,4}|([0-9A-Fa-f]{1,4}:){1,2}(:[0-9A-Fa-f]{1,4}){1,5}|[0-9A-Fa-f]{1,4}:(:[0-9A-Fa-f]{1,4}){1,6}|:(:[0-9A-Fa-f]{1,4}){1,6}))'


TEMPLATE_update="gsstsig
server %s
realm %s
zone %s
update %s %s %s %s %s
send"


ip monitor address | while read -r event; do
  #- If IP is added
  if [[ "$event" =~ ^[0-9]*:.*inet.*scope.*$ ]]; then
    ip=$(echo "$event" | grep -E "$ipv4ipv6regex" --only-matching)
    echo "adding $ip"
    if [[ $event =~ .*inet6.* ]]; then rtype="AAAA"; else rtype="A"; fi
    kinit -kt "$SCRIPT_DIR/$keytab_file" $username
    # shellcheck disable=SC2059
    printf "$TEMPLATE_update" "$server" "$realm" "$zone" "add" "$dns_hostname" "$TTL" "$rtype" "$ip" | nsupdate
    kdestroy
  #- If IP is deleted
  elif [[ "$event" =~ ^Del.*:.*inet.*scope.*$ ]]; then
    ip=$(echo "$event" | grep -E "$ipv4ipv6regex" --only-matching)
    echo "removing $ip"
    if [[ $event =~ .*inet6.* ]]; then rtype="AAAA"; else rtype="A"; fi
    kinit -kt "$SCRIPT_DIR/$keytab_file" $username
    # shellcheck disable=SC2059
    printf "$TEMPLATE_update" "$server" "$realm" "$zone" "delete" "$dns_hostname" "$TTL" "$rtype" "$ip" | nsupdate
    kdestroy
  fi
done

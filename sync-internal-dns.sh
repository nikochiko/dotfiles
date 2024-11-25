#!/bin/bash

set -ex

self="$(hostname -s)"
internal_hosts_file="/Users/kaustubh/Sync/internal.hosts"
etc_hosts_file="/etc/hosts"

self_domain="$self.internal"
echo "self hostname: '$self'"$'\t'"advertising as: '$self_domain'"

function get_self_ip {
    for w in $(/sbin/ifconfig | grep 192.168); do
        if [[ "$w" =~ ^192\.168\..* ]]; then
            echo "$w"
            break
        fi
    done
}

self_ip="$(get_self_ip)"
if [ "$self_ip" = "" ]; then
    echo "oops! couldn't find private IP"
    exit 1
fi

function readHosts {
    # returns:
    # ip,host
    # ip,host
    # ...
    IFS=$'\n'
    while read line; do
        unset IFS

        line=$(echo "$line" | sed -e 's/#.*$//' | sed 's/^\s*$//')
        if [ "$line" = "" ]; then
            continue
        fi

        read ip host <<< $line
        echo $ip $host
    done
}

internal_hosts="$(cat $internal_hosts_file | readHosts)"
etc_hosts="$(cat $etc_hosts_file | readHosts)"

echo "INTERNAL:"
echo "$internal_hosts"
echo "ETC:"
echo "$etc_hosts"

has_self="0"
IFS=$'\n'
for ih in $internal_hosts; do
    unset IFS

    read wanted_ip wanted_host <<< $ih
    echo "wanted_ip: $wanted_ip, wanted_host: $wanted_host"

    if [ "$self_domain" = "$wanted_host" ]; then
        if [ "$self_ip" != "$wanted_ip" ]; then
            sed -i bak "s/^$wanted_ip.*$//" $internal_hosts_file
        else
            has_self="1"
        fi
        break
    fi
done
if [ "$has_self" != "1" ]; then
    echo "$self_ip"$'\t'"$self_domain" >> $internal_hosts_file
fi

IFS=$'\n'; for ih in $internal_hosts; do
    unset IFS

    read wanted_ip wanted_host <<< $ih

    if [ "$wanted_host" = "$self_domain" ]; then
        continue
    fi

    fixed="0"
    IFS=$'\n'; for eh in $etc_hosts; do
        unset IFS
        read etc_ip etc_host <<< $eh
        if [ "$etc_host" = "$wanted_host" ]; then
            sed -i .bak -r "s/$etc_ip[[:space:]]+$etc_host/$wanted_ip\t$wanted_host/" $etc_hosts_file
            fixed="1"
        fi
    done

    if [ "$fixed" != "1" ]; then
        echo "$wanted_ip"$'\t'"$wanted_host" >> $etc_hosts_file
    fi
done

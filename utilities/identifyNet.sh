#!/usr/bin/env bash
# author: eleAche
# description: identifies the hosts that are connected to your system

function regex_patterns {
    # ipv4 | mac | ipv6 | email | essid
    grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' "$@" 
    grep -Eo '([0-9a-fA-F]{,4})*:([0-9a-fA-F]{,4})*:([0-9a-fA-F]{,4})*:([0-9a-fA-F]{,4})*:([0-9a-fA-F]{,4})*:([0-9a-fA-F]{,4})*:([0-9a-fA-F]{,4})*:([0-9a-fA-F]{,4})*' "$@"
    grep -Eo '([0-9a-fA-F]{,2}:[0-9a-fA-F]{,2}:[0-9a-fA-F]{,2}:[0-9a-fA-F]{,2}:[0-9a-fA-F]{,2}:[0-9a-fA-F]{,2})+' "$@"
    grep -Eo '.+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+' "$@"
    grep -Eo '\S+:[0-9a-fA-F]{,2}:[0-9a-fA-F]{,2}:[0-9a-fA-F]{,2})+' "$@"
}

function passive_recon {
    local entry="$1"
    curl ipinfo.io/$entry 2>/dev/null
}

function loger {
    echo -en " [+] Scanning... \e[3${RANDOM::1}m${c}\e[m\r" > /dev/stderr
    sleep 0.05s
}

function Main {
  local checkups=100
  local c
  while (( c < checkups ))
    do ss | regex_patterns \
          | sort -u \
          | uniq
            let c++ && loger
       done \
          | sort -u \
          | uniq \
          | while read host
       do   passive_recon "$host"
          done
}

Main

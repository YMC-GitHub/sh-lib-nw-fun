#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source "$THIS_FILE_PATH/../../src/sh-lib-nw.ip.sh"

nw_ip_is "192.168.0.1"
nw_ip_is "255.255.255.256"


nw_ip_type_is "1.10.0.1"
nw_ip_type_is "128.10.0.1"
nw_ip_type_is "192.168.0.1"
nw_ip_type_is "224.168.0.1"
nw_ip_type_is "240.168.0.1"


nw_ip_private_is "10.16.0.1"
nw_ip_private_is "11.16.0.1"

nw_ip_private_is "172.16.0.1"
nw_ip_private_is "172.15.0.1"

nw_ip_private_is "192.168.0.1"
nw_ip_private_is "192.178.0.1"

nw_ip_addr_net_from_host "192.168.1.1" "255.255.255.0"
nw_ip_addr_net_from_host "222.21.160.73" "255.255.255.192"

nw_ip_addr_hostid "192.168.1.1" "255.255.255.0"
nw_ip_addr_hostid "222.21.160.73" "255.255.255.192"

nw_ip_addr_net_from_host "192.24.0.0" "255.248.0.0"
nw_ip_addr_net_from_host "192.31.0.0" "255.248.0.0"

nw_ip_addr_hostid "192.24.0.0" "255.248.0.0"
nw_ip_addr_hostid "192.31.0.0" "255.248.0.0"

nw_ip_addr_net_from_host "192.24.0.0" "192.31.0.0"
nw_ip_addr_net_from_host "192.24.0.0" "192.31.255.0"

nw_ip_addr_net_to_cidr "192.24.0.0" "192.31.0.0"
# file usage
# test/unit/nw.ip.sh
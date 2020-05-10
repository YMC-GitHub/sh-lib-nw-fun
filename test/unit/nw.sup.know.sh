#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
THIS_FILE_NAME=$(basename $0)
source "$THIS_FILE_PATH/../../src/sh-lib-nw.sup.know.sh"


#已知：
#主机地址
#网址类型
#子网数量
#求解：
#超网划分
# <=>
#已知：
#主机地址=192.24.0.0|192.31.255.0
#网址类型=C
#子网数量=2048
#求解：
#网络划分超网

txt=$(cat <<EOF
# case01
主机地址=192.24.0.0|192.31.255.0
网址类型=C
子网数量=2048
EOF
)


nw_sup_know_from_list "$txt"

ips=$(nw_sup_know_get "主机地址")
echo "ips:$ips"

txt_list_to_arr "$ips" "arr" "|"

# addr_hosts->addr_net
addres=${arr[0]}
for ip in $(echo "${arr[@]}")
do
    addres=$(nw_ip_addr_net_from_host "$addres" "$ip")
done

# addr_net->cidr
cidr=$(nw_ip_addr_net_to_cidr "$addres")
echo "cidr:$cidr"

# cidr->mask
mask=$(nw_cidr_to_mask "$cidr")
echo "mask:$mask"
nw_sup_know_set "网络掩码" "$mask"

# addr_host|mask->addr_net
addres=$(nw_ip_addr_net_from_host "$addres" "$mask")
#nw_ip_addr_net_from_host "$mask" "$addres"
echo "addres:$addres"

# file usage
#echo "$THIS_FILE_NAME"
# test/unit/nw.sup.know.sh
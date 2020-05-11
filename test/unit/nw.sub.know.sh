#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
THIS_FILE_NAME=$(basename $0)
source "$THIS_FILE_PATH/../../src/nw.sub.know.sh"

#已知：
#网络地址
#子网掩码
#求解：
#子网划分
# <=>
#已知：
#网络地址=192.168.10.0
#网络掩码=255.255.255.192
#求解：
#网络划分子网

txt=$(cat <<EOF
# case01
#网络地址=192.168.10.0
#网络掩码=255.255.255.192

# case02
#网络地址=192.168.10.0
#子网数量=4
#掩码类型=D

网络地址=192.168.10.0
主机数量=62
掩码类型=D
EOF
)
nw_sub_know_from_list "$txt"

function nw_sub_know_case_01(){
address=$(nw_sub_know_get "网络地址")
echo "address:$address"
mask=$(nw_sub_know_get "网络掩码")
echo "mask:$mask"

cidr=$(nw_mask_to_cidr "$mask")
echo "prefix:$cidr"
nw_sub_know_set "掩码前缀" "$cidr"

mask_type=$(nw_mask_type_is "$mask")
echo "mask_type:$mask_type"
nw_sub_know_set "掩码类型" "$mask_type"

sub_bits=$(nw_sub_cidr_to_bits "$mask_type" "$cidr")
echo "sub_bits:$sub_bits"
nw_sub_know_set "子网位数" "$sub_bits"

host_bits=$(nw_sub_host_cidr_to_bits "$mask_type" "$cidr")
echo "host_bits:$host_bits"
nw_sub_know_set "主机位数" "$host_bits"

sub_num=$(nw_sub_bits_to_num "$sub_bits")
echo "sub_num:$sub_num"
nw_sub_know_set "子网数量" "$sub_num"

host_num=$(nw_sub_host_bits_to_num "$host_bits")
echo "host_num:$host_num"
nw_sub_know_set "主机数量" "$host_num"

ip_type=$(nw_ip_type_is "$address")
echo "ip_type:$ip_type"
nw_sub_know_set "网址类型" "$ip_type"

valid_sub=
#valid_sub=$()
  ip=$(echo "$address" | sed "s/ //g"| sed "s/\./ /g"|sed "/^$/d")
  arr=(${ip//,/ })
for i in `seq 1 $sub_num`
do
  b=$[$host_num+2-1]
  n=$[($host_num+2)*($i-1)]
  s=$[$n+1]
  e=$[$b-1]
  case $mask_type in
    "1"|"A")
     head=""
     addr_net="${n}.0.0.0"
     addr_bro="${b}.0.0.0"
     addr_hos="${s}.0.0.0~${e}.0.0.0"
    ;;
    "2"|"B")
     head="${arr[0]}."
     addr_net="${head}${n}.0.0"
     addr_bro="${head}${b}.0.0"
     addr_hos="${head}${s}.0.0~${head}${e}.0.0"
    ;;
    "3"|"C")
     head="${arr[0]}.${arr[1]}."
     addr_net="${head}${n}.0"
     addr_bro="${head}${b}.0"
     addr_hos="${head}${s}.0~${head}${e}.0"
    ;;
    "4"|"D")
     head="${arr[0]}.${arr[1]}.${arr[2]}."
     addr_net="${head}${n}"
     addr_bro="${head}${b}"
     addr_hos="${head}${s}~${head}${e}"
    ;;
esac

  valid_sub=$(cat <<EOF
$valid_sub
$addr_net/$cidr $addr_net $mask $addr_bro $addr_hos $host_num
EOF
)
done
valid_sub=$(echo "$valid_sub" | sed "/^$/d")
t=$(cat <<EOF
subnet addr_net mask addr_broad addr_host host_num
$valid_sub
EOF
)
echo "valid_sub:$t"
valid_sub=$(cat <<EOF
子网 网络地址 子网掩码 广播地址 主机地址 主机数量
$valid_sub
EOF
)
nw_sub_know_set "有效子网" "$valid_sub"

txt=
for key in $(echo "${!nw_sub_know_dic[*]}")
do
    txt=$(cat <<EOF
$txt
$key:${nw_sub_know_dic[$key]}
EOF
)
done
echo "$txt"
}

function nw_sub_know_case_02(){

#sub_num->sub_bits->cidr->mask
sub_num=$(nw_sub_know_get "子网数量")
echo "sub_num:$sub_num"
mask_type=$(nw_sub_know_get "掩码类型")
echo "mask_type:$mask_type"
address=$(nw_sub_know_get "网络地址")
echo "address:$address"

sub_bits=$(nw_sub_num_to_bits "$sub_num")
echo "sub_bits:$sub_bits"
nw_sub_know_set "子网位数" "$sub_bits"

cidr=$(nw_sub_bits_to_cidr "$mask_type" "$sub_bits")
echo "prefix:$cidr"
nw_sub_know_set "掩码前缀" "$cidr"

mask=$(nw_mask_from_cidr "$cidr")
echo "mask:$mask"
nw_sub_know_set "子网掩码" "$mask"


#host_bits=$(nw_sub_host_cidr_to_bits "$mask_type" "$cidr") #ok but next line maybe good
host_bits=$(nw_cidr_to_host_bits "$cidr")
echo "host_bits:$host_bits"
nw_sub_know_set "主机位数" "$host_bits"

host_num=$(nw_sub_host_bits_to_num "$host_bits")
echo "host_num:$host_num"
nw_sub_know_set "主机数量" "$host_num"

ip_type=$(nw_ip_type_is "$address")
echo "ip_type:$ip_type"
nw_sub_know_set "网址类型" "$ip_type"

valid_sub=
#valid_sub=$()
  ip=$(echo "$address" | sed "s/ //g"| sed "s/\./ /g"|sed "/^$/d")
  arr=(${ip//,/ })
for i in `seq 1 $sub_num`
do
  b=$[$host_num+2-1]
  n=$[($host_num+2)*($i-1)]
  s=$[$n+1]
  e=$[$b-1]
  case $mask_type in
    "1"|"A")
     head=""
     addr_net="${n}.0.0.0"
     addr_bro="${b}.0.0.0"
     addr_hos="${s}.0.0.0~${e}.0.0.0"
    ;;
    "2"|"B")
     head="${arr[0]}."
     addr_net="${head}${n}.0.0"
     addr_bro="${head}${b}.0.0"
     addr_hos="${head}${s}.0.0~${head}${e}.0.0"
    ;;
    "3"|"C")
     head="${arr[0]}.${arr[1]}."
     addr_net="${head}${n}.0"
     addr_bro="${head}${b}.0"
     addr_hos="${head}${s}.0~${head}${e}.0"
    ;;
    "4"|"D")
     head="${arr[0]}.${arr[1]}.${arr[2]}."
     addr_net="${head}${n}"
     addr_bro="${head}${b}"
     addr_hos="${head}${s}~${head}${e}"
    ;;
esac

  valid_sub=$(cat <<EOF
$valid_sub
$addr_net/$cidr $addr_net $mask $addr_bro $addr_hos $host_num
EOF
)
done
valid_sub=$(echo "$valid_sub" | sed "/^$/d")
t=$(cat <<EOF
subnet addr_net mask addr_broad addr_host host_num
$valid_sub
EOF
)
echo "valid_sub:$t"
valid_sub=$(cat <<EOF
子网 网络地址 子网掩码 广播地址 主机地址 主机数量
$valid_sub
EOF
)
nw_sub_know_set "有效子网" "$valid_sub"


txt=
for key in $(echo "${!nw_sub_know_dic[*]}")
do
    txt=$(cat <<EOF
$txt
$key:${nw_sub_know_dic[$key]}
EOF
)
done
echo "$txt"
}

function nw_sub_know_case_03(){

#host_num->host_bits->cidr->mask

host_num=$(nw_sub_know_get "主机数量")
echo "host_num:$host_num"
mask_type=$(nw_sub_know_get "掩码类型")
echo "mask_type:$mask_type"
address=$(nw_sub_know_get "网络地址")
echo "address:$address"



host_bits=$(nw_sub_host_num_to_bits "$host_num")
echo "host_bits:$host_bits"
nw_sub_know_set "主机位数" "$host_bits"

cidr=$(nw_sub_host_bits_to_cidr "$mask_type" "$host_bits")
echo "prefix:$cidr"
nw_sub_know_set "掩码前缀" "$cidr"

mask=$(nw_mask_from_cidr "$cidr")
echo "mask:$mask"
nw_sub_know_set "子网掩码" "$mask"


sub_bits=$(nw_sub_cidr_to_bits "$mask_type" "$cidr")
echo "sub_bits:$sub_bits"
nw_sub_know_set "子网位数" "$sub_bits"

sub_num=$(nw_sub_bits_to_num "$sub_bits")
echo "sub_num:$sub_num"
nw_sub_know_set "子网数量" "$sub_num"

ip_type=$(nw_ip_type_is "$address")
echo "ip_type:$ip_type"
nw_sub_know_set "网址类型" "$ip_type"


#valid_sub=$()
  ip=$(echo "$address" | sed "s/ //g"| sed "s/\./ /g"|sed "/^$/d")
  arr=(${ip//,/ })
for i in `seq 1 $sub_num`
do
  b=$[$host_num+2-1]
  n=$[($host_num+2)*($i-1)]
  s=$[$n+1]
  e=$[$b-1]
  case $mask_type in
    "1"|"A")
     head=""
     addr_net="${n}.0.0.0"
     addr_bro="${b}.0.0.0"
     addr_hos="${s}.0.0.0~${e}.0.0.0"
    ;;
    "2"|"B")
     head="${arr[0]}."
     addr_net="${head}${n}.0.0"
     addr_bro="${head}${b}.0.0"
     addr_hos="${head}${s}.0.0~${head}${e}.0.0"
    ;;
    "3"|"C")
     head="${arr[0]}.${arr[1]}."
     addr_net="${head}${n}.0"
     addr_bro="${head}${b}.0"
     addr_hos="${head}${s}.0~${head}${e}.0"
    ;;
    "4"|"D")
     head="${arr[0]}.${arr[1]}.${arr[2]}."
     addr_net="${head}${n}"
     addr_bro="${head}${b}"
     addr_hos="${head}${s}~${head}${e}"
    ;;
esac

  valid_sub=$(cat <<EOF
$valid_sub
$addr_net/$cidr $addr_net $mask $addr_bro $addr_hos $host_num
EOF
)
done
valid_sub=$(echo "$valid_sub" | sed "/^$/d")
t=$(cat <<EOF
subnet addr_net mask addr_broad addr_host host_num
$valid_sub
EOF
)
echo "valid_sub:$t"
valid_sub=$(cat <<EOF
子网 网络地址 子网掩码 广播地址 主机地址 主机数量
$valid_sub
EOF
)
nw_sub_know_set "有效子网" "$valid_sub"


txt=
for key in $(echo "${!nw_sub_know_dic[*]}")
do
    txt=$(cat <<EOF
$txt
$key:${nw_sub_know_dic[$key]}
EOF
)
done
echo "$txt"
}

#nw_sub_know_case_01
#nw_sub_know_case_02
nw_sub_know_case_03

# 获得子网增量
# 子网位数 子网数量 主机位数 主机数量

# 哪些合法子网
# 子网 网络地址 子网掩码 主机地址 广播地址 主机数量

# file usage
# test/unit/nw.sub.know.sh
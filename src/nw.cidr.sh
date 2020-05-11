#!/bin/sh

###
# 名字: nw_mask_cimi_sum
# 参数：子网位数
# 返回：子网掩码
# 描述：已知子网位数，获取子网掩码
###
function nw_mask_cimi_sum(){
local temp=0
local index_start=7
local index_increment="-1"
local index_end=$[8-$1]
#seq [OPTION]... FIRST INCREMENT LAST
local seq_number=`seq $index_start $index_increment $index_end`
for i in $seq_number
do
     temp=$[$temp+2**$i]
done
echo "$temp"
}

###
# 名字: nw_cidr_to_mask
# 参数：掩码前缀
# 返回：子网掩码
# 描述：已知子网掩码前缀，获取子网掩码
###
function nw_cidr_to_mask(){
  local res=
  local cidr=
[ -n "$1" ] && cidr="$1"
[ -z "$cidr" ] && cidr="24"
cidr=$(echo "$cidr" | sed "s/ //g"| sed "/^$/d")

if [ $cidr -le 8 ]; then
    res=$(nw_mask_cimi_sum $cidr)
    res="${res}.0.0.0"

elif [ $cidr -le 16 ]; then
    cidr=$(($cidr - 8))
    res=$(nw_mask_cimi_sum $cidr)
    res="255.${res}.0.0"
elif [ $cidr -le 24 ]; then
    cidr=$(($cidr - 16))
    res=$(nw_mask_cimi_sum $cidr)
    res="255.255.${res}.0"
elif [ $cidr -le 32 ]; then
    cidr=$(($cidr - 24))
    res=$(nw_mask_cimi_sum $cidr)
    res="255.255.255.${res}"
fi
echo "$res"
}

###
# 名字: nw_cidr_to_mask
# 参数：子网掩码
# 返回：掩码前缀
# 描述：已知子网掩码，获取掩码前缀
###
function nw_cidr_from_mask(){
  nw_mask_to_cidr "$1"
}

###
# 名字: nw_cidr_to_host_bits
# 参数：掩码前缀
# 返回：主机位数
# 描述：已知子网掩码前缀，获取主机位数
###
function nw_cidr_to_host_bits(){
  local res=
  local cidr=
  [ -n "$1" ] && cidr="$1"
  [ -z "$cidr" ] && cidr="24"
  cidr=$(echo "$cidr" | sed "s/ //g"| sed "/^$/d")
  res=$[32-$cidr]
  echo "$res"
}

###
# 名字: nw_cidr_from_host_bits
# 参数：主机位数
# 返回：掩码前缀
# 描述：已知每一子网的主机位数，获取子网掩码前缀
###
function nw_cidr_from_host_bits(){
  local res=
  local host_bits=
  [ -n "$1" ] && host_bits="$1"
  [ -z "$host_bits" ] && host_bits="24"
  host_bits=$(echo "$host_bits" | sed "s/ //g"| sed "/^$/d")
  res=$[32-$host_bits]
  echo "$res"
}


# file
# src/nw.cidr.sh
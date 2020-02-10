#!/bin/sh

#已知子网数量，获子网位数
# nw_sub_num_to_bits
#已知子网位数，获取子网数
# nw_sub_bits_to_num

#已知子网位数，获子网掩码
# nw_sub_bits_to_mask

#已知子网掩码，获子网前缀
# nw_sub_mask_to_cidr
#已知子网前缀，获子网掩码
# nw_sub_cidr_to_mask

#已知子网主机数量，获子网主机位数
# nw_sub_host_num_to_bits
#已知子网主机位数，获子网主机数量
# nw_sub_host_bits_to_num

#已知子网主机位数，获子网掩码
# nw_sub_host_bits_to_mask


#已知子网数量，获子网位数
function ip_get_sub_pos_count(){
local temp=0
local index_start=1
local index_ip_increment="1"
local index_end=8
local seq_number=`seq $index_start $index_increment $index_end`
local m=
local nw_sub_count=
[ -n "$1" ] && nw_sub_count="$1"
[ -z "$nw_sub_count" ] && nw_sub_count="20"

for i in $seq_number
do
     temp=$((2**$i))
     #echo "$temp,$i"
  if [ $temp -ge $nw_sub_count ]  ; then
   [  -z "$m" ] && m=$i;
   break;
  fi
done
echo "$m"
}


#已知子网位数，获取子网数
function ip_get_sub_count(){
local temp=
local count=

[ -n "$1" ] && count="$1"
[ -z "$count" ] && count="1"

temp=$((2**$i))
echo "$temp"
}



#通过子网位数推子网掩码
function ip_get_sub_mask_by_sub_pos_count(){
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



#通过子网位数和网络类型,推cidr
function ip_get_cidr_by_sub(){
  local res=
case $1 in
    "1")
     res=$2
    ;;
    "2")
    res=$(($2+8))
    ;;
    "3")
    res=$(($2+16))
    ;;
    "4")
    res==$(($2+24))
    ;;
esac
echo "$res"
}


#已知每一子网主机数量，获主机位数
function ip_get_sub_hos_pos_count(){
local temp=0
local index_start=1
local index_ip_increment="1"
local index_end=8
local seq_number=`seq $index_start $index_increment $index_end`
local m=
local nw_sub_host_count=
[ -n "$1" ] && nw_sub_host_count="$1"
[ -z "$nw_sub_host_count" ] && nw_sub_host_count="20"

for i in $seq_number
do
     temp=$((2**$i-2))
     #echo "$temp,$i"
  if [ $temp -ge $nw_sub_host_count ]  ; then
   [  -z "$m" ] && m=$i;
   break;
  fi
done
echo "$m"
}



#通过子网主机位数和网络类型,推cidr
function ip_get_cidr_by_sub_hos(){
  local res=
case $1 in
    "1")
     res=$((8-$2))
    ;;
    "2")
    res=$((16-$2))
    ;;
    "3")
    res=$((24-$2))
    ;;
    "4")
    res=$((32-$2))
    ;;
esac
echo "$res"
}


#已知每一子网主机位数，获主机数量
function ip_get_sub_hos_count(){
local res=0
local nw_sub_host_pos_count=
[ -n "$1" ] && nw_sub_host_pos_count="$1"
[ -z "$nw_sub_host_pos_count" ] && nw_sub_host_pos_count="3"
res=$((2**$nw_sub_host_pos_count-2))
echo "$res"
}



#通过掩码前缀，推子网掩码
function ip_get_mask_by_cidr(){
  local res=
  local cidr=
[ -n "$1" ] && cidr="$1"
[ -z "$cidr" ] && cidr="24"

if [ $cidr -le 8 ]; then
    res=$(ip_get_sub_mask_by_sub_pos_count $cidr)
    res="${res}.0.0.0"

elif [ $cidr -le 16 ]; then
    cidr=$(($cidr - 8))
    res=$(ip_get_sub_mask_by_sub_pos_count $cidr)
    res="255.${res}.0.0"
elif [ $cidr -le 24 ]; then
    cidr=$(($cidr - 16))
    res=$(ip_get_sub_mask_by_sub_pos_count $cidr)
    res="255.255.${res}.0"
elif [ $cidr -le 32 ]; then
    cidr=$(($cidr - 24))
    res=$(ip_get_sub_mask_by_sub_pos_count $cidr)
    res="255.255.255.${res}"
fi
echo "$res"
}


# 如何使用
# src/some-idea.sh
# 参考文献

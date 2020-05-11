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



###
# 名字: nw_sub_num_to_bits
# 参数：子网数量
# 返回：子网位数
# 描述：已知子网数量，获子网位数
###
function nw_sub_num_to_bits(){
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

###
# 名字: nw_sub_num_to_bits
# 参数：子网位数
# 返回：子网数量
# 描述：已知子网位数，获取子网数量
###
function nw_sub_bits_to_num(){
local temp=
local count=
[ -n "$1" ] && count="$1"
[ -z "$count" ] && count="1"
[ $count -lt 0 ] && count="1"
temp=$((2**$count))
echo "$temp"
}


###
# 名字: nw_sub_bits_to_mask
# 参数：子网位数
# 返回：子网掩码
# 描述：已知子网位数，获取子网掩码
###
function nw_sub_bits_to_mask(){
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
# 名字: nw_sub_mask_to_bits
# 参数：子网掩码
# 返回：子网位数
# 描述：已知子网掩码，获取子网位数
###
function nw_sub_mask_to_bits(){
local temp=0
local index_start=7
local index_increment="-1"
local index_end=$[8-$1]
local seq_number=`seq $index_start $index_increment $index_end`
local m=
local mask=
[ -n "$1" ] && mask="$1"
[ -z "$mask" ] && mask="192"

for i in $seq_number
do
     temp=$[$temp+2**$i]
    if [ $temp -ge $mask ]  ; then
   [  -z "$m" ] && m=$i;
   break;
  fi
done
echo "$m"
}



###
# 名字: nw_sub_bits_to_cidr
# 参数：掩码类型,子网位数
# 返回：掩码前缀
# 描述：已知子网位数，获取掩码前缀
###
function nw_sub_bits_to_cidr(){
  local res=
case $1 in
    "1"|"A")
     res=$2
    ;;
    "2"|"B")
    res=$(($2+8))
    ;;
    "3"|"C")
    res=$(($2+16))
    ;;
    "4"|"D")
    res=$(($2+24))
    ;;
esac
echo "$res"
}

###
# 名字: nw_sub_cidr_to_bits
# 参数：掩码类型,子网前缀
# 返回：子网位数
# 描述：已知子网前缀，获取子网位数
###
function nw_sub_cidr_to_bits(){
  local res=
case $1 in
    "1"|"A")
     res=$2
    ;;
    "2"|"B")
    res=$(($2-8))
    ;;
    "3"|"C")
    res=$(($2-16))
    ;;
    "4"|"D")
    res=$(($2-24))
    ;;
esac
echo "$res"
}


###
# 名字: nw_sub_host_bits_to_num
# 参数：主机位数
# 返回：主机数量
# 描述：已知子网主机位数，获取主机数量
###
function nw_sub_host_bits_to_num(){
local res=
local count=
res=0
[ -n "$1" ] && count="$1"
[ $count -lt 0 ] && count="3"
res=$((2**$count-2))
[ $res -le 0 ] && res=0
echo "$res"
}


###
# 名字: nw_sub_host_num_to_bits
# 参数：主机数量
# 返回：主机位数
# 描述：已知子网主机数量，获取掩码前缀
###
function nw_sub_host_num_to_bits(){
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

###
# 名字: nw_sub_host_bits_to_cidr
# 参数：掩码类型，主机位数
# 返回：掩码前缀
# 描述：已知子网主机位数，获取掩码前缀
###
function nw_sub_host_bits_to_cidr(){
  local res=
case $1 in
    "1"|"A")
     res=$((8-$2))
    ;;
    "2"|"B")
    res=$((16-$2))
    ;;
    "3"|"C")
    res=$((24-$2))
    ;;
    "4"|"D")
    res=$((32-$2))
    ;;
esac
echo "$res"
}

###
# 名字: nw_sub_host_cidr_to_bits
# 参数：掩码前缀
# 返回：主机位数
# 描述：已知子网掩码前缀，获取主机位数
###
function nw_sub_host_cidr_to_bits(){
  local res=
  res=$((32-$2))
  echo "$res"
}

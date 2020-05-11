#!/bin/sh
declare -A mask_cidr_dic
mask_cidr_dic=()
function nw_mask_ini(){
  local mask=
  local cidr=
  for cidr in `seq 1 1 32`
  do
      mask=$(nw_mask_from_cidr "$cidr")
      nw_mask_add "$cidr" "$mask"
  done

}

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
# 名字: nw_mask_from_cidr
# 参数：掩码类型，掩码前缀
# 返回：子网掩码
# 描述：已知子网掩码前缀，获取子网掩码
###
function nw_mask_from_cidr(){
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
# 名字: nw_mask_to_cidr
# 参数：子网掩码
# 返回：掩码前缀
# 描述：已知子网子网掩码，获取掩码前缀
###
function nw_mask_to_cidr(){
  local key=
  local val=
  local mid=
  local res=

  [ -n "$1" ] && mid="$1"
  mid=$(echo "$mid" | sed "s/ //g"| sed "/^$/d")
for key in $(echo "${!mask_cidr_dic[*]}")
do
   val="${mask_cidr_dic[$key]}"
   if [ "$val" = "$mid" ] ; then
     res="$key"
     break
    fi
done
  echo "$res"
}
###
# 名字: nw_mask_get
# 参数：子网掩码
# 返回：
# 描述：获取子网掩码
###
function nw_mask_get(){
  local key=
  [ -n "$1" ] && key="$1"
  key=$(echo "$key" | sed "s/ //g"| sed "/^$/d")
  #[ -n "$key" ] && nw_mask_to_cidr "$key"
  [ -n "$key" ] && echo "${mask_cidr_dic[$key]}"
}
###
# 名字: nw_mask_add
# 参数：子网掩码
# 返回：
# 描述：添加子网掩码
###
function nw_mask_add(){
  local key=
  [ -n "$1" ] && key="$1"
  key=$(echo "$key" | sed "s/ //g"| sed "/^$/d")
  [ -n "$key" ] && mask_cidr_dic+=(["$key"]="$2")
}
###
# 名字: nw_mask_del
# 参数：子网掩码
# 返回：
# 描述：删除子网掩码
###
function nw_mask_del(){
  local key=
  [ -n "$1" ] && key="$1"
  key=$(echo "$key" | sed "s/ //g"| sed "/^$/d")
  [ -n "$key" ] && mask_cidr_dic+=(["$key"]="")
}
###
# 名字: nw_mask_is
# 参数：子网掩码
# 返回：true/false
# 描述：检查是否时子网掩码
###
function nw_mask_is(){
  local key=
  local val=
  local mid=
  local res=
  res="false"
  [ -n "$1" ] && mid="$1"
  mid=$(echo "$mid" | sed "s/ //g"| sed "/^$/d")
for key in $(echo "${!mask_cidr_dic[*]}")
do
   val="${mask_cidr_dic[$key]}"
   #echo "$key,$val"
   if [ "$val" = "$mid" ] ; then
    res="true"
    break
   fi
done
  echo "$res"
}
###
# 名字: nw_mask_type_is
# 参数：子网掩码
# 返回：A/B/C/D
# 描述：检查是否时子网掩码类型
###
function nw_mask_type_is(){
  local cidr=
  local mask=
  local res=
  [ -n "$1" ] && mask="$1"
  mask=$(echo "$mask" | sed "s/ //g"| sed "/^$/d")
  cidr=$(nw_mask_to_cidr "$mask")
  if [ $cidr -le 8 ] ; then
    res="A"
  elif [ $cidr -le 16 ] ; then
    res="B"
  elif [ $cidr -le 24 ] ; then
    res="C"
  elif [ $cidr -le 32 ] ; then
    res="D"
  fi
  echo "$res"
}

# main
nw_mask_ini

# file
# src/nw.mask.sh
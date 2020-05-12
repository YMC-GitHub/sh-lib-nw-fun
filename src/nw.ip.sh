#!/bin/sh

mod_require_2 "${PROJECT_PATH}/src/num-base-bc.sh"
mod_require_2 "${PROJECT_PATH}/src/str.sh"

declare -A nw_ip_dic
nw_ip_dic=()

###
# 名字: nw_ip_get
# 参数：网址
# 返回：
# 描述：获取网址
###
function nw_ip_get(){
  local key=
  [ -n "$1" ] && key="$1"
  key=$(echo "$key" | sed "s/ //g"| sed "/^$/d")
  #[ -n "$key" ] && nw_ip_to_cidr "$key"
  [ -n "$key" ] && echo "${nw_ip_dic[$key]}"
}
###
# 名字: nw_ip_add
# 参数：网址
# 返回：
# 描述：添加网址
###
function nw_ip_add(){
  local key=
  [ -n "$1" ] && key="$1"
  key=$(echo "$key" | sed "s/ //g"| sed "/^$/d")
  [ -n "$key" ] && nw_ip_dic+=(["$key"]="$2")
}
###
# 名字: nw_ip_del
# 参数：网址
# 返回：
# 描述：删除网址
###
function nw_ip_del(){
  local key=
  [ -n "$1" ] && key="$1"
  key=$(echo "$key" | sed "s/ //g"| sed "/^$/d")
  [ -n "$key" ] && nw_ip_dic+=(["$key"]="")
}
###
# 名字: nw_ip_is
# 参数：网址
# 返回：true/false
# 描述：检查是否是网址
###
function nw_ip_is(){
  local key=
  local val=
  local ip=
  local res=
  res="false"
  [ -n "$1" ] && ip="$1"
  ip=$(echo "$ip" | sed "s/ //g"| sed "/^$/d")
  #res=$(echo "$mid" | grep "[0-9]\{1,3\}[.][0-9]\{1,3\}[.][0-9]\{1,3\}[.][0-9]\{1,3\}")
  ip=$(echo "$ip" | grep '^\([1-9]\|[1-9][0-9]\|1[0-9][0-9]\|2[0-4][0-9]\|25[0-5]\)\(\.\([0-9]\|([1-9][0-9]\|1[0-9][0-9]\|2[0-4][0-9]\|25[0-5]\)\)\{3\}$')
  #https://www.cnblogs.com/opama/p/4314554.html
  [ $? -eq 0 ] && res="true"
  echo "$res"
}
###
# 名字: nw_ip_type_is
# 参数：网址
# 返回：A/B/C/D
# 描述：检查网址类型
###
function nw_ip_type_is(){
  local arr=
  local ip=
  local res=
  local head=
  [ -n "$1" ] && ip="$1"
  ip=$(echo "$ip" | sed "s/ //g"| sed "s/\./ /g"|sed "/^$/d")
  arr=(${ip//,/ })

  head=${arr[0]}
  if [[  $head -ge 1 &&  $head -le 127 ]] ; then
      res="A"
  elif  [[  $head -ge 128 &&  $head -le 191 ]] ; then
      res="B"
  elif  [[  $head -ge 192 &&  $head -le 223 ]] ; then
      res="C"
  elif  [[  $head -ge 224 &&  $head -le 239 ]] ; then
      res="D"
  elif  [[  $head -ge 240 &&  $head -le 255 ]] ; then
      res="E"
  fi
  echo "$res"
}

###
# 名字: nw_ip_private_is
# 参数：网址
# 返回：true/false
# 描述：检查网址类型是否是私有地址
###
function nw_ip_private_is(){
  local arr=
  local ip=
  local res=
  local head=
  [ -n "$1" ] && ip="$1"
  res="false"
  ip=$(echo "$ip" | sed "s/ //g"| sed "s/\./ /g"|sed "/^$/d")
  arr=(${ip//,/ })

  head="${arr[0]}"
  [ $head = "10" ] && res="true"
  [ $res != "true" ] &&  [ $head = "172" ] && [[  "${arr[1]}" -ge 16 &&  "${arr[1]}" -le 31 ]] && res="true"
  [ $res != "true" ] &&  [ $head = "192" ] && [ "${arr[1]}" = "168" ] && res="true"

  echo "$res"
}

###
# 名字: nw_ip_addr_broad_from_net
# 参数：网络地址，掩码类型，主机数量
# 返回：网址
# 描述：已知网络地址、网址类型、主机数量，获取广播地址
###
function nw_ip_addr_broad_from_net(){
  local arr=
  local ip=
  local res=
  local head=
  local mask_type=
  local host_num=
  [ -n "$1" ] && ip="$1"
  [ -n "$2" ] && mask_type="$2"
  [ -n "$3" ] && host_num="$3"

  res=
  ip=$(echo "$ip" | sed "s/ //g"| sed "s/\./ /g"|sed "/^$/d")
  arr=(${ip//,/ })
  b=$[$host_num+2-1]
  case $mask_type in
    "1"|"A")
     head=""
     res="{$b}.0.0.0"
    ;;
    "2"|"B")
     head="${arr[0]}."
     res="${head}{$b}.0.0"
    ;;
    "3"|"C")
     head="${arr[0]}.${arr[1]}."
     res="${head}{$b}.0"
    ;;
    "4"|"D")
     head="${arr[0]}.${arr[1]}.${arr[2]}."
     res="${head}{$b}"
    ;;
esac
  echo "$res"
}

###
# 名字: nw_ip_addr_net_from_host
# 参数：主机地址，子网掩码
# 返回：网络网址
# 描述：已知主机地址、子网掩码，获取网络网址
###
function nw_ip_addr_net_from_host(){
  local arr=
  local ip=
  local mask=
  local res=

  [ -n "$1" ] && ip="$1"
  [ -n "$2" ] && mask="$2"

  ip=$(echo "$ip" | sed "s/ //g"| sed "/^$/d")
  mask=$(echo "$mask" | sed "s/ //g"| sed "/^$/d")
  res=""
for index in {1..4}; do
    bi=$(echo $ip | cut -d "." -f $index)
    bm=$(echo $mask | cut -d "." -f $index)
    if [ $index -ne 1 ]
    then
        res="$res."
    fi
    #逻辑与
    res="$res$[$bi&$bm]"
done
echo $res
}


###
# 名字: nw_ip_addr_hostid
# 参数：主机地址，子网掩码
# 返回：主机编号
# 描述：已知主机地址、子网掩码，获取主机编号
###
function nw_ip_addr_hostid(){
  local arr=
  local ip=
  local mask=
  local res=

  [ -n "$1" ] && ip="$1"
  [ -n "$2" ] && mask="$2"

  ip=$(echo "$ip" | sed "s/ //g"| sed "/^$/d")
  mask=$(echo "$mask" | sed "s/ //g"| sed "/^$/d")
  res=""
for index in {1..4}; do
    bi=$(echo $ip | cut -d "." -f $index)
    bm=$(echo $mask | cut -d "." -f $index)
    if [ $index -ne 1 ]
    then
        res="$res."
    fi
    #按位非：取反码
    bm="$[~$bm]"
    #逻辑与
    res="$res$[$bi&$bm]"
done
echo $res
}


###
# 名字: nw_ip_format_to_bin
# 参数：主机地址
# 返回：网络网址
# 描述：已知主机地址，获取二进制形式
###
function nw_ip_format_to_bin(){
  local arr=
  local ip=
  local res=
  [ -n "$1" ] && ip="$1"
  ip=$(echo "$ip" | sed "s/ //g"| sed "/^$/d")
  res=""
for index in {1..4}; do
    bi=$(echo $ip | cut -d "." -f $index)
    if [ $index -ne 1 ]
    then
        res="$res."
    fi
    bi=$(num_base_bc_10_to_xx "$bi" "2")
    bi=$(str_fill "$bi" "8" "0")
    res="$res$bi"
done
echo $res
}

###
# 名字: nw_ip_addr_net_to_cidr
# 参数：网络网址
# 返回：子网前缀
# 描述：已知网络网址，获取子网前缀
###
function nw_ip_addr_net_to_cidr(){
  local arr=
  local ip=
  local res=
  local cidr=
  [ -n "$1" ] && ip="$1"
  ip=$(echo "$ip" | sed "s/ //g"| sed "/^$/d")

res=
for index in {1..4}; do
    t=$(echo $ip | cut -d "." -f $index)
    if [ $index -ne 1 ]
    then
        res="$res."
    fi
    t=$(num_base_bc_10_to_xx "$t" "2")
    t=$(str_fill "$t" "8" "0")
    res="$res$t"
done
res=$(echo $res | sed "s/\.//g")
cidr=$(str_last_index_of "res" "1")
[ -z $cidr ] && cidr=0
cidr=$[$cidr+1]
echo $cidr
}

# file
# src/nw.ip.sh
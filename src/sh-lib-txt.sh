#!/bin/sh

###
# txt.list.detail
###
function txt_list_detail(){
  local txt=
  [ -n "$1" ] && txt="$1"
  # delete sh line comment
  txt=$(echo "$txt" | sed "/^#/d" | sed "s/ #.*//g")
  # delete space line
  txt=$(echo "$txt" | sed "/^$/d")
  echo "$txt"
}

###
# txt.list.to-arr
###
function txt_list_to_arr(){
# repalce space to other char
  local arr_name=
  local spilt_char=
  local sh_code=

  local CHAR_NEW=
  local CHAR_OLD=
  local txt=
  CHAR_NEW=" "
  CHAR_OLD=$(echo " " | md5sum|cut -d" " -f1 |cut -b 1-16)

  [ -n "$1" ] && txt="$1"
  [ -n "$2" ] && arr_name="$2"
  [ -n "$3" ] && spilt_char="$3"
  arr_name=$(echo "$arr_name" | sed "s/ //g"| sed "/^$/d")
  [ -z "$arr_name" ] && arr_name="arr"
  spilt_char=$(echo "$spilt_char" | sed "s/ //g"| sed "/^$/d")
  [ -z "$spilt_char" ] && spilt_char=","

  txt=$(echo "$txt" | sed "s/$CHAR_NEW/$CHAR_OLD/g")
sh_code=$(cat <<EOF
  # to arr
  $arr_name=(\${txt//$spilt_char/ })
  for key in \${!$arr_name[@]}; do
    val=\${$arr_name[\$key]}
    val=$(echo "\$val" | sed "s/$CHAR_OLD/$CHAR_NEW/g")
    $arr_name[\$key]="\$val"
  done
EOF
)
#echo "$sh_code"
eval "$sh_code"
}

###
# txt.list.to-dic
###
# txt.list->txt.list.to-arr->txt.list.to-dic
function txt_list_to_dic(){
local arr_name=
local spilt_char=
local dic_name=
local sh_code=
[ -n "$1" ] && arr_name="$1"
[ -n "$2" ] && dic_name="$2"
[ -n "$3" ] && spilt_char="$3"

  arr_name=$(echo "$arr_name" | sed "s/ //g"| sed "/^$/d")
  [ -z "$arr_name" ] && arr_name="arr"
  dic_name=$(echo "$dic_name" | sed "s/ //g"| sed "/^$/d")
  [ -z "$dic_name" ] && dic_name="dic"
  [ -z "$spilt_char" ] && spilt_char="="
sh_code=$(cat <<EOF
for value in \${$arr_name[@]}; do
  if [[ "\$value" =~ "$spilt_char" ]]; then
    # get key
    key=\$(echo "\$value" | cut -d "=" -f1)
    # get val
    val=\$(echo "\$value" | cut -d "=" -f2)
    #echo "\$key"
    #echo "\$val"
    $dic_name+=(["\$key"]="\$val")
    #$dic_name["\$key"]="\$val"
  fi
done
EOF
)
#echo "$sh_code"
eval "$sh_code"
}
# declare -A dic
# txt_list_to_dic "arr" "dic"


function test(){
txt=$(
  cat <<EOF
网络地址=192.168.10.33
网络掩码=255.255.255.224
EOF
)

txt_list_detail "$txt"
txt_list_to_arr "$txt" "arr"
# val
echo "${arr[@]}"
echo "${arr[0]}"
# key
echo "${!arr[@]}"
# size
echo "${#arr[@]}"
#
declare -A dic
txt_list_to_dic "arr" "dic"
# val
echo "${dic[@]}"
echo "${dic["网络地址"]}"
# key
echo "${!dic[@]}"
# size
echo "${#dic[@]}"
}
#test


# file usage
# ./src/sh-lib-txt.sh

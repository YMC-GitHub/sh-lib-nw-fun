#!/bin/sh

mod_require_2 "${PROJECT_PATH}/src/txt.sh"
mod_require_2 "${PROJECT_PATH}/src/nw.mask.sh"
mod_require_2 "${PROJECT_PATH}/src/nw.cidr.sh"
mod_require_2 "${PROJECT_PATH}/src/nw.sub.sh"
mod_require_2 "${PROJECT_PATH}/src/nw.ip.sh"

declare -A nw_sub_know_dic
nw_sub_know_dic=()

function nw_sub_know_from_list(){
  local txt=
  txt="$1"
  txt=$(echo "$txt" | sed "/^#.*$/d"| sed "/^$/d")
  txt_list_to_arr "$txt" "arr"
  txt_list_to_dic "arr" "nw_sub_know_dic"
}
function nw_sub_know_set(){
  local key=
  [ -n "$1" ] && key="$1"
  key=$(echo "$key" | sed "s/ //g"| sed "/^$/d")
  [ -n "$key" ] && nw_sub_know_dic+=(["$key"]="$2")
}
function nw_sub_know_get(){
  local key=
  local val=

  [ -n "$1" ] && key="$1"
  key=$(echo "$key" | sed "s/ //g"| sed "/^$/d")
  if  [ -n "$key" ] ; then
    val="${nw_sub_know_dic[$key]}"
  fi
 echo "$val"
}
# src/nw.sub.know.sh
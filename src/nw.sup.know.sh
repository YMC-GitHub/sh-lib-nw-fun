#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source "$THIS_FILE_PATH/config.project.dir.map.sh"
source "$SRC_PATH/txt.sh"
source "$SRC_PATH/nw.mask.sh"
source "$SRC_PATH/nw.cidr.sh"
#source "$SRC_PATH/nw.sub.sh"
source "$SRC_PATH/nw.ip.sh"

declare -A nw_sup_know_dic
#nw_sup_know_dic=()

function nw_sup_know_from_list(){
  local txt=
  txt="$1"
  txt=$(echo "$txt" | sed "/^#.*$/d"| sed "/^$/d")
  txt_list_to_arr "$txt" "arr"
  txt_list_to_dic "arr" "nw_sup_know_dic"
}
function nw_sup_know_set(){
  local key=
  [ -n "$1" ] && key="$1"
  key=$(echo "$key" | sed "s/ //g"| sed "/^$/d")
  [ -n "$key" ] && nw_sup_know_dic+=(["$key"]="$2")
}
function nw_sup_know_get(){
  local key=
  local val=

  [ -n "$1" ] && key="$1"
  key=$(echo "$key" | sed "s/ //g"| sed "/^$/d")
  if  [ -n "$key" ] ; then
    val="${nw_sup_know_dic[$key]}"
  fi
 echo "$val"
}

# src/nw.sup.know.sh
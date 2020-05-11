#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
function num_base_bc_10_to_xx(){
  local decNumber=
  local base=
  local rem=
  local res=
  local dig_arr=
  decNumber=10
  base=2
  [ -n "$1" ] && decNumber="$1"
  [ -n "$2" ] && base="$2"
  dig_arr=(0 1 2 3 4 5 6 7 8 9 A B C D E F)
  rem=
  res=0
  while [ $decNumber -gt 0 ]
  do
      # 取余
      rem=$[$decNumber%$base]
      # 存储
      res="${rem}${res}"
      # 取商
      decNumber=$[$decNumber/$base]
  done
  echo "$res"
}
function num_base_bc_2_to_10(){
  local from=
  local res=
  [ -n "$1" ] && from="$1"
  ((res=2#$from));
  echo "$res"
}



#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source "$THIS_FILE_PATH/../../src/sh-lib-nw.mask.sh"

#echo "val:"
#echo "${mask_cidr_dic[*]}"
#echo "key:"
#echo "${!mask_cidr_dic[*]}"

function mask_print(){
val=
for cidr in `seq 1 1 32`
  do
      mask=$(nw_mask_get "$cidr")
      #mask=${mask_cidr_dic[$cidr]}
      val=$(cat<<EOF
$val
$cidr:$mask
EOF
)

  done
echo "$val" | sed "/^$/d"
}
mask_print

nw_mask_is "255.255.1.0"

nw_mask_is "255.255.255.252"

nw_mask_type_is "255.255.255.252"
nw_mask_type_is "255.255.252.0"
nw_mask_type_is "255.252.0.0"
nw_mask_type_is "252.0.0.0"
# file usage
# test/unit/nw.mask.sh
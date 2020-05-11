#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
THIS_FILE_NAME=$(basename $0)
#source "$THIS_FILE_PATH/config.project.dir.map.sh"
#source "$SRC_PATH/txt.sh"

source "$THIS_FILE_PATH/txt.sh"

txt=$(cat <<EOF
nw.cidr.sh
nw.mask.sh
nw.ip.sh
nw.sub.sh
nw.sub.know.sh
nw.sup.know.sh
EOF
)
txt_list_to_arr "$txt" "arr"

for file in $(echo "${arr[@]}")
do
    cat "src/${file}" | grep "function " | sed "s/function */- [x] /g"  | sed "s/(){//g"
done


#src/dev.api.sh
#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
THIS_FILE_NAME=$(basename $0)
#source "$THIS_FILE_PATH/config.project.dir.map.sh"
#source "$SRC_PATH/sh-lib-txt.sh"

source "$THIS_FILE_PATH/sh-lib-txt.sh"

txt=$(cat <<EOF
sh-lib-nw.cidr.sh
sh-lib-nw.mask.sh
sh-lib-nw.ip.sh
sh-lib-nw.sub.sh
sh-lib-nw.sub.know.sh
sh-lib-nw.sup.know.sh
EOF
)
txt_list_to_arr "$txt" "arr"

for file in $(echo "${arr[@]}")
do
    cat "src/${file}" | grep "function " | sed "s/function */- [x] /g"  | sed "s/(){//g"
done


#src/dev.api.sh
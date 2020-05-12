THIS_FILE_PATH=$(cd $(dirname $0);pwd)
THIS_FILE_NAME=$(basename $0)
[ -z "$RUN_SCRIPT_PATH" ] && RUN_SCRIPT_PATH=$(pwd)


PROJECT_PATH=$(cd "$THIS_FILE_PATH";cd "../" ;pwd)
source "${PROJECT_PATH}/sh_modules/project-dir-map.sh"
source "${PROJECT_PATH}/sh_modules/load-lib.sh"

#[ -z "$THIS_FILE_PATH" ] && THIS_FILE_PATH=$(this_file_path_get) ; project_dir_map_gen2 "../"

SH_MODULE_LOCAL="${PROJECT_PATH}/sh_modules"
SH_MODULE_GLOBAL="/d/code-store/shell"

#mod_require_2 "${PROJECT_PATH}/test/unit/nw.ip.sh"
#mod_require_2 "${PROJECT_PATH}/test/unit/nw.cc.sh"
#mod_require_2 "${PROJECT_PATH}/test/unit/nw.mask.sh"
mod_require_2 "${PROJECT_PATH}/test/unit/nw.sub.know.sh"
#mod_require_2 "${PROJECT_PATH}/test/unit/nw.sup.know.sh"
# test/index.sh
#!/bin/sh

mod_dic_name=load_lib_dic

# get cache dic var name by md5
[ -z "$hash" ] && hash=$(echo -n "$mod_dic_name"| md5sum | cut -d ' ' -f1 |cut -c 1-6 | grep "^[a-zA-Z]" )
# get cache dic var name by base64
[ -z "$hash" ] && hash=$(echo -n "$mod_dic_name"| base64 | cut -d ' ' -f1| cut -c 1-6 | grep "^[a-zA-Z]" )
# get cache dic var name by md5,base64
[ -z "$hash" ] && hash=$(echo -n "$mod_dic_name" | base64 | md5sum | cut -d ' ' -f1 | cut -c 1-6 | grep "^[a-zA-Z]" )
#[ -z "$hash" ] && echo "warn:$mod_dic_name 's name init fails!"
[ -z "$hash" ] && hash="dic$(date +'%Y%m%d%H%M%S')"
#echo "$hash"

#eval "declare -A $hash ; $hash=()"
declare -A db1e4d ; db1e4d=()

function mod_ini() {
  declare -A db1e4d ; db1e4d=()
}
function mod_map_out() {
  local key=
  local val=
  local res=
  for key in $(echo ${!db1e4d[*]}); do
    val=${db1e4d[$key]}
    res=$(cat<<EOF
$res
$key=$val
EOF
)
  done
  echo "$res" | sed "/^ *$/d"
}

function mod_map_get(){
  [ $1 ] && echo ${db1e4d[$1]}
}
# fun usage
# mod_map_get
# mod_map_get "CF_EMAIL"

function mod_map_set(){
  [ $1 ] && db1e4d+=(["$1"]="$2")
}
# fun usage
# mod_map_get
# mod_map_set "CF_EMAIL" "xx"

function mod_map_has(){
  local res=
  res="false"
  local val=
  [ $1 ] && val=${db1e4d[$1]}
  [ "$val" ] && res="true"
  echo "$res"
}
# fun usage
# mod_map_has

function mod_map_key_out(){
  echo ${!db1e4d[*]}
}
# fun usage
# mod_map_key_out

function mod_map_out_require(){
  local key=
  local val=
  local res=
  local val2=
  for key in $(echo ${!db1e4d[*]}); do
    val=${db1e4d[$key]}
    val2=$(echo "$key"| sed "s,$PROJECT_PATH/,,")
    res=$(cat<<EOF
$res
mod_require "\$PROJECT_PATH/$val2"
EOF
)
  done
  echo "$res" | sed "/^ *$/d"
}
# fun usage
# mod_map_out_require


function get_str_md5_hash(){
  # echo -n "xx" | md5sum | cut -d " " -f 1
  echo -n "$1" | md5sum | cut -d " " -f 1
}
# fun usage
# get_str_md5_hash "xx"

function mod_require(){
  local f_path=
  local f_hash=
  local obj=
  local c_has
  local obj=
  local key=
  f_path=$1
  f_hash=$(get_str_md5_hash "$f_path")

  key=$f_path
  obj="loaded=false;file=$f_path;hash=$f_hash"

  c_has=$(mod_map_has $f_path)
  #echo "$c_has"
  if [ _"$c_has" = _"true" ]
  then
      val=$(mod_map_get $f_path)
      #echo "$val"
      if [ _"$val" = _"" ]
      then
        # val is null or empty
          source $f_path ; obj="loaded=true;file=$f_path;hash=$f_hash" ; mod_map_set "$key" "$obj" ;
        else
        # val is not null and empty
          echo "$val" | grep "loaded=false;"
          [ $? -eq 0 ] && { source $key; val=$(echo "$val" |sed "s/loaded=false;/loaded=true;/") ; mod_map_set "$key" "$val" ;}
      fi
  else
      source $f_path ; obj="loaded=true;file=$f_path;hash=$f_hash" ; mod_map_set "$key" "$obj" ;
  fi
}
# fun usage
# mod_require "xx"

function mod_require_once(){
  local f_path=
  local f_hash=
  local obj=
  local c_has
  local obj=
  local key=
  f_path=$1
  f_hash=$(get_str_md5_hash "$f_path")

  key=$f_path
  obj="loaded=false;file=$f_path;hash=$f_hash"

  c_has=$(mod_map_has $f_path)
  #echo "$c_has"
  if [ _"$c_has" = _"true" ]
  then
      val=$(mod_map_get $f_path)
      #echo "$val"
      if [ _"$val" = _"" ]
      then
        # val is null or empty
          source $f_path ; obj="loaded=true;file=$f_path;hash=$f_hash" ; mod_map_set "$key" "$obj" ;
        else
        # val is not null and empty
          echo "$val" | grep "loaded=false;"
          [ $? -eq 0 ] && { source $key; val=$(echo "$val" |sed "s/loaded=false;/loaded=true;/") ; mod_map_set "$key" "$val" ;}
      fi
  else
      source $f_path ; obj="loaded=true;file=$f_path;hash=$f_hash" ; mod_map_set "$key" "$obj" ;
  fi
}
# fun usage
# mod_require_once "xx"


function mod_require_more(){
  local f_path=
  local f_hash=
  local obj=
  local c_has
  local obj=
  local key=
  f_path=$1
  f_hash=$(get_str_md5_hash "$f_path")

  key=$f_path
  obj="loaded=false;file=$f_path;hash=$f_hash"
  source $f_path ; obj="loaded=true;file=$f_path;hash=$f_hash" ; mod_map_set "$key" "$obj" ;

}
# fun usage
# mod_require_more "xx"

function mod_require_only(){
  # need to run mod_load
  # code cc:
  # for key in $(echo ${!db1e4d[*]}) ; do if [ -e $key ] ; then . "$key"; fi; done
  # code dd: load absolute path ,load relative to SH_MODULE_LOCAL path or SH_MODULE_GLOBAL path
  # for key in $(echo ${!db1e4d[*]}) ; do obj="loaded=true;file=$f_path;hash=$f_hash" ; isLoaded=false ; [[ _"$key" =~ _"/" ]] && [ -e $key ] &&  { . "$key" ;  mod_map_set "$key" "$obj" ; isLoaded=true; } ; [ "$SH_MODULE_LOCAL" ] && [ _"$isLoaded" = _"false" ] && f_path="$SH_MODULE_LOCAL/$key" && [ -e $f_path ] &&  { . "$f_path" ; mod_map_set "$key" "$obj" ; isLoaded=true; } ;[ "$SH_MODULE_GLOBAL" ] && [ _"$isLoaded" = _"false" ] && f_path="$SH_MODULE_GLOBAL/$key" && [ -e $f_path ] &&  { . "$f_path" ; mod_map_set "$key" "$obj" ; isLoaded=true; } ; done

  # code xx: load absolute path ,load relative to SH_MODULE_LOCAL path or SH_MODULE_GLOBAL path
  # for key in $(echo ${!db1e4d[*]}) ; do f_path=$key; f_hash=$(get_str_md5_hash "$f_path") ; obj="loaded=true;file=$f_path;hash=$f_hash" ; isLoaded=false ; [[ _"$key" =~ _"/" ]] && [ -e $key ] &&  { . "$key" ;  mod_map_set "$key" "$obj" ; isLoaded=true; } ; [ "$SH_MODULE_LOCAL" ] && [ _"$isLoaded" = _"false" ] && f_path="$SH_MODULE_LOCAL/$key" && [ -e $f_path ] &&  { . "$f_path" ; mod_map_set "$key" "$obj" ; isLoaded=true; } ;[ "$SH_MODULE_GLOBAL" ] && [ _"$isLoaded" = _"false" ] && f_path="$SH_MODULE_GLOBAL/$key" && [ -e $f_path ] &&  { . "$f_path" ; mod_map_set "$key" "$obj" ; isLoaded=true; } ; done
  # code uu:
  # for key in $(echo ${!db1e4d[*]}) ; do f_path=$key; f_hash=$(get_str_md5_hash "$f_path") ; obj="loaded=true;file=$f_path;hash=$f_hash" ; isLoaded=false ; [[ _"$key" =~ _"/" ]] && [ -e $key ] &&  { . "$key" ;  mod_map_set "$key" "$obj" ; isLoaded=true; } ; [ "$SH_MODULE_LOCAL" ] && [ _"$isLoaded" = _"false" ] && f_path="$SH_MODULE_LOCAL/$key" && [ -e $f_path ] &&  { . "$f_path" ; mod_map_set "$key" "$obj" ; isLoaded=true; } ;[ "$SH_MODULE_GLOBAL" ] && [ _"$isLoaded" = _"false" ] && f_path="$SH_MODULE_GLOBAL/$key" && [ -e $f_path ] &&  { . "$f_path" ; mod_map_set "$key" "$obj" ; isLoaded=true; } ; [ _"$isLoaded" = _"false" ] &&  echo "${key} does not exsits." ; done


  local f_path=
  local f_hash=
  local obj=
  local c_has
  local obj=
  local key=
  f_path=$1
  f_hash=$(get_str_md5_hash "$f_path")

  key=$f_path
  #obj="loaded=false;file=$f_path;hash=$f_hash"
  c_has=$(mod_map_has $f_path)
  if [ _"$c_has" != _"true" ]
  then
      #source $f_path ; obj="loaded=true;file=$f_path;hash=$f_hash" ; mod_map_set "$key" "$obj" ;
      obj="loaded=false;file=$f_path;hash=$f_hash" ; mod_map_set "$key" "$obj" ;
  fi
}
# fun usage
# mod_require_only "xx"

function mod_load(){
  local c_has=
  local key=
  local c_val=
  key=$1
  c_has=$(mod_map_has $key)
  if [ _"$c_has" = _"true" ]
  then
      c_val=$(mod_map_get $key)
      if [ _"$c_val" != _"" ]
      then
          echo "$c_val" | grep "loaded=false;"
          [ $? -eq 0 ] && { source $key; c_val=$(echo "$c_val" |sed "s/loaded=false;/loaded=true;/") ; mod_map_set "$key" "$c_val" ;}
      fi
  fi
}
# fun usage
# mod_load


function mod_require_2(){
  local key= ; key=$1 ;
  local c_key= ;
  local c_val= ;
  local isLoaded=false ;

  # has key?
  c_key=$(mod_map_has $key) ;

  [ _"$c_key" = _"true" ] && {
    c_val=$(mod_map_get $key) ;
    # is loaded ?
    echo "$c_val" | grep "loaded=true;" >/dev/null 2>&1 ; [ $? -eq 0 ] && isLoaded=true ;
  }
  #echo "$isLoaded --- $c_val--$c_key--$key"


  f_path=$key;
  # step-x: hash get with file path
  f_hash=$(get_str_md5_hash "$f_path") ;
  # step-x: obj def
  obj="loaded=true;file=$f_path;hash=$f_hash" ;
  # step-x: lib source for abs path
  [[ _"$key" =~ _"/" ]] && [ _"$isLoaded" = _"false" ] && [ -e $key ] &&  { . "$key" ;  mod_map_set "$key" "$obj" ; isLoaded=true; } ;
  # step-x: lib source for rel path and  SH_MODULE_LOCAL
  [ "$SH_MODULE_LOCAL" ] && [ _"$isLoaded" = _"false" ] && f_path="$SH_MODULE_LOCAL/$key" && [ -e $f_path ] &&  { . "$f_path" ; mod_map_set "$key" "$obj" ; isLoaded=true; } ;
  # step-x: lib source for rel path and  SH_MODULE_GLOBAL
  [ "$SH_MODULE_GLOBAL" ] && [ _"$isLoaded" = _"false" ] && f_path="$SH_MODULE_GLOBAL/$key" && [ -e $f_path ] &&  { . "$f_path" ; mod_map_set "$key" "$obj" ; isLoaded=true; } ;
  # step-x: lib source for other
  [ _"$isLoaded" = _"false" ] &&  echo "${key} does not exsits." ;
}
# fun usage
# mod_require_2


function mod_require_3(){
  local key= ; key=$1 ;
  local c_key= ;
  local c_val= ;
  local isLoaded=false ;

  # has key?
  c_key=$(mod_map_has $key) ;

  [ _"$c_key" = _"true" ] && {
    c_val=$(mod_map_get $key) ;
    # is loaded ?
    echo "$c_val" | grep "loaded=true;" >/dev/null 2>&1 ; [ $? -eq 0 ] && isLoaded=true ;
  }
  #echo "$isLoaded --- $c_val--$c_key--$key"


  f_path=$key;
  # step-x: hash get with file path
  f_hash=$(get_str_md5_hash "$f_path") ;
  # step-x: obj def
  obj="loaded=true;file=$f_path;hash=$f_hash" ;
  # step-x: lib source for abs path
  [[ _"$key" =~ _"/" ]] && [ _"$isLoaded" = _"false" ] && [ -e $key ] &&  { . "$key" ;  mod_map_set "$key" "$obj" ; isLoaded=true; } ;

  # step-x: lib source for rel path eg:"./"
  [ _"$isLoaded" = _"false" ] && [ -e $f_path ] &&  { . "$f_path" ; mod_map_set "$key" "$obj" ; isLoaded=true; } ;

  # step-x: lib source for rel path and  SH_MODULE_LOCAL
  [ "$SH_MODULE_LOCAL" ] && [ _"$isLoaded" = _"false" ] && f_path="$SH_MODULE_LOCAL/$key" && [ -e $f_path ] &&  { . "$f_path" ; mod_map_set "$key" "$obj" ; isLoaded=true; } ;

  # step-x: lib source for rel path and  SH_MODULE_GLOBAL
  [ "$SH_MODULE_GLOBAL" ] && [ _"$isLoaded" = _"false" ] && f_path="$SH_MODULE_GLOBAL/$key" && [ -e $f_path ] &&  { . "$f_path" ; mod_map_set "$key" "$obj" ; isLoaded=true; } ;

  # step-x: lib source for other
  [ _"$isLoaded" = _"false" ] &&  echo "${key} does not exsits." ;
}
# fun usage
# mod_require_3

function mod_load_auto(){
  for key in $(echo ${!db1e4d[*]}) ; do f_path=$key; f_hash=$(get_str_md5_hash "$f_path") ; obj="loaded=true;file=$f_path;hash=$f_hash" ; isLoaded=false ; [[ _"$key" =~ _"/" ]] && [ -e $key ] &&  { . "$key" ;  mod_map_set "$key" "$obj" ; isLoaded=true; } ; [ "$SH_MODULE_LOCAL" ] && [ _"$isLoaded" = _"false" ] && f_path="$SH_MODULE_LOCAL/$key" && [ -e $f_path ] &&  { . "$f_path" ; mod_map_set "$key" "$obj" ; isLoaded=true; } ;[ "$SH_MODULE_GLOBAL" ] && [ _"$isLoaded" = _"false" ] && f_path="$SH_MODULE_GLOBAL/$key" && [ -e $f_path ] &&  { . "$f_path" ; mod_map_set "$key" "$obj" ; isLoaded=true; } ; [ _"$isLoaded" = _"false" ] &&  echo "${key} does not exsits." ; done
}
# fun usage
# mod_load_auto

function mod_load_auto_2(){
  local item= ; for item in $(echo ${!db1e4d[*]}) ; do mod_require_2 "$item" ; done
}
# fun usage
# mod_load_auto

#for key in $(echo ${!db1e4d[*]}) ; do val=${db1e4d[$key]}; if [ -e $key ] ; then . $key ; else echo "${key} does not exsits." fi; done

# file usage
# ./src/index.sh

#!/bin/sh

str=
${c93bae:- $str}
#echo -n 'cache_str' | base64 | md5sum | cut -d ' ' -f1 | cut -c 2-7

###
# 名字: str_set
# 参数：字符名字，字符取值
# 返回：字符取值
# 描述： 创造字符
###
function str_set() {
  local str_val=
  local str_key=
  local shCode=
  str_val="null"
  str_key="c93bae"
  [ -n "$1" ] && str_key="$1"
  [ -n "$2" ] && str_val="$2"
  shCode=$(
    cat <<EOF
#\${$str_key:- "$str_val"}
$str_key="$str_val"
echo "\$$str_key"
EOF
  )
  #echo "$shCode"
  eval "$shCode"
}

###
# 名字: str_length
# 参数：字符名字
# 返回：字符长度
# 描述： 读取字符
###
function str_length() {
  local str_key=
  local shCode=
  str_key="c93bae"
  if [ -n "$1" ]; then
    str_key="$1"
  fi
  shCode=$(
    cat <<EOF
echo \${#$str_key}
EOF
  )
  #echo "$shCode"
  eval "$shCode"
}

function str_index_of() {
  local str_key=
  local shCode=
  local str_sub=
  str_key="c93bae"
  if [ -n "$1" ]; then
    str_key="$1"
  fi
  if [ -n "$2" ]; then
    str_sub="$2"
  fi
  shCode=$(
    cat <<EOF
local x=
x="\${$str_key%%$str_sub*}"
[[ \$x = \$$str_key ]] && echo -1 || echo \${#x}
# use awk
#awk -v a="\$$str_key" -v b="\$$str_sub" 'BEGIN{print index(a,b)}'
EOF
  )
  #echo "$shCode"
  eval "$shCode"

  : <<note
  a="The cat sat on the mat"
  sub="cat"
  # use awk
  #awk -v a="$a" -v b="$sub" 'BEGIN{print index(a,b)}'
  # use grep + sed
  echo $a | grep -bo "$sub" | sed 's/:.*$//'
  # use str delete
  x="${a%%$sub*}"
  [[ $x = $a ]] && echo -1 || echo ${#x}
  # use grep + awk
  echo $a | grep -b -o "$sub" | awk 'BEGIN {FS=":"}{print $1}'
  # use grep + cut
  echo $a | grep -b -o "$sub" | cut -d: -f1
note
}
function str_last_index_of() {
  local str_key=
  local shCode=
  local str_sub=
  str_key="c93bae"
  if [ -n "$1" ]; then
    str_key="$1"
  fi
  if [ -n "$2" ]; then
    str_sub="$2"
  fi
  shCode=$(
    cat <<EOF
local len=
local str=
str=\$(echo "\$$str_key" | sed 's/\(.*$str_sub\)\(.*\)/\1/')
# set index to 0
len=\${#str}
len=\$((\$len - 1 ))
echo \$len
EOF
  )
  #echo "$shCode"
  eval "$shCode"

}
###
# 名字: str_replace
# 参数：字符名字,旧的字符，新的字符
# 返回：字符内容
# 描述： 更改字符-替换
###
function str_replace() {
  local str_key=
  local shCode=
  local str_old=
  local str_new=
  local rep_mode=
  str_old=
  str_new=
  rep_mode=
  str_key="c93bae"
  if [ -n "$1" ]; then
    str_key="$1"
  fi
  if [ -n "$2" ]; then
    str_old="$2"
  fi
  if [ -n "$3" ]; then
    str_new="$3"
  fi
  if [ -n "$4" ]; then
    rep_mode="$4"
  fi
  shCode=$(
    cat <<EOF
$str_key=\$(echo "\$$str_key" | sed "s/$str_old/$str_new/$rep_mode")
echo "\$$str_key"
EOF
  )
  #echo "$shCode"
  eval "$shCode"
}
###
# 名字: str_split
# 参数：字符名字,分割符号，数组名字
# 返回：数组取值
# 描述： 读取字符
###
function str_split() {
  local split=
  local str_key=
  local shCode=
  str_key="c93bae"
  arr_key="c93bae_split"
  split=","
  if [ -n "$1" ]; then
    str_key="$1"
  fi
  if [ -n "$2" ]; then
    split="$2"
  fi
  if [ -n "$3" ]; then
    arr_key="$3"
  fi
  shCode=$(
    cat <<EOF
$arr_key=(\${$str_key//$split/ })
echo "\${$arr_key[*]}"
EOF
  )
  #echo "$shCode"
  eval "$shCode"
}

###
# 名字: str_char_at
# 参数：字符名字,指定位置,字符名字
# 返回：字符取值
# 描述： 读取字符
###
function str_char_at() {
  local str_key=
  local str_key2=
  local shCode=
  local s=
  local e=
  str_key="c93bae"
  str_key2="c93bae_char_at"
  s=0
  e=1
  if [ -n "$1" ]; then
    str_key="$1"
  fi
  if [ -n "$2" ]; then
    s="$2"
  fi
  if [ -n "$3" ]; then
    str_key2="$3"
  fi
  shCode=$(
    cat <<EOF
local len
local start=
len=\${#$str_key}
start=$s
# for setting start index to 1,not 0
#if [ \$start -gt 0 ]; then
#    start=\$(($s - 1 ))
#fi
if [ \$start -lt 0 ]; then
    start=0
fi
if [ -n "$e" ]; then
    len="$e"
fi
$str_key2="\${$str_key:\$start:\$len}"
echo "\$$str_key2"
EOF
  )
  #echo "$shCode"
  eval "$shCode"
}

###
# 名字: str_charcode_at
# 参数：字符名字,指定位置,字符名字
# 返回：字符ascii取值
# 描述： 读取字符-ascii取值
###
function str_charcode_at() {
  local str_key=
  local str_key2=
  local shCode=
  local s=
  local e=
  str_key="c93bae"
  str_key2="c93bae_charcode_at"
  s=0
  e=1
  if [ -n "$1" ]; then
    str_key="$1"
  fi
  if [ -n "$2" ]; then
    s="$2"
  fi
  if [ -n "$3" ]; then
    str_key2="$3"
  fi
  shCode=$(
    cat <<EOF
local len
local start=
len=\${#$str_key}
start=$s
# for setting start index to 1,not 0
#if [ \$start -gt 0 ]; then
#    start=\$(($s - 1 ))
#fi
if [ \$start -lt 0 ]; then
    start=0
fi
if [ -n "$e" ]; then
    len="$e"
fi
$str_key2="\${$str_key:\$start:\$len}"

$str_key2="\${$str_key:\$start:\$len}"
$str_key2=\$(echo "\$$str_key2"| tr -d "\n" | od -An -t dC)
#$str_key2=\${$str_key2##  }
#$str_key2=\${$str_key2%%  }
$str_key2=\$(echo "\$$str_key2" | sed "s/^ *//g"| sed "s/ *$//g")
echo "\$$str_key2"
EOF
  )
  #echo "$shCode"
  eval "$shCode"
}
###
# 名字: str_unicode_at
# 参数：字符名字,指定位置,字符名字
# 返回：字符unicode取值
# 描述： 读取字符-unicode取值
###
function str_unicode_at() {
  local str_key=
  local str_key2=
  local shCode=
  local s=
  local e=
  str_key="c93bae"
  str_key2="c93bae_unicode_at"
  s=0
  e=1
  if [ -n "$1" ]; then
    str_key="$1"
  fi
  if [ -n "$2" ]; then
    s="$2"
  fi
  if [ -n "$3" ]; then
    str_key2="$3"
  fi
  shCode=$(
    cat <<EOF
local len
local start=
len=\${#$str_key}
start=$s
# for setting start index to 1,not 0
#if [ \$start -gt 0 ]; then
#    start=\$(($s - 1 ))
#fi
if [ \$start -lt 0 ]; then
    start=0
fi
if [ -n "$e" ]; then
    len="$e"
fi
$str_key2="\${$str_key:\$start:\$len}"
$str_key2=\$(echo "\$$str_key2" |
  iconv -f UTF-8 -t UTF-16BE |
  xxd -p |
  sed 's/..../\\\\\\\\u&/g')
echo "\$$str_key2"
EOF
  )
  #echo "$shCode"
  eval "$shCode"
}

###
# 名字: str_charcode_at
# 参数：字符名字,ascii
# 返回：字符取值
# 描述： 生成字符
###
function str_from_charcode() {
  local str_key=
  local shCode=
  local charcode=
  str_key="c93bae_from_charcode"
  charcode=97
  if [ -n "$1" ]; then
    str_key="$1"
  fi
  if [ -n "$2" ]; then
    charcode="$2"
  fi
  shCode=$(
    cat <<EOF
local t
t=\$(printf "%x" $charcode)
printf "\\\\x\$t\\\n"
EOF
  )
  #echo "A"| tr -d "\n" | od -An -t dC
  #echo "a" | tr -d "\n" | od -An -t dC
  #echo "y" | tr -d "\n" | od -An -t dC
  #echo "$shCode"
  eval "$shCode"
}
###
# 名字: str_from_unicode
# 参数：字符名字,unicode
# 返回：字符取值
# 描述： 生成字符
###
function str_from_unicode() {
  local str_key=
  local shCode=
  local charcode=
  str_key="c93bae_from_unicode"
  unicode="\u000a"
  [ -n "$1" ] && str_key="$1"
  [ -n "$2" ] && unicode="$2"
  shCode=$(
    cat <<EOF
local t=
#echo "$unicode" |sed "s/u/\\\\\u/g"
t=\$(echo "$unicode" )
t=\$(echo "$t" |sed "s/u/\\\\\\\u/g")
echo -e "\$t"
EOF
  )
  #echo "$shCode"
  eval "$shCode"
}

#echo  "12 to hex is $((16#12))"
#echo -n -e "\x5a"
# 16 to 10
#echo "F to 10 is $((16#F))"
# 8 to 10
# echo $((8#11))
# 2 to 10
# echo $((2#111))
# 10 to 16
#printf %x 15
# 10 to 8
#printf %o 9

function str_match() {
  echo "$1"
}
function str_slice() {
  local str_key=
  local str_key2=
  local shCode=
  local s=
  local e=
  str_key="c93bae"
  str_key2="c93bae_slice"
  s=0
  e=
  if [ -n "$1" ]; then
    str_key="$1"
  fi
  if [ -n "$2" ]; then
    s="$2"
  fi
  if [ -n "$3" ]; then
    e="$3"
  fi
  if [ -n "$4" ]; then
    str_key2="$4"
  fi
  shCode=$(
    cat <<EOF
local len
local start=
len=\${#$str_key}
start=$s
# for setting start index to 1,not 0
#if [ \$start -gt 0 ]; then
#    start=\$(($s - 1 ))
#fi
if [ \$start -lt 0 ]; then
    start=0
fi
if [ -n "$e" ]; then
    len="$e"
fi
$str_key2="\${$str_key:\$start:\$len}"
echo "\$$str_key2"
EOF
  )
  #echo "$shCode"
  eval "$shCode"

}
function str_substring() {
  echo "$1"
}
function str_substr() {
  echo "$1"
}
function str_trim() {
  local str_key=
  local shCode=
  str_key="c93bae"
  if [ -n "$1" ]; then
    str_key="$1"
  fi
  shCode=$(
    cat <<EOF
#$str_key=\${$str_key%%}
#$str_key=\${$str_key##}
#echo "\$$str_key"
#or
$str_key=\$(echo "\$$str_key" | sed "s/^ *//g"| sed "s/ *$//g")
echo "\$$str_key"
EOF
  )
  #echo "$shCode"
  eval "$shCode"
}
###
# 名字: str_eq
# 参数：字符取值,字符取值
# 返回：true/false
# 描述：比较字符，字符相等？
###
function str_eq() {
  local a=
  local b=
  [ -n "$1" ] && a="$1"
  [ -n "$2" ] && b="$2"

  if [ "$a" = "$b" ]; then
    echo "true"
  else
    echo "false"
  fi
}
###
# 名字: str_fill
# 参数：字符取值,填充长度,填充字符,是否变量,填充类型
# 返回：字符
# 描述：创建字符，填充字符？
# 注：第四个参数表示第一个参数是字符变量还是字符取值
###
function str_fill() {
  local res=
  local fill=
  local max=
  local IS_VAR=
  local t= # without this, t is global
  local typ=
  max=8
  fill="0"
  typ=""
  [ -n "$1" ] && res="$1"
  [ -n "$2" ] && max="$2"
  [ -n "$3" ] && fill="$3"
  [ -n "$4" ] && IS_VAR="$4"
  [ -n "$IS_VAR" ] && eval "res=\$$res" # && echo "$res"
  [ -n "$5" ] && typ="$5"

  len=${#res} && while [ "$max" -gt "$len" ] ; do t="$fill$t";max=$[$max-1]; done
  if [[ ! "$typ" =~ "suffix" ]] ; then echo "$t$res"; else echo "$res$t" ; fi

}

# file usage
# ./index.sh
# ./src/sh-lib-str.sh

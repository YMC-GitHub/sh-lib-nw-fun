#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source "$THIS_FILE_PATH/sh-lib-nw.cc.sh"


echo "#debug-已知子网数量，获子网位数:"
for i in `seq 1 8`
do
  x=$((2**$i))
  r=$(ip_get_sub_pos_count "$x")
  echo "m=$x => $r"
done

echo "#debug-已知子网位数，获子网数量:"
for i in `seq 1 8`
do
  r=$(ip_get_sub_count "$i")
  echo "m=$i => $r"
done

echo "#debug-已知子网位数，获子网掩码:"
for i in `seq 1 8`
do
  r=$(ip_get_sub_mask_by_sub_pos_count "$i")
  echo "m=$i => $r"
done


echo "#debug-已知子网位数、网址类型，获掩码前缀:"
:<<YMC-NOTE
for i in `seq 1 4`
do
  r=$(ip_get_cidr_by_sub "$i" 5)
  echo "m=5,t=$i => $r"
done
YMC-NOTE
for i in `seq 1 4`
do
  for j in `seq 1 8`
  do
    r=$(ip_get_cidr_by_sub "$i" "$j")
    echo "m=$j,t=$i => $r"
  done
done

echo "#debug-已知子网主机数量，获主机位数:"
for i in `seq 2 8`
do
  x=$((2**$i-2))
  r=$(ip_get_sub_hos_pos_count "$x")
  echo "m=$x => $r"
done

echo "#debug-已知子网主机位数、网址类型，获掩码前缀:"
:<<YMC-NOTE
for i in `seq 1 4`
do
  r=$(ip_get_cidr_by_sub_hos "$i" 3)
  echo "m=3,t=$i => $r"
done
YMC-NOTE

for i in `seq 1 4`
do
  for j in `seq 1 8`
  do
    r=$(ip_get_cidr_by_sub_hos "$i" "$j")
    echo "m=$j,t=$i => $r"
  done
done

echo "#debug-已知子网主机位数，获主机数量:"
for i in `seq 1 8`
do
  r=$(ip_get_sub_hos_count "$i")
  echo "m=$i => $r"
done

echo "#debug-已知子网掩码前缀，获子网掩码:"
for i in `seq 1 32`
do
  r=$(ip_get_mask_by_cidr "$i")
  echo "m=$i => $r"
done


# nw_type_a
# 网络地址
# 广播地址
# 子网掩码
# 掩码前缀
#
# 网址范围
echo "#debug-网址范围:"
arr=(128 192 224 240 255)
res=$(cat <<EOF
a:1.0.0.0-$((${arr[0]}-1)).255.255.255
b:${arr[0]}.0.0.0-$((${arr[1]}-1)).255.255.255
c:${arr[1]}.0.0.0-$((${arr[2]}-1)).255.255.255
d:${arr[2]}.0.0.0-$((${arr[3]}-1)).255.255.255
e:${arr[3]}.0.0.0-${arr[4]}.255.255.255
EOF
)
echo "$res"

# 特殊网址
echo "#debug-特殊网址:"
res=$(cat <<EOF
当前主机：0.0.0.0
广播地址：
回环地址：127.x.x.x
EOF
)
echo "$res"

# 私有网址
echo "#debug-私有网址:"
res=$(cat <<EOF
a:10.0.0.0-10.255.255.255
b:172.16.0.0-172.31.255.255
c:192.168.0.0-192.168.255.255
EOF
)
echo "$res"

echo "#debug-子网划分:"
echo "#debug-已知网络地址、子网掩码，划分子网:"
res=$(cat <<EOF
网址类型：
子网数量：
主机数量：
EOF
)
echo "$res"

echo "#debug-已知网络地址、子网数量、主机数量，划分子网:"
res=$(cat <<EOF
网址类型：
子网掩码：
EOF
)
echo "$res"

echo "#debug-超网划分:"
echo "#debug-已知子网地址、子网数量、主机数量，超网划分::"
res=$(cat <<EOF
子网掩码：
EOF
)
echo "$res"

# src/test.sh-lib-nw.cc.sh
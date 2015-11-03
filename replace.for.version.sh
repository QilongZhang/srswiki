#!/bin/bash

uname -s |grep "Darwin" >/dev/null 2>&1
if [[ 0 -ne $? ]]; then
    echo "only support OSX"
    exit 1
fi
echo "OS ok."

# for v2 wikis, replace v1 to exists v2.
from="v1"
to="v2"
files=`ls ${to}_*`
exists=`ls ${to}_*|awk -F 'N_' '{print $2}'|awk -F '.md' '{print $1}'`
for file in $files; do
    echo "process file $file from $from to $to"
    for exist in $exists; do
        #echo "for $file, replace $from to $to on $exist"
        sed -i '' "s/${from}_CN_${exist}/${to}_CN_${exist}/g" $file
    done
done
exit 0
files=`ls v2*`
keys=`ls v2*|awk -F '_' '{print $3}'|awk -F '.' '{print $1}'`
for file in $files; do for key in $keys; do sed -i '' "s/v1_EN_$key/v2_EN_$key/g" $file; done done
for file in $files; do for key in $keys; do sed -i '' "s/v1_CN_$key/v2_CN_$key/g" $file; done done
echo "update the v1 to v2 wiki for v2 ok."

# v1 => v2, for v3
files=`ls v2*`
keys=`ls v3*|awk -F '_' '{print $3}'|awk -F '.' '{print $1}'`
for file in $files; do for key in $keys; do sed -i '' "s/v1_EN_$key/v2_EN_$key/g" $file; done done
for file in $files; do for key in $keys; do sed -i '' "s/v1_CN_$key/v2_CN_$key/g" $file; done done
echo "update the v1 to v2 wiki for v3 ok."

# v1 => v3, for v3
files=`ls v3*`
keys=`ls v3*|awk -F '_' '{print $3}'|awk -F '.' '{print $1}'`
for file in $files; do for key in $keys; do sed -i '' "s/v1_EN_$key/v3_EN_$key/g" $file; done done
for file in $files; do for key in $keys; do sed -i '' "s/v1_CN_$key/v3_CN_$key/g" $file; done done
echo "update the v1 to v3 wiki for v3 ok."

# v2 => v3, for v3
for file in $files; do for key in $keys; do sed -i '' "s/v2_EN_$key/v3_EN_$key/g" $file; done done
for file in $files; do for key in $keys; do sed -i '' "s/v2_CN_$key/v3_CN_$key/g" $file; done done
echo "update the v2 to v3 wiki for v3 ok."

echo "ok"

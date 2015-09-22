#!/bin/bash

uname -s |grep "Darwin" >/dev/null 2>&1
if [[ 0 -ne $? ]]; then
    echo "only support OSX"
    exit 1
fi
echo "OS ok."

files=`ls v2*`
keys=`ls v2*|awk -F '_' '{print $3}'|awk -F '.' '{print $1}'`
for file in $files; do for key in $keys; do sed -i '' "s/v1_EN_$key/v2_EN_$key/g" $file; done done
for file in $files; do for key in $keys; do sed -i '' "s/v1_CN_$key/v2_CN_$key/g" $file; done done
echo "update the v1 to v2 wiki ok."

files=`ls v3*`
keys=`ls v3*|awk -F '_' '{print $3}'|awk -F '.' '{print $1}'`
for file in $files; do for key in $keys; do sed -i '' "s/v1_EN_$key/v3_EN_$key/g" $file; done done
for file in $files; do for key in $keys; do sed -i '' "s/v1_CN_$key/v3_CN_$key/g" $file; done done
echo "update the v1 to v3 wiki ok."

for file in $files; do for key in $keys; do sed -i '' "s/v2_EN_$key/v3_EN_$key/g" $file; done done
for file in $files; do for key in $keys; do sed -i '' "s/v2_CN_$key/v3_CN_$key/g" $file; done done
echo "update the v2 to v3 wiki ok."

echo "ok"
#!/bin/bash
files=`ls v2*`
keys=`ls v2*|awk -F '_' '{print $3}'|awk -F '.' '{print $1}'`
uname -s |grep "Darwin" >/dev/null 2>&1
if [[ 0 -eq $? ]]; then
    for file in $files; do for key in $keys; do echo "process file $file for key $key"; sed -i '' "s/v1_EN_$key/v2_EN_$key/g" $file; done done
    for file in $files; do for key in $keys; do echo "process file $file for key $key"; sed -i '' "s/v1_CN_$key/v2_CN_$key/g" $file; done done
else
    for file in $files; do for key in $keys; do echo "process file $file for key $key"; sed -i "s/v1_EN_$key/v2_EN_$key/g" $file; done done
    for file in $files; do for key in $keys; do echo "process file $file for key $key"; sed -i "s/v1_CN_$key/v2_CN_$key/g" $file; done done
fi

files=`ls v3*`
keys=`ls v3*|awk -F '_' '{print $3}'|awk -F '.' '{print $1}'`
uname -s |grep "Darwin" >/dev/null 2>&1
if [[ 0 -eq $? ]]; then
    for file in $files; do for key in $keys; do echo "process file $file for key $key"; sed -i '' "s/v1_EN_$key/v3_EN_$key/g" $file; done done
    for file in $files; do for key in $keys; do echo "process file $file for key $key"; sed -i '' "s/v1_CN_$key/v3_CN_$key/g" $file; done done
else
    for file in $files; do for key in $keys; do echo "process file $file for key $key"; sed -i "s/v1_EN_$key/v3_EN_$key/g" $file; done done
    for file in $files; do for key in $keys; do echo "process file $file for key $key"; sed -i "s/v1_CN_$key/v3_CN_$key/g" $file; done done
fi

#!/bin/bash

uname -s |grep "Darwin" >/dev/null 2>&1
if [[ 0 -eq $? ]]; then
    SED="sed -i ''"
else
    SED="sed -i"
fi
echo "sed is $SED"

files=`ls v*_CN_*` && for file in $files; do
    $SED "s|v1_EN_|v1_CN_|g" $file
done
exit 0
$SED "s/v2_EN_/v2_CN_/g" v*_CN_*
$SED "s/v3_EN_/v3_CN_/g" v*_CN_*
echo "all EN correct to CN"

$SED "s/v1_CN_/v1_EN_/g" v*_EN_*
$SED "s/v2_CN_/v2_EN_/g" v*_EN_*
$SED "s/v3_CN_/v3_EN_/g" v*_EN_*
echo "all CN correct to EN"

echo "ok"

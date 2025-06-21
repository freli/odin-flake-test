#!/usr/bin/env sh
cd Odin
for dir in vendor/*/
do
file=${dir%/}
file=${file##*/}
git diff --output="$file.patch" $dir
done
find *.patch -type f -empty -delete
rm ../patches/*.patch
mv *.patch ../patches

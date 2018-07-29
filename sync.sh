#!/bin/bash

# Make sure we build the latest binary in the real package.
cd ../gedcom/gedcom2html
go build
cd -
cp ../gedcom/gedcom2html/gedcom2html .

rm -rf out
mkdir -p out
./gedcom2html -gedcom "Chance Family Tree/Chance Family Tree.ged" -output-dir out

cd out

aws s3 sync . s3://dechauncy.family

for file in $(aws s3 ls s3://dechauncy.family | cut -c32-)
do
    if [ ! -f "$file" ]; then
        aws s3 rm "s3://dechauncy.family/$file"
    fi
done

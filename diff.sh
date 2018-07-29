# Used to compare two GEDCOM files. I use this to compare data between
# MacFamilyTree and Anestry.com.

#!/bin/bash

set -e

# Make sure we build the latest binary in the real package.
cd ../gedcom/gedcom2text
go build
cd -
cp ../gedcom/gedcom2text/gedcom2text .

rm -rf anc mft
mkdir anc
mkdir mft

OPTIONS="-no-sources -only-official-tags -single-name -no-places -no-change-times -no-empty-deaths"

./gedcom2text $OPTIONS -split-dir anc -gedcom "de Chauncy Family Tree.ged"
./gedcom2text $OPTIONS -split-dir mft -gedcom "Chance Family Tree/Chance Family Tree.ged"

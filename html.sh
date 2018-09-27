#!/bin/bash

# Make sure we build the latest binary in the real package.
cd ../gedcom/gedcom2html
go build || exit $?
cd -
cp ../gedcom/gedcom2html/gedcom2html .

# Generate the new files.
rm -rf /tmp/out
mkdir -p /tmp/out
./gedcom2html -gedcom "Chance Family Tree/Chance Family Tree.ged" \
    -output-dir /tmp/out \
    -google-analytics-id "UA-71454410-2" \
    -checksum \
    $@

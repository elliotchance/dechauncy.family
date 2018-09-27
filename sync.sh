#!/bin/bash

#./html.sh

cd /tmp/out

# Run diff.
aws s3 cp s3://dechauncy.family/checksum.csv /tmp/checksum.csv
echo "Total files: $(ls -1 | wc -l)"
DIFF="diff /tmp/checksum.csv /tmp/out/checksum.csv --suppress-common-lines -y -W 1000"
echo "New files: $($DIFF | egrep "\||>" | wc -l)"
echo "Changed files: $($DIFF | egrep "\|" | wc -l)"
echo "Delete files: $($DIFF | grep "<" | wc -l)"

NEW_FILES=$($DIFF | egrep "\||>" | rev | cut -f1 | rev | cut -d, -f1)
DEL_FILES=$($DIFF | grep "<" | cut -d, -f1)

# Prepare jobs
echo "" > /tmp/jobs.txt

for FILE in $NEW_FILES; do
    echo aws s3 cp "./$FILE" "s3://dechauncy.family/$FILE" >> /tmp/jobs.txt
done

for FILE in $DEL_FILES; do
    echo aws s3 rm "s3://dechauncy.family/$FILE" >> /tmp/jobs.txt
done

echo aws s3 cp checksum.csv "s3://dechauncy.family/checksum.csv" >> /tmp/jobs.txt

# Run jobs
parallel --jobs 20 < /tmp/jobs.txt

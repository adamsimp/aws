#! /bin/bash

REGION=$1
MEDIASTOREID=$2
MLPATH=$3

FILENAMES=$(aws mediastore-data list-items --region=${REGION} --endpoint=https://${MEDIASTOREID}.data.mediastore.${REGION}.amazonaws.com  --path=${MLPATH} | echo jq -r '.Items[] .Name')

TOTALFILES=$(echo "${FILENAMES}" | grep Name | cut -f 3 | nl | wc -l)

echo " "
echo "====================================================="
echo "Deleting files from MediaStore for ID $MEDIASTOREID."
echo "Files to be deleted:"$TOTALFILES
echo "====================================================="
echo " "

START=1
for (( COUNT=$START; COUNT<=$TOTALFILES; COUNT++ ))
do
    echo "====================================================="
    echo \#$COUNT

    DELETEFILENAME=$(echo "$FILENAMES" | cut -f 6 | grep -w snap | nl | grep -w $COUNT | cut -f 2)

    DELETEFILEDESC=$(echo "$FILENAMES" | grep $FILENAMES | cut -f 2 | nl | grep -w 1 | cut -f 2)

    DELETEFILE=$(aws mediastore-data delete-object --region=${REGION} --endpoint=https://${MEDIASTOREID}.data.mediastore.${REGION}.amazonaws.com --path=${MLPATH}/$DELETEFILENAME)

    echo "Successful: "$DELETEFILE
    echo "Deleted: "$DELETEFILEDESC
done

echo "====================================================="
echo " "
echo "Completed!"
echo " "

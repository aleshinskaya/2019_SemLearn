#! /usr/bin/tcsh

set fileDir = $argv[1]
set fieldMapName = $argv[2]
set scanList = $argv[3]

# set tmpFieldMapName = $argv[3]


echo $fileDir 
echo $fieldMapName
# echo $tmpFieldMapName


cat $fileDir$fieldMapName |\
  jq 'to_entries |\
 map(if .key == "EffectiveEchoSpacing"\
 then . + {"key":"TotalReadoutTime"} \
   else .   end ) | from_entries' >> $fileDir'tmp.json'


rm $fileDir$fieldMapName 

# Modify the JSON file to include the IntendedFor section
set flist = `echo $scanList`
cat $fileDir'tmp.json' |\
jq '. + { "IntendedFor": ['$flist']}' >> $fileDir'tmp2.json'

rm $fileDir'tmp.json'

mv $fileDir'tmp2.json' $fileDir$fieldMapName

# cat $fileDir'tmp.json' $fileDir$tmpFieldMapName | jq -s 'add' > $fileDir$fieldMapName
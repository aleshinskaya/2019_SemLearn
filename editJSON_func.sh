#! /usr/bin/tcsh

set fileDir = $argv[1]
set fileName = $argv[2]
set taskName = $argv[3]


echo 'changing file '$fileDir$fileName' to have entry TaskName = '$taskName


jq '. + { "TaskName": "'$taskName'"}' $fileDir$fileName > $fileDir'tmp.json'

mv $fileDir'tmp.json' $fileDir$fileName 
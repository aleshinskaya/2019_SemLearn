#! /usr/bin/tcsh

set subjID = $argv[1]
set sessionID = $argv[2]
set rootDir = $argv[3]

#compress raw data
cd $rootDir'/raw_data/'$subjID
tar -zcf $sessionID'.tar.gz' $sessionID 
rm -r $sessionID'/'

#remove working directory for fmriprep
cd $rootDir'/fmri_prep/working/reportlets/fmriprep/'
rm -r $subjID'/'


# #remove input to fmri-prep
rm -r $rootDir'/fmri_prep/input/'$subjID'/'$sessionID

# #remove the inputs to glms in the afni/glm folder - these can be copied over from fmri prep easily
# rm $rootDir'/afni/'$subjID'/glm/'$subjID'_'$sessionID'_task-main'*'space'*

cd $rootDir'/afni/'$subjID'/glm/'
rm $subjID'_'$sessionID'_task-main'*space*

#remove stuff from surface directory
rm -r $rootDir'/surfaces/'$sessionID'/glasser_roi/'$subjID'/masks' 
# rm -r $rootDir'/surfaces/'$sessionID'/'$subjID'/surf' 



#! /usr/bin/tcsh

set subjID = $argv[1]
set sessionID = $argv[2]

module load matlab afni fmriprep singularity gsl bio3 freesurfer/6.0.0 perl


set topDir = '/home/aleshins/'
set rootDir = '/home/aleshins/2019_SL1/'
set fmriPrepDir = $rootDir'fmri_prep/'
set dicomDir = $rootDir'raw_data/'$subjID'/'$sessionID'/' 
set subjDir1 = $fmriPrepDir'input/'$subjID
set subjDir = $subjDir1'/'$sessionID'/' 
set progDir = $rootDir'code/'
set afniDir = $rootDir'afni/'$subjID'/'
set surfDir =  $rootDir'/surfaces/'$sessionID'/'$subjID'/'
set surfDirAll = $rootDir'/surfaces/'$sessionID'/'
set run_num_loc = 1
set TR = '1.25'


set space = 'MNI152NLin2009cAsym'
set funcOutputDir = $fmriPrepDir'output/fmriprep/'$subjID'/'$sessionID'/func/'
set thisRun = $subjID'_'$sessionID'_task-loc_run-'$run_num_loc
set thisConfoundFile = $thisRun'_desc-confounds_regressors.tsv'
set thisMask = $thisRun'_space-'$space'_desc-brain_mask.nii.gz'


: # get # of volumes 
cd $funcOutputDir
set vols = `3dinfo -nv $thisRun'_space-'$space'_desc-preproc_bold.nii.gz'`
echo $thisRun' has '$vols' volumes!'


: # copy the BOLD files and brain masks into glm directory and convert to afni format 
cd $funcOutputDir
3dcopy -verb $thisRun$space'_desc-preproc_bold.nii.gz' $afniDir'/glm/'$thisRun'MNI+tlrc'
3dcopy -verb $thisMask  $afniDir'/glm/'$thisMask'+tlrc'


: # smooth the functional data 
cd $afniDir'/glm/'
3dmerge -1blur_fwhm 6 -doall -prefix  $thisRun'_space-MNI_blur6' $thisRun'_space-MNI+tlrc'

extractfMRIPrepRegressors.py $funcOutputDir$thisConfoundFile $afniDir'/regressors/' $thisRun

cd $progDir
waver.sh $afniDir'regressors/' 'task-loc_run-'$run_num_loc $vols $TR 



: #run GLM on MNI space files
: #name loc bucket file
cd $progDir
set bucketName = $thisRun'_bucket_MNI_blur6+tlrc' 
set maskName = $thisRun'_space-'$space'_desc-brain_mask.nii.gz'
./run3DDeconvolve_loc.sh $subjID $sessionID $bucketName $thisRun'_space-MNI_blur6+tlrc' $maskName $rootDir 'run-'$run_num_loc 

mv $afniDir'/glm/'*$bucketName* $afniDir'/display/'

#! /usr/bin/tcsh


#read in arguments
set subjID = $argv[1]
set sessionID = $argv[2]
set outputFileName = $argv[3]
set inputDataName = $argv[4]
set whichMaskFile = $argv[5]

set topDir =  $argv[6] 
set runID = $argv[7] 

echo 'running 3dDeconvolve on '$inputDataName


#regressor directory 
set regDir = $topDir'/afni/'$subjID'/regressors/'
# data directory
set dataDir = $topDir'/afni/'$subjID'/glm/'
# set program directory 
set progDir = `pwd`

 #names of regressors
set regressor_labels = ('causality' 'edibility')
# implicit baseline is the probe_baseline timepoints and any fixation at the end of the run 'Probe_baseline'

# for now, leaving out the censor file
# -censor $regDir$subjID'_all_censor.1D'\

# -concat $topDir'/templates/runs_startpoints_1run.1D'\

cd $dataDir 

3dDeconvolve -input $inputDataName\
-polort 3\
-mask $whichMaskFile\
 -censor $regDir$subjID'_'$sessionID'_task-loc_'$runID'_motion_outliers.1D'\
-num_stimts 15\
-stim_file 1 $regDir$subjID'_'$sessionID'_task-loc_'$runID'_'$regressor_labels[1]'_wav.1D'\
-stim_label 1 $regressor_labels[1]\
-stim_file 2 $regDir$subjID'_'$sessionID'_task-loc_'$runID'_'$regressor_labels[2]'_wav.1D'\
-stim_label 2 $regressor_labels[2]\
-stim_file 3 $regDir$subjID'_'$sessionID'_task-loc_'$runID'_rot_x.1D'\
-stim_label 3 'motion1'\
-stim_base 3 \
-stim_file 4 $regDir$subjID'_'$sessionID'_task-loc_'$runID'_rot_y.1D'\
-stim_label 4 'motion2' \
-stim_base 4 \
-stim_file 5 $regDir$subjID'_'$sessionID'_task-loc_'$runID'_rot_z.1D'\
-stim_label 5 'motion3'\
-stim_base 5\
-stim_file 6 $regDir$subjID'_'$sessionID'_task-loc_'$runID'_trans_x.1D'\
-stim_label 6 'motion4'\
-stim_base 6\
-stim_file 7 $regDir$subjID'_'$sessionID'_task-loc_'$runID'_trans_y.1D'\
-stim_label 7 'motion5' \
-stim_base 7 \
-stim_file 8 $regDir$subjID'_'$sessionID'_task-loc_'$runID'_trans_z.1D'\
-stim_label 8 'motion6'\
-stim_base 8\
-stim_file 9 $regDir$subjID'_'$sessionID'_task-loc_'$runID'_csf.1D'\
-stim_label 9 'motion7'\
-stim_base 9\
-stim_file 10 $regDir$subjID'_'$sessionID'_task-loc_'$runID'_rot_x_derivative1.1D'\
-stim_label 10 'motion8'\
-stim_base 10\
-stim_file 11 $regDir$subjID'_'$sessionID'_task-loc_'$runID'_rot_y_derivative1.1D'\
-stim_label 11 'motion9'\
-stim_base 11\
-stim_file 12 $regDir$subjID'_'$sessionID'_task-loc_'$runID'_rot_z_derivative1.1D'\
-stim_label 12 'motion10'\
-stim_base 12\
-stim_file 13 $regDir$subjID'_'$sessionID'_task-loc_'$runID'_trans_x_derivative1.1D'\
-stim_label 13 'motion11'\
-stim_base 13\
-stim_file 14 $regDir$subjID'_'$sessionID'_task-loc_'$runID'_trans_y_derivative1.1D'\
-stim_label 14 'motion12'\
-stim_base 14\
-stim_file 15 $regDir$subjID'_'$sessionID'_task-loc_'$runID'_trans_z_derivative1.1D'\
-stim_label 15 'motion13'\
-stim_base 15\
-gltsym 'SYM: causality -edibility'\
-glt_label 1 'CvsE'\
-bucket $outputFileName\
-tout


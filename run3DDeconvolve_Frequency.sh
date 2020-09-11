#! /usr/bin/tcsh


#read in arguments
set subjID = $argv[1]
set sessionID = $argv[2]
set outputFileName = $argv[3]
set inputDataName = $argv[4]
set whichMaskFile = $argv[5]
set whichObject = $argv[6]
set topDir =  $argv[7] 
set runID = $argv[8] 

echo 'running 3dDeconvolve on '$inputDataName


#regressor directory 
set regDir = $topDir'/afni/'$subjID'/regressors/'
# data directory
set dataDir = $topDir'/afni/'$subjID'/glm/'
# set program directory 
set progDir = `pwd`

 #names of regressors
set regressor_labels = ('cause_1' 'cause_2' 'cause_3' 'cause_4' 'cause_5' 'cause_pastbin5' 'frequent_1' 'frequent_2' 'frequent_3' 'frequent_4' 'frequent_5' 'frequent_pastbin5' 'NCM_1' 'NCM_2' 'NCM_3' 'NCM_4' 'NCM_5' 'NCM_pastbin5' 'r1_1' 'r1_2' 'r1_3' 'r1_4' 'r1_5' 'r1_pastbin5' 'r2_1'  'r2_2'  'r2_3'  'r2_4'  'r2_5' 'r2_pastbin5' 'r3_1' 'r3_2' 'r3_3' 'r3_4' 'r3_5' 'r3_pastbin5' 'Probe_cause' 'Probe_frequent' 'Probe_oddball' 'Probe_r1' 'Probe_r2' 'Probe_r3' 'Question')
# implicit baseline is the probe_baseline timepoints and any fixation at the end of the run 'Probe_baseline'



cd $dataDir 

3dDeconvolve -input $inputDataName\
-polort 3\
-mask $whichMaskFile\
-censor $regDir$subjID'_'$sessionID'_task-main_'$runID'_motion_outliers.1D'\
-num_stimts 55\
-allzero_OK \
-GOFORIT 6\
-stim_file 1 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[1]'_wav.1D'\
-stim_label 1 $regressor_labels[1]\
-stim_file 2 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[2]'_wav.1D'\
-stim_label 2 $regressor_labels[2]\
-stim_file 3 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[3]'_wav.1D'\
-stim_label 3 $regressor_labels[3]\
-stim_file 4 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[4]'_wav.1D'\
-stim_label 4 $regressor_labels[4]\
-stim_file 5 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[5]'_wav.1D'\
-stim_label 5 $regressor_labels[5]\
-stim_file 6 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[6]'_wav.1D'\
-stim_label 6 $regressor_labels[6]\
-stim_file 7 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[7]'_wav.1D'\
-stim_label 7 $regressor_labels[7]\
-stim_file 8 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[8]'_wav.1D'\
-stim_label 8 $regressor_labels[8]\
-stim_file 9 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[9]'_wav.1D'\
-stim_label 9 $regressor_labels[9]\
-stim_file 10 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[10]'_wav.1D'\
-stim_label 10 $regressor_labels[10]\
-stim_file 11 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[11]'_wav.1D'\
-stim_label 11 $regressor_labels[11]\
-stim_file 12 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[12]'_wav.1D'\
-stim_label 12 $regressor_labels[12]\
-stim_file 13 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[13]'_wav.1D'\
-stim_label 13 $regressor_labels[13]\
-stim_file 14 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[14]'_wav.1D'\
-stim_label 14 $regressor_labels[14]\
-stim_file 15 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[15]'_wav.1D'\
-stim_label 15 $regressor_labels[15]\
-stim_file 16 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[16]'_wav.1D'\
-stim_label 16 $regressor_labels[16]\
-stim_file 17 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[17]'_wav.1D'\
-stim_label 17 $regressor_labels[17]\
-stim_file 18 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[18]'_wav.1D'\
-stim_label 18 $regressor_labels[18]\
-stim_file 19 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[19]'_wav.1D'\
-stim_label 19 $regressor_labels[19]\
-stim_file 20 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[20]'_wav.1D'\
-stim_label 20 $regressor_labels[20]\
-stim_file 21 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[21]'_wav.1D'\
-stim_label 21 $regressor_labels[21]\
-stim_file 22 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[22]'_wav.1D'\
-stim_label 22 $regressor_labels[22]\
-stim_file 23 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[23]'_wav.1D'\
-stim_label 23 $regressor_labels[23]\
-stim_file 24 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[24]'_wav.1D'\
-stim_label 24 $regressor_labels[24]\
-stim_file 25 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[25]'_wav.1D'\
-stim_label 25 $regressor_labels[25]\
-stim_file 26 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[26]'_wav.1D'\
-stim_label 26 $regressor_labels[26]\
-stim_file 27 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[27]'_wav.1D'\
-stim_label 27 $regressor_labels[27]\
-stim_file 28 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[28]'_wav.1D'\
-stim_label 28 $regressor_labels[28]\
-stim_file 29 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[29]'_wav.1D'\
-stim_label 29 $regressor_labels[29]\
-stim_file 30 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[30]'_wav.1D'\
-stim_label 30 $regressor_labels[30]\
-stim_file 31 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[31]'_wav.1D'\
-stim_label 31 $regressor_labels[31]\
-stim_file 32 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[32]'_wav.1D'\
-stim_label 32 $regressor_labels[32]\
-stim_file 33 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[33]'_wav.1D'\
-stim_label 33 $regressor_labels[33]\
-stim_file 34 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[34]'_wav.1D'\
-stim_label 34 $regressor_labels[34]\
-stim_file 35 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[35]'_wav.1D'\
-stim_label 35 $regressor_labels[35]\
-stim_file 36 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[36]'_wav.1D'\
-stim_label 36 $regressor_labels[36]\
-stim_file 37 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[37]'_wav.1D'\
-stim_label 37 $regressor_labels[37]\
-stim_file 38 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[38]'_wav.1D'\
-stim_label 38 $regressor_labels[38]\
-stim_file 39 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[39]'_wav.1D'\
-stim_label 39 $regressor_labels[39]\
-stim_file 40 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[40]'_wav.1D'\
-stim_label 40 $regressor_labels[40]\
-stim_file 41 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[41]'_wav.1D'\
-stim_label 41 $regressor_labels[41]\
-stim_file 42 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[42]'_wav.1D'\
-stim_label 42 $regressor_labels[42]\
-stim_file 43 $regDir$subjID'_'$sessionID'_task-main_'$whichObject$regressor_labels[43]'_wav.1D'\
-stim_label 43 $regressor_labels[43]\
-stim_file 44 $regDir$subjID'_'$sessionID'_task-main_'$runID'_rot_x.1D'\
-stim_label 44 'motion1'\
-stim_base 44\
-stim_file 45 $regDir$subjID'_'$sessionID'_task-main_'$runID'_rot_y.1D'\
-stim_label 45 'motion2' \
-stim_base 45\
-stim_file 46 $regDir$subjID'_'$sessionID'_task-main_'$runID'_rot_z.1D'\
-stim_label 46 'motion3'\
-stim_base 46\
-stim_file 47 $regDir$subjID'_'$sessionID'_task-main_'$runID'_trans_x.1D'\
-stim_label 47 'motion4'\
-stim_base 47\
-stim_file 48 $regDir$subjID'_'$sessionID'_task-main_'$runID'_trans_y.1D'\
-stim_label 48 'motion5' \
-stim_base 48\
-stim_file 49 $regDir$subjID'_'$sessionID'_task-main_'$runID'_trans_z.1D'\
-stim_label 49 'motion6'\
-stim_base 49\
-stim_file 50 $regDir$subjID'_'$sessionID'_task-main_'$runID'_rot_x_derivative1.1D'\
-stim_label 50 'motion7'\
-stim_base 50\
-stim_file 51 $regDir$subjID'_'$sessionID'_task-main_'$runID'_rot_y_derivative1.1D'\
-stim_label 51 'motion8'\
-stim_base 51\
-stim_file 52 $regDir$subjID'_'$sessionID'_task-main_'$runID'_rot_z_derivative1.1D'\
-stim_label 52 'motion9'\
-stim_base 52\
-stim_file 53 $regDir$subjID'_'$sessionID'_task-main_'$runID'_trans_x_derivative1.1D'\
-stim_label 53 'motion10'\
-stim_base  53\
-stim_file 54 $regDir$subjID'_'$sessionID'_task-main_'$runID'_trans_y_derivative1.1D'\
-stim_label 54 'motion11'\
-stim_base 54\
-stim_file 55 $regDir$subjID'_'$sessionID'_task-main_'$runID'_trans_z_derivative1.1D'\
-stim_label 55 'motion12'\
-stim_base 55\
-bucket $outputFileName\
-tout


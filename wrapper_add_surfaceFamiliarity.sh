#! /usr/bin/tcsh

set subjID = $argv[1]
set sessionID = $argv[2]
set topDir = $argv[3] 
# '/home/aleshins/'


set rootDir = $topDir'2019_SL1/'
set fmriPrepDir = $rootDir'fmri_prep/'
set afniDir = $rootDir'afni/'$subjID'/'
set surfDir =  $rootDir'/surfaces/'$sessionID'/'$subjID'/'
set surfDirAll = $rootDir'/surfaces/'$sessionID'/'


#run searchlight for fam code 
cd $rootDir'/code/'
matlab -nodisplay -r "volume_contrast_familiarityCoding('$subjID','$sessionID',[7:12],'$topDir'); exit"
matlab -nodisplay -r "volume_ttest_runs('$subjID','$sessionID',[7:12],'$topDir',8); exit"


#convert output 
# tTest_n6_oneway_contrast_sub-002_ses-1_familiarity_frequencyObjects_T1w_blur4_9mm_Contrast+orig.BRIK
set thisFileName = 'tTest_n6_oneway_contrast_'$subjID'_'$sessionID'_familiarity_frequencyObjects_T1w_blur4_9mm_Contrast+orig' 
mv $afniDir'/display/'$thisFileName* $surfDir'/ref/'

cd $surfDir'/ref/'
3dVol2Surf -spec mh_ico128_al.spec -surf_A ico128_mh.smoothwm_al.asc -surf_B ico128_mh.pial_al.asc -sv $afniDir'/glm/'$subjID'_'$sessionID'_anat_desc-preproc_T1w+orig'  -grid_parent $thisFileName -map_func ave -out_nimls $thisFileName'_mh.niml.dset'
ConvertDset -o_niml_asc -input $thisFileName'_mh.niml.dset' -prefix $thisFileName'_c_mh.niml.dset'
rm $thisFileName'_mh.niml.dset'


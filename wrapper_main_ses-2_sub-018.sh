#! /usr/bin/tcsh


# all code to process a participant & session

# THINGS TO CHECK MANUALLY:
# set subjID and sessionID variables throughout (multiple places)
# set object_names_list to the run order, obtain from R code
# check scan numbers to match the scan name variables at SET SCAN NUMBERS HERE
# at searchlight code, the object numbers included in associative coding must be entered
# searchlights which are not possible to run should be removed.


#enter interactive mode on the cluster: -t is time, 12:00:00 is 12 hours
srun -p med -J sub-018 --mem=8000 -t 12:00:00 -u --pty tcsh -l

#SUBJECT AND SESSION VARIABLES
set subjID = 'sub-018'
set sessionID = 'ses-2'

#directories 
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
set run_num_loc = 2
set TR = '1.25'


# SET RUN ORDER!
# 10 11 12 7 8 9 4 5 6 1 2 3
set object_names_list = ('obj10' 'obj11' 'obj12' 'obj7' 'obj8' 'obj9' 'obj4' 'obj5' 'obj6' 'obj1' 'obj2' 'obj3')


#load modules 
module load matlab afni fmriprep singularity gsl bio3 freesurfer/6.0.0 perl

if ( -e $fmriPrepDir'/input'/$subjID'/ses-1' ) then
   echo 'Directory for ses-1 exists'
   mv $fmriPrepDir'/input'/$subjID'/ses-1' $fmriPrepDir'/'$subjID'/'
   rm -r $fmriPrepDir'/working/reportlets/fmriprep/'$subjID
   rm -r $fmriPrepDir'/working/fmriprep_wf/single_subject_'$subjNum'_wf/'
  endif 

#------specify scan names ------------------

set scan1 =  $subjID'_'$sessionID'_task-main_run-1_bold' 
set scan2 =  $subjID'_'$sessionID'_task-main_run-2_bold' 
set scan3 =  $subjID'_'$sessionID'_task-main_run-3_bold' 
set scan4 =  $subjID'_'$sessionID'_task-main_run-4_bold' 
set scan5 =  $subjID'_'$sessionID'_task-main_run-5_bold' 
set scan6 =  $subjID'_'$sessionID'_task-main_run-6_bold' 
set scan7 =  $subjID'_'$sessionID'_task-main_run-7_bold' 
set scan8 =  $subjID'_'$sessionID'_task-main_run-8_bold' 
set scan9 =  $subjID'_'$sessionID'_task-main_run-9_bold' 
set scan10 = $subjID'_'$sessionID'_task-main_run-10_bold' 
set scan11 = $subjID'_'$sessionID'_task-main_run-11_bold' 
set scan12 = $subjID'_'$sessionID'_task-main_run-12_bold' 
set loc1 = $subjID'_'$sessionID'_task-loc_run-'$run_num_loc'_bold' 
set fmapName = $subjID'_'$sessionID'_dir-AP_epi'

#create array of scan names 
set scan_list_main = ($scan1 $scan2 $scan3 $scan4 $scan5 $scan6 $scan7 $scan8 $scan9 $scan10 $scan11 $scan12)

set scan_list_loc = ($loc1)


#------------------------run only once below-----------------#
# create BIDs directories in fmriprep folder
mkdir $subjDir1
mkdir $subjDir 
cd  $subjDir 
mkdir anat func fmap 

#create directories in the afni folder 
mkdir $afniDir
mkdir $afniDir'regressors/'
mkdir $afniDir'glm/'
mkdir $afniDir'searchlight/'
mkdir $afniDir'display/'

# make directory in surfaces folder
mkdir $surfDir



#-------read DICOMs and sort them into BIDS-style folders--------#
#assumes DICOMs are sorted into numbered folders by run; if they are not, use sortDicoms.sh 

cd $progDir

#anatomical scan
# -o is the output folder, -f is the filename for the output, -z is compression, and last arg is the input folder 
dcm2niix_afni -o $subjDir'/anat/' -f $subjID'_'$sessionID'_T1w' -z y $dicomDir'/002'*

#function scans  - main task
# SET SCAN NUMBERS HERE! 
dcm2niix_afni -o $subjDir'/func/' -f $scan1 -z y $dicomDir'/004'*
dcm2niix_afni -o $subjDir'/func/' -f $scan2 -z y $dicomDir'/005'*
dcm2niix_afni -o $subjDir'/func/' -f $scan3 -z y $dicomDir'/006'*
dcm2niix_afni -o $subjDir'/func/' -f $scan4 -z y $dicomDir'/007'*
dcm2niix_afni -o $subjDir'/func/' -f $scan5 -z y $dicomDir'/008'*
dcm2niix_afni -o $subjDir'/func/' -f $scan6 -z y $dicomDir'/009'*
dcm2niix_afni -o $subjDir'/func/' -f $scan7 -z y $dicomDir'/010'*
dcm2niix_afni -o $subjDir'/func/' -f $scan8 -z y $dicomDir'/011'*
dcm2niix_afni -o $subjDir'/func/' -f $scan9 -z y $dicomDir'/012'*
dcm2niix_afni -o $subjDir'/func/' -f $scan10 -z y $dicomDir'/013'*
dcm2niix_afni -o $subjDir'/func/' -f $scan11 -z y $dicomDir'/014'*
dcm2niix_afni -o $subjDir'/func/' -f $scan12 -z y $dicomDir'/015'*
#function scans - localizer 
dcm2niix_afni -o $subjDir'/func/' -f $loc1 -z y $dicomDir'/016'*
#field map and/or reverse-AP
dcm2niix_afni -o $subjDir'/fmap/' -f $fmapName -z y $dicomDir'/017'*


# edit functional file jsons and also add to a list for the fieldmap
cd $progDir

set scanList2 = ''

foreach scan_num($scan_list_main)

	echo $scan_num
	 ./editJSON_func.sh $subjDir'func/' $scan_num'.json' 'main'
	set scanList2 = $scanList2'"'$sessionID'/func/'$scan_num'.nii.gz",' 

end

set scanList2 = $scanList2'"'$sessionID'/func/'$loc1'.nii.gz"' 

# edit field map json 
./editJSON_fMap.sh $subjDir'fmap/' $fmapName'.json' $scanList2

./editJSON_func.sh $subjDir'func/' $loc1'.json' 'loc'



#------------------------preprocess the data-----------------------------#
exit; exit; ssh aleshins@crick.cse.ucdavis.edu -Y
screen
srun -p med -u  --mem=36000 --nodes=1 -t 12:00:00 --pty tcsh -l
module load matlab afni fmriprep singularity

set subjID = 'sub-018'
set sessionID = 'ses-2'

# project directories 
set rootDir = '/home/aleshins/2019_SL1/'
set fmriPrepDir = $rootDir'fmri_prep/'

singularity run --cleanenv /share/apps/fmriprep-1.4.1/fmriprep.simg $fmriPrepDir'/input/' $fmriPrepDir'/output/' participant  --fs-license-file $rootDir'/templates/license.txt' --participant_label $subjID -w $fmriPrepDir'/working/' -vv --output-spaces 'MNI152NLin2009cAsym' anat --fs-no-reconall  --nthreads 2 --mem_mb 20000 --n_cpus 8
exit 



#------------------------check the results!---------------------------#

# look at the html file in the fmriprep output folder 
# Check Alignment of functional and anatomical MRI data for each run
# check each regressors tsv file for translations and rotations--ensure all below 3mm

#------------------- anatomical files ------------------# 

#copy anatomical file into afni directory
3dcopy $fmriPrepDir'output/fmriprep/'$subjID'/anat/'$subjID'_desc-preproc_T1w.nii.gz' $afniDir'glm/'$subjID'_'$sessionID'_anat_desc-preproc_T1w+orig'
3dcopy $fmriPrepDir'output/fmriprep/'$subjID'/anat/'$subjID'_space-MNI152NLin2009cAsym_desc-preproc_T1w.nii.gz' $afniDir'glm/'$subjID'_'$sessionID'_anat_desc-preproc_MNI+tlrc'


#skull strip anatomicals and move the result display directory
cd $afniDir'/glm'
3dSkullStrip -input  $afniDir'glm/'$subjID'_'$sessionID'_anat_desc-preproc_T1w+orig' -prefix  $afniDir'glm/'$subjID'_'$sessionID'_anat_ns_desc-preproc_T1w+orig'
3dSkullStrip -input  $afniDir'glm/'$subjID'_'$sessionID'_anat_desc-preproc_MNI+tlrc' -prefix $afniDir'glm/'$subjID'_'$sessionID'_anat_ns_desc-preproc_MNI+tlrc'
mv *'_anat_ns'* $afniDir'/display/'
 cd $progDir

#------------------- main task glms & basic searchlights ------------------# 

#make array of the BOLD run files 
set scan_list_main = ($subjID'_'$sessionID'_task-main_run-1_space-')
set scan_list_main = ($scan_list_main $subjID'_'$sessionID'_task-main_run-2_space-')
set scan_list_main = ($scan_list_main $subjID'_'$sessionID'_task-main_run-3_space-')
set scan_list_main = ($scan_list_main $subjID'_'$sessionID'_task-main_run-4_space-')
set scan_list_main = ($scan_list_main $subjID'_'$sessionID'_task-main_run-5_space-')
set scan_list_main = ($scan_list_main $subjID'_'$sessionID'_task-main_run-6_space-')
set scan_list_main = ($scan_list_main $subjID'_'$sessionID'_task-main_run-7_space-')
set scan_list_main = ($scan_list_main $subjID'_'$sessionID'_task-main_run-8_space-')
set scan_list_main = ($scan_list_main $subjID'_'$sessionID'_task-main_run-9_space-')
set scan_list_main = ($scan_list_main $subjID'_'$sessionID'_task-main_run-10_space-')
set scan_list_main = ($scan_list_main $subjID'_'$sessionID'_task-main_run-11_space-')
set scan_list_main = ($scan_list_main $subjID'_'$sessionID'_task-main_run-12_space-')


set run_count = `seq 1 8`
set space = 'MNI152NLin2009cAsym'
set funcOutputDir = $fmriPrepDir'output/fmriprep/'$subjID'/'$sessionID'/func/'

foreach run_num($run_count)

set thisRun = $scan_list_main[$run_num]
set thisMask = $thisRun$space'_desc-brain_mask.nii.gz'
set thisObject = $object_names_list[$run_num]'_'
set thisConfoundFile = $subjID'_'$sessionID'_task-main_run-'$run_num'_desc-confounds_regressors.tsv'

: # pull up this run and get its # volumes
cd $funcOutputDir
set vols = `3dinfo -nv $thisRun$space'_desc-preproc_bold.nii.gz'`
echo $thisRun' has '$vols' volumes!'

: # copy the BOLD files and brain masks into glm directory and convert to afni format 
3dcopy -verb $thisRun$space'_desc-preproc_bold.nii.gz' $afniDir'/glm/'$thisRun'MNI+tlrc'
3dcopy -verb $thisMask  $afniDir'/glm/'$thisMask'+tlrc'

: # also copy orig space
3dcopy -verb $thisRun'T1w_desc-preproc_bold.nii.gz' $afniDir'/glm/'$thisRun'T1w+orig'
3dcopy -verb $thisRun'T1w_desc-brain_mask.nii.gz' $afniDir'/glm/'$thisRun'T1w_desc-brain_mask+orig'

: # smooth the functional data 
cd $afniDir'/glm/'
3dmerge -1blur_fwhm 4 -doall -prefix  $thisRun'MNI_blur4' $thisRun'MNI+tlrc'
3dmerge -1blur_fwhm 4 -doall -prefix  $thisRun'T1w_blur4' $thisRun'T1w+orig'

: # read in the tsv output from fmriprep for this run to pull out the nuisance regressors and save as 1D files in regressor directory
extractfMRIPrepRegressors.py $funcOutputDir$thisConfoundFile $afniDir'/regressors/' $subjID'_'$sessionID'_task-main_run-'$run_num 

: #  waver the regressors 
cd $progDir
waver.sh $afniDir'regressors/' $thisObject $vols $TR 

: # determine glm based on object number
if($thisObject == 'obj7_' | $thisObject == 'obj8_' | $thisObject == 'obj9_' | $thisObject == 'obj10_' | $thisObject == 'obj11_' | $thisObject == 'obj12_') then
	
: #name the bucket file 
set bucketName = $subjID'_'$sessionID'_task-main_'$thisObject'bucket_MNI_blur4+tlrc' 
: # run 3dDeconvolve MNI space
./run3DDeconvolve_Frequency.sh  $subjID $sessionID $bucketName $thisRun'MNI_blur4+tlrc' $thisMask $thisObject $rootDir 'run-'$run_num 

: # run 3dDeconvolve orig space
set bucketName = $subjID'_'$sessionID'_task-main_'$thisObject'bucket_T1w_blur4+orig' 
./run3DDeconvolve_Frequency.sh  $subjID $sessionID $bucketName $thisRun'T1w_blur4+orig' $thisRun'T1w_desc-brain_mask+orig' $thisObject $rootDir 'run-'$run_num 

else
	: #name the bucket file 
set bucketName = $subjID'_'$sessionID'_task-main_'$thisObject'bucket_MNI_blur4+tlrc' 
: # run 3dDeconvolve MNI space
./run3DDeconvolve_Causality.sh  $subjID $sessionID $bucketName $thisRun'MNI_blur4+tlrc' $thisMask $thisObject $rootDir 'run-'$run_num 

: # run 3dDeconvolve orig space
set bucketName = $subjID'_'$sessionID'_task-main_'$thisObject'bucket_T1w_blur4+orig' 
./run3DDeconvolve_Causality.sh  $subjID $sessionID $bucketName $thisRun'T1w_blur4+orig' $thisRun'T1w_desc-brain_mask+orig' $thisObject $rootDir 'run-'$run_num 

endif


end


#------------------- volume searchlights ------------------# 

cd $progDir
: #call searchlight wrapper for this subject and selected runs
# EDIT THE OBJECT NUMBERS HERE
matlab -nodisplay -r "objects=[1:6]; volume_searchlight_associativeCoding('$subjID','$sessionID',objects,'$topDir'); exit"
matlab -nodisplay -r "volume_searchlight_relationalCat('$subjID','$sessionID','$topDir'); exit"
matlab -nodisplay -r "volume_searchlight_relCat_alltrials('$subjID','$sessionID','$topDir');exit"
matlab -nodisplay -r "volume_searchlight_frequencyCat('$subjID','$sessionID','$topDir'); exit"
matlab -nodisplay -r "volume_searchlight_visualSim('$subjID','$sessionID','$topDir'); exit"
matlab -nodisplay -r "volume_contrast_familiarityCoding('$subjID','$sessionID',[7:12],'$topDir'); exit"
 
: #call t-test over the runs 
: # (subjID,runNames,homepath,whichData)
matlab -nodisplay -r "volume_ttest_runs('$subjID','$sessionID',[1:6],'$topDir',1); exit"
matlab -nodisplay -r "volume_ttest_runs('$subjID','$sessionID',[7:12],'$topDir',7); exit"



#------------------- localizer ------------------# 

set space = 'MNI152NLin2009cAsym'
set funcOutputDir = $fmriPrepDir'output/fmriprep/'$subjID'/'$sessionID'/func/'
set thisRun = $subjID'_'$sessionID'_task-loc_run-'$run_num_loc
set thisConfoundFile = $thisRun'_desc-confounds_regressors.tsv'


: # get # of volumes 
cd $funcOutputDir
set vols = `3dinfo -nv $thisRun'_space-'$space'_desc-preproc_bold.nii.gz'`
echo $thisRun' has '$vols' volumes!'

: # copy Bold files and brain masks into glm directory and convert to afni format - native and MNI space
3dcopy -verb $thisRun'_space-'$space'_desc-preproc_bold.nii.gz' $afniDir'/glm/'$thisRun'_space-MNI+tlrc'
set thisMask = $thisRun'_space-'$space'_desc-brain_mask.nii.gz'
3dcopy -verb $thisMask  $afniDir'/glm/'$thisMask'+tlrc'


3dcopy -verb $thisRun'_space-T1w_desc-preproc_bold.nii.gz' $afniDir'/glm/'$thisRun'_space-T1w+orig'
set thisMask = $thisRun'_space-T1w_desc-brain_mask.nii.gz'
3dcopy -verb $thisMask  $afniDir'/glm/'$thisMask'+orig'

: # smooth the functional data 
cd $afniDir'/glm/'
3dmerge -1blur_fwhm 4 -doall -prefix  $thisRun'_space-MNI_blur4' $thisRun'_space-MNI+tlrc'
3dmerge -1blur_fwhm 4 -doall -prefix  $thisRun'_space-T1w_blur4' $thisRun'_space-T1w+orig'

: # read in tsvs
extractfMRIPrepRegressors.py $funcOutputDir$thisConfoundFile $afniDir'/regressors/' $thisRun

: # waver localizer regressors
cd $progDir
waver.sh $afniDir'regressors/' 'task-loc_run-'$run_num_loc $vols $TR 


: #run GLM on MNI space files
: #name loc bucket file
set bucketName = $thisRun'_bucket_MNI_blur4+tlrc' 
set maskName = $thisRun'_space-'$space'_desc-brain_mask.nii.gz'
./run3DDeconvolve_loc.sh $subjID $sessionID $bucketName $thisRun'_space-MNI_blur4+tlrc' $maskName $rootDir 'run-'$run_num_loc 
mv $afniDir'/glm/'*$bucketName* $afniDir'/display/'


: #run GLM on orig space files
: #name loc bucket file
set bucketName = $thisRun'_bucket_T1w_blur4+orig' 
set maskName = $thisRun'_space-T1w_desc-brain_mask.nii.gz'
./run3DDeconvolve_loc.sh $subjID $sessionID $bucketName $thisRun'_space-T1w_blur4+orig' $maskName $rootDir 'run-'$run_num_loc
mv $afniDir'/glm/'*$bucketName* $afniDir'/display/'

#------------------- surfaces ------------------# 
cd $progDir
# select an epi file for alignment/resampling (use afni format!) 
set epi_file = $afniDir'/glm/'$subjID'_'$sessionID'_task-main_run-1_space-T1w+orig'

#create surface directory and copy files to it, converting to mgz format for recon-all
mkdir -p $surfDir'/mri/orig'
mri_convert $fmriPrepDir'/input/'$subjID'/'$sessionID'/anat/'$subjID'_'$sessionID'_T1w.nii.gz' $surfDir'/mri/orig/001.mgz'
# call recon-all via sbatch (this will run independently on the cluster for ~10 hours)
sbatch -p high -t 12:00:00 --mem=16000 run_reconall.sh $subjID $rootDir $sessionID



#------------------- once the above is complete ------------------# 
cd $progDir
set epi_file = $afniDir'/glm/'$subjID'_'$sessionID'_task-main_run-1_space-T1w+orig'
echo $subjID >> $surfDirAll$subjID.txt
./create_subj_volume_parcellation.sh -L $subjID.txt -a HCPMMP1 -d glasser_roi -m NO -D $surfDirAll
# convert Glasser_ROIs to afni +orig and resample to matrix of template file
set glasserDir = $surfDirAll'/glasser_roi/'$subjID'/masks/'
gunzip $glasserDir/*.nii.gz

convert_nifti_afni_volumes.sh $surfDirAll'/glasser_roi/'$subjID 'HCPMMP1' $epi_file

set roiDir = $rootDir'/roi/'$subjID'/'$sessionID
mkdir $rootDir'/roi/'$subjID
mkdir $roiDir

mv $surfDirAll'/glasser_roi/'$subjID'/'*RS+orig* $roiDir


#------------------- MTL ROIS ------------------# 
set epi_file = $afniDir'/glm/'$subjID'_'$sessionID'_task-main_run-1_space-T1w+orig'

# convert freesurfer volume files ('mgz') to afni +orig and resamples to matrix of template file
# arg1 = surfaces directory for that subject, eg surfaces/sub-018/; arg2 = filename, arg3= epifile to resample to with full path
convert_freesurfer_afni_volumes.sh $surfDir'/mri/' 'brain.mgz' $epi_file 
convert_freesurfer_afni_volumes.sh $surfDir'/mri/' 'lh.hippoSfLabels-T1.v10.mgz' $epi_file 
convert_freesurfer_afni_volumes.sh $surfDir'/mri/' 'rh.hippoSfLabels-T1.v10.mgz' $epi_file 
convert_freesurfer_afni_volumes.sh $surfDir'/mri/' 'aparc+aseg.mgz' $epi_file 

#only for hippocampal areas, convert to nii for tracing help
mri_convert $surfDir'/mri/lh.hippoSfLabels-T1.v10.mgz' $surfDir'/mri/'$subjID'_'$sessionID'lh.hippoSfLabels-T1.v10.mgz.nii'
mri_convert $surfDir'/mri/rh.hippoSfLabels-T1.v10.mgz' $surfDir'/mri/'$subjID'_'$sessionID'rh.hippoSfLabels-T1.v10.mgz.nii'

# convert the label files to afni volumes and resample those too
convert_freesurfer_afni_labels.sh $surfDir 'rh.perirhinal_exvivo' $epi_file 
convert_freesurfer_afni_labels.sh $surfDir 'lh.perirhinal_exvivo' $epi_file 
convert_freesurfer_afni_labels.sh $surfDir 'rh.entorhinal_exvivo' $epi_file 
convert_freesurfer_afni_labels.sh $surfDir 'lh.entorhinal_exvivo' $epi_file 

# move relevant results to roi directory

set roiDir = $rootDir'/roi/'$subjID'/'$sessionID

mv $surfDir'/mri/'*RS+orig* $roiDir
mv $surfDir'/label/'*RS+orig* $roiDir


cd $surfDir'/mri/'
mri_convert -i orig.mgz -o orig.nii
mv orig.nii $roiDir


#------------------- surface-based alignments ------------------# 
srun -p high -J surfing --mem=10000 -t 12:00:00 -u --pty tcsh -l
  # also works:--pty bash -il. if you want to run bash
   # to quit the job call 'exit'

set subjID = 'sub-018'
set sessionID = 'ses-2'
set topDir = '/home/aleshins/'
set rootDir = '/home/aleshins/2019_SL1/'
set progDir = $rootDir'code/'
set fmriPrepDir = $rootDir'fmri_prep/'
set epi_file = $fmriPrepDir'/output/fmriprep/'$subjID'/'$sessionID'/func/'$subjID'_'$sessionID'_task-main_run-1_space-T1w_desc-preproc_bold.nii.gz'
set surfDir =  $rootDir'/surfaces/'$sessionID'/'$subjID'/'
set afniDir = $rootDir'afni/'$subjID'/'
set run_num_loc = 2


module purge
module load afni freesurfer gsl
#load modules 
# module load matlab afni fmriprep singularity gsl bio3 freesurfer 

#call surfing, passing 1) surfaces generated with freesurfer's recon-all 2) a single epi file in native space, motion corrected, and aligned to anatomical 
  						  									  #directory of freesurfer surfaces   #epi file to align to																													#output dir							
python /home/aleshins/analysis_toolkit/surfing/python/prep_afni_surf.py -d $surfDir'/surf' -e  $epi_file -r  $surfDir'/ref/' -l128 -p 'all' 




#-------surface searchlights---------#
module load matlab afni fmriprep singularity gsl freesurfer

cd $progDir
matlab -nodisplay -r "surface_searchlight_associativeCoding('$subjID','$sessionID',[1:6],'$topDir'); exit"
matlab -nodisplay -r "surface_searchlight_relationalCat('$subjID','$sessionID','$topDir'); exit"
matlab -nodisplay -r "surface_searchlight_frequencyCat('$subjID','$sessionID','$topDir'); exit"
matlab -nodisplay -r "surface_searchlight_relCat_AT('$subjID','$sessionID','$topDir'); exit"
matlab -nodisplay -r "surface_searchlight_visualSim('$subjID','$sessionID','$topDir'); exit"

: # run t-tests over runs
matlab -nodisplay -r "surface_ttest_runs('$subjID','$sessionID',[1:6],'$topDir',1); exit"




#-------vol2Surf for Localizer GLMs--------#


set locBucketName = $subjID'_'$sessionID'_task-loc_run-'$run_num_loc'_bucket_T1w_blur4+orig' 
mv $afniDir'/display/'$locBucketName* $surfDir'/ref/'

cd $surfDir'/ref/'
3dVol2Surf -spec mh_ico128_al.spec -surf_A ico128_mh.smoothwm_al.asc -surf_B ico128_mh.pial_al.asc -sv $afniDir'/glm/'$subjID'_'$sessionID'_anat_desc-preproc_T1w+orig'  -grid_parent $locBucketName -map_func ave -out_nimls $locBucketName'_mh.niml.dset'
ConvertDset -o_niml_asc -input $locBucketName'_mh.niml.dset' -prefix $locBucketName'_c_mh.niml.dset'



if ( -e $fmriPrepDir'/'$subjID'/' ) then
	mkdir $fmriPrepDir'/input'/$subjID'/ses-1/'
    mv $fmriPrepDir'/'$subjID'/'* $fmriPrepDir'/input'/$subjID'/ses-1/'
    rm -r $fmriPrepDir'/'$subjID'/'
endif 

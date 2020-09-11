#! /usr/bin/tcsh


# code to process a participant & session


#enter interactive mode on the cluster: -t is time, 12:00:00 is 12 hours
#  this opens a tcsh shell on the cluster 
srun -p high -J sub-003 --mem=10000 -t 12:00:00 -u --pty tcsh -l
  # also works:--pty bash -il. if you want to run bash
   # to quit the job call 'exit'

set subjID = 'sub-003'
set sessionID = 'ses-1'

# project directories 
set topDir = '/home/aleshins/'
set rootDir = '/home/aleshins/2019_SL1/'
set fmriPrepDir = $rootDir'fmri_prep/'
set dicomDir = $rootDir'raw_data/'$subjID'/'$sessionID'/' 
set subjDir1 = $fmriPrepDir'input/'$subjID
set subjDir = $subjDir1'/'$sessionID'/' 
set progDir = $rootDir'code/'
set afniDir = $rootDir'afni/'$subjID'/'
set surfDir =  $rootDir'/surfaces/'$subjID'/'
set roiDir = $rootDir'/roi/'$subjID'/'$sessionID

set TR = '1.25'

set object_names_list = ('obj4' 'obj5' 'obj6' 'obj1')
#load modules 
module load matlab afni fmriprep singularity gsl bio3 freesurfer 

#------specify scan names ------------------

set scan1 =  $subjID'_'$sessionID'_task-main_run-1_bold' 
set scan2 =  $subjID'_'$sessionID'_task-main_run-2_bold' 
set scan3 =  $subjID'_'$sessionID'_task-main_run-3_bold' 
set scan4 =  $subjID'_'$sessionID'_task-main_run-4_bold' 

#create array of scan names 
set scan_list_main = ($scan1 $scan2 $scan3 $scan4)

# set scan_list_loc = ($loc1)

#------------------------run only once
# create BIDs directories in fmriprep folder
mkdir $subjDir1
mkdir $subjDir
cd  $subjDir 
mkdir anat func fmap 

#create directories in the afni folder 
mkdir $afniDir
mkdir $afniDir'regressors/'
mkdir $afniDir'glm/'

#ensure you are in the code directory (later: add to path)
cd $progDir

#-------read DICOMs and sort them into BIDS-style folders--------#
#assumes DICOMs are sorted into numbered folders by run; if they are not, use sortDicoms.sh 

#anatomical scan
# -o is the output folder, -f is the filename for the output, -z is compression, and last arg is the input folder 
dcm2niix_afni -o $subjDir'/anat/' -f $subjID'_'$sessionID'_T1w' -z y $dicomDir'/002'*

#function scans  - main task
# ***ensure the dicom directories are accurate! this has to be verified manually!
dcm2niix_afni -o $subjDir'/func/' -f $scan1 -z y $dicomDir'/004'*
dcm2niix_afni -o $subjDir'/func/' -f $scan2 -z y $dicomDir'/005'*
dcm2niix_afni -o $subjDir'/func/' -f $scan3 -z y $dicomDir'/006'*
dcm2niix_afni -o $subjDir'/func/' -f $scan4 -z y $dicomDir'/007'*

# edit functional file jsons 

./editJSON_func.sh $subjDir'func/' $scan1'.json' 'main'
./editJSON_func.sh $subjDir'func/' $scan2'.json' 'main'
./editJSON_func.sh $subjDir'func/' $scan3'.json' 'main'
./editJSON_func.sh $subjDir'func/' $scan4'.json' 'main'



#------------------------preprocess the data-----------------------------#
# for some reason, this only works if we start fresh with a new job - unknown why....
exit
screen 
srun -p high -u  --mem=14000 --nodes=1 -t 12:00:00 --pty tcsh -l
module load matlab afni fmriprep singularity

set subjID = 'sub-003'
set sessionID = 'ses-1'

# project directories 
set rootDir = '/home/aleshins/2019_SL1/'
set fmriPrepDir = $rootDir'fmri_prep/'

singularity run --cleanenv /share/apps/fmriprep-1.4.1/fmriprep.simg $fmriPrepDir'/input/' $fmriPrepDir'/output/' participant --fs-license-file $rootDir'/templates/' --participant_label $subjID -w $fmriPrepDir'/working/' -vv --output-spaces 'MNI152NLin2009cAsym' anat --fs-no-reconall --stop-on-first-crash --nthreads 2 --mem_mb 9000 --n_cpus 8


#this does not work but ideally should -- sometime we will figure it out :( 
# sbatch -p high -t 12:00:00 --mem=16000 runfMRIprep_bash.sbatch
# sbatch -p high -t 12:00:00 --mem=16000 batchtest.sbatch

exit 



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

#------------------- main task ------------------# 

#make array of the BOLD run files and corresponding array of obj#'s 
set scan_list_main = ($subjID'_'$sessionID'_task-main_run-1_space-')
set scan_list_main = ($scan_list_main $subjID'_'$sessionID'_task-main_run-2_space-')
set scan_list_main = ($scan_list_main $subjID'_'$sessionID'_task-main_run-3_space-')
set scan_list_main = ($scan_list_main $subjID'_'$sessionID'_task-main_run-4_space-')

set object_names_list = ('obj4' 'obj5' 'obj6' 'obj1')



set run_count = `seq 1 4`

set space = 'MNI152NLin2009cAsym'
set funcOutputDir = $fmriPrepDir'output/fmriprep/'$subjID'/'$sessionID'/func/'


foreach run_num($run_count)

set thisRun = $scan_list_main[$run_num]
set thisMask = $thisRun$space'_desc-brain_mask.nii.gz'
set thisObject = $object_names_list[$run_num]'_'
set thisConfoundFile = $subjID'_'$sessionID'_task-main_run-'$run_num'_desc-confounds_regressors.tsv'

: # : #pull up this run and get its # volumes
cd $funcOutputDir
set vols = `3dinfo -nv $thisRun$space'_desc-preproc_bold.nii.gz'`
echo $thisRun' has '$vols' volumes!'

: # : # copy the BOLD files and brain masks into glm directory and convert to afni format 
 3dcopy -verb $thisRun$space'_desc-preproc_bold.nii.gz' $afniDir'/glm/'$thisRun'MNI+tlrc'
3dcopy -verb $thisMask  $afniDir'/glm/'$thisMask'+tlrc'

: # : # also copy orig space
 3dcopy -verb $thisRun'T1w_desc-preproc_bold.nii.gz' $afniDir'/glm/'$thisRun'T1w+orig'
3dcopy -verb $thisRun'T1w_desc-brain_mask.nii.gz' $afniDir'/glm/'$thisRun'T1w_desc-brain_mask+orig'

: # : # smooth the functional data 
cd $afniDir'/glm/'
 3dmerge -1blur_fwhm 4 -doall -prefix  $thisRun'MNI_blur4' $thisRun'MNI+tlrc'
 3dmerge -1blur_fwhm 4 -doall -prefix  $thisRun'T1w_blur4' $thisRun'T1w+orig'

: # : # read in the tsv output from fmriprep for this run to pull out the nuisance regressors and save as 1D files in regressor directory
extractfMRIPrepRegressors.py $funcOutputDir$thisConfoundFile $afniDir'/regressors/' $subjID'_'$sessionID'_task-main_run-'$run_num 

: # : # waver the regressors 
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
matlab -nodisplay -r "objects=[1:6]; volume_searchlight_associativeCoding('$subjID','$sessionID',objects,'$topDir'); exit"
# matlab -nodisplay -r "objects=[1:6]; volume_searchlight_relationalCat('$subjID',objects,'$topDir'); exit"
: #call t-test over the runs 
# (subjID,runNames,homepath,whichData)
matlab -nodisplay -r "volume_ttest_runs('$subjID','$sessionID',[1,4:6],'$topDir',1); exit"




#------------------- localizer ------------------# 

#none collected for this subject








#------------------- surfaces ------------------# 

# select an epi file for alignment/resampling

set epi_file = $afniDir'/glm/'$subjID'_'$sessionID'_task-main_run-1_space-T1w+orig'

#create surface directory and copy files to it, converting to mgz format for recon-all
mkdir -p $surfDir'/mri/orig'
mri_convert $fmriPrepDir'/input/'$subjID'/'$sessionID'/anat/'$subjID'_'$sessionID'_T1w.nii.gz' $surfDir'/mri/orig/001.mgz'
# call recon-all via sbatch (this will run independently on the cluster for ~10 hours)
sbatch -p high -t 12:00:00 --mem=16000 run_reconall.sh $subjID $rootDir $sessionID


#------------------- once the above is complete ------------------# 

cd $progDir

echo $subjID >> $rootDir'/surfaces/'$subjID.txt
./create_subj_volume_parcellation.sh -L $subjID.txt -a HCPMMP1 -d glasser_roi -m YES -D $rootDir'/surfaces/'
# convert Glasser_ROIs to afni +orig and resample to matrix of template file
set glasserDir = $rootDir'surfaces/glasser_roi/'$subjID

mkdir $rootDir'/roi/'$subjID 
mkdir $rootDir'/roi/'$subjID'/'$sessionID
set roiDir = $rootDir'/roi/'$subjID'/'$sessionID

cp $glasserDir/*.nii.gz $roiDir
gunzip -k $glasserDir/*.nii.gz

convert_freesurfer_afni_volumes.sh '/home/aleshins/2019_SL1/surfaces/glasser_roi/'$subjID 'HCPMMP1' $epi_file


mv $glasserDir'/'*RS+orig* $roiDir


#------------------- MTL ROIS ------------------# 

# convert freesurfer volume files ('mgz') to afni +orig and resamples to matrix of template file
# arg1 = surfaces directory for that subject, eg surfaces/sub-001/; arg2 = filename, arg3= epifile to resample to with full path
convert_freesurfer_afni_volumes.sh $surfDir 'brain' $epi_file 
convert_freesurfer_afni_volumes.sh $surfDir 'lh.hippoSfLabels-T1.v10' $epi_file 
convert_freesurfer_afni_volumes.sh $surfDir 'rh.hippoSfLabels-T1.v10' $epi_file 
convert_freesurfer_afni_volumes.sh $surfDir 'aparc+aseg' $epi_file 

# convert the label files to afni volumes and resample those too
convert_freesurfer_afni_labels.sh $surfDir 'rh.perirhinal_exvivo' $epi_file 
convert_freesurfer_afni_labels.sh $surfDir 'lh.perirhinal_exvivo' $epi_file 
convert_freesurfer_afni_labels.sh $surfDir 'rh.entorhinal_exvivo' $epi_file 
convert_freesurfer_afni_labels.sh $surfDir 'lh.entorhinal_exvivo' $epi_file 

# move relevant results to roi directory
mkdir $rootDir'/roi/'$subjID 
mkdir $rootDir'/roi/'$subjID'/'$sessionID

mv $surfDir'/mri/'*RS+orig* $roiDir
mv $surfDir'/label/'*RS+orig* $roiDir


cd $surfDir'/mri/'
mri_convert -i orig.mgz -o orig.nii
mv orig.nii $roiDir

mv $surfDir'/mri/'*RS+orig* $roiDir
mv $surfDir'/label/'*RS+orig* $roiDir

srun -p high -J sub-003 --mem=10000 -t 12:00:00 -u --pty tcsh -l
  # also works:--pty bash -il. if you want to run bash
   # to quit the job call 'exit'

set subjID = 'sub-003'
set sessionID = 'ses-1'
set topDir = '/home/aleshins/'
set rootDir = '/home/aleshins/2019_SL1/'
set progDir = $rootDir'code/'
set fmriPrepDir = $rootDir'fmri_prep/'
set epi_file = $fmriPrepDir'/output/fmriprep/'$subjID'/'$sessionID'/func/'$subjID'_'$sessionID'_task-main_run-1_space-T1w_desc-preproc_bold.nii.gz'
set surfDir =  $rootDir'/surfaces/'$sessionID'/'$subjID'/'

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
matlab -nodisplay -r "surface_searchlight_associativeCoding('$subjID','$sessionID',[4:6],'$topDir'); exit"

: # run t-tests over runs
matlab -nodisplay -r "surface_ttest_runs('$subjID','$sessionID',[1,4:6],'$topDir',1); exit"


























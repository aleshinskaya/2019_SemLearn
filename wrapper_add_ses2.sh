# ADD TO TOP OF SCRIPT

if ( -e $fmriPrepDir'/input'/$subjID'/ses-1' ) then
   echo 'Directory for ses-1 exists'
   mv $fmriPrepDir'/input'/$subjID'/ses-1' $fmriPrepDir'/'$subjID'/'
   rm -r $fmriPrepDir'/working/reportlets/fmriprep/'$subjID
   rm -r $fmriPrepDir'/working/fmriprep_wf/single_subject_'$subjNum'_wf/'
  endif 


  # ADD TO BOTTOM
  
if ( -e $fmriPrepDir'/'$subjID'/' ) then
	mkdir $fmriPrepDir'/input'/$subjID'/ses-1/'
    mv $fmriPrepDir'/'$subjID'/'* $fmriPrepDir'/input'/$subjID'/ses-1/'
    rm -r $fmriPrepDir'/'$subjID'/'
endif 

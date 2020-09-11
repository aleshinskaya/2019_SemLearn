#!/bin/tcsh 

set subjID = $argv[1]
set rootDir = $argv[2]
set sessionID = $argv[3]

srun echo 'calling reconall for '$subjID'session '$sessionID


# load modules 
module load freesurfer perl


# fix paths
fixup_mni_paths
source /share/apps/freesurfer-6.0.0/SetUpFreeSurfer.csh

#call recon-all
recon-all -subject $subjID -sd $rootDir'/surfaces/'$sessionID'/' -all -hippocampal-subfields-T1

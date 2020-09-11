#! /usr/bin/tcsh

set subjID = $argv[1]
echo $subjID

module load afni

dicom_hdr -no_length '/home/aleshins/2019_SL1/raw_data/'$subjID'/ses-1/003_bold_shim_PA/0001.dcm'
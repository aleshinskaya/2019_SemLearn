

srun -p med -J group --mem=8000 -t 12:00:00 -u --pty tcsh -l
module load matlab freesurfer
matlab -nodisplay

# GROUP T-TEST

cd '/home/aleshins/2019_SL1/code/group' 
whichData=6; homepath='/home/aleshins/';
wrapper_ttest_subjects_volume(homepath,whichData)

whichData=5; homepath='/home/aleshins/';
wrapper_ttest_subjects_surface(homepath, whichData)

#ROI 

cd '/home/aleshins/2019_SL1/code/roi/' 
S = struct();
S.homepath ='/home/aleshins/'
S.subjects = {'sub-012'}
S.runs = [1:6]

S.session = 'ses-1'
S.runSearchlight=0;

roiFile=1;
roiNum=3;
analysisType=1;

results_all = wrapper_volume_ROI_subjects(S,roiFile,roiNum,analysisType);




# SINGLE SUBJECT SEARCHLIGHTS 

subjID = 'sub-015'
sessionID = 'ses-1'
runNames = [7:12]
volume_contrast_familiarityCoding(subjID,sessionID,runNames,homepath)
 whichData=7
volume_ttest_runs(subjID,sessionID,runNames,homepath,whichData)

volume_searchlight_visualSim(subjID,homepath)
volume_searchlight_relationalCat(subjID,homepath)
surface_searchlight_associativeCoding(subjID,runNames,homepath)
surface_searchlight_relationalCat(subjID,homepath)
surface_searchlight_frequencyCat(subjID,homepath)
surface_searchlight_relCat_AT(subjID,homepath)
surface_searchlight_visualSim(subjID,homepath)


runNames = [1:6]
volume_searchlight_associativeCoding(subjID,runNames,homepath)
whichData = 1
volume_ttest_runs(subjID,runNames,homepath,whichData)


cd '/home/aleshins/2019_SL1/code/group/' 
whichData=4
wrapper_ttest_subjects_volume(homepath,whichData)
wrapper_ttest_subjects_surface(homepath,whichData)



cd '/home/aleshins/2019_SL1/code/roi/' 

subjects = {'sub-001','sub-003','sub-004','sub-015','sub-016'} 

for i=1:length(subjects)



		for k=1:4

			wrapper_volume_saveROIData_subjects(subjects{i},{'obj1','obj2','obj3','obj4','obj5','obj6'},k)

		end
	
end
 


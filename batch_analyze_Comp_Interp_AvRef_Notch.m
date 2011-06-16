function batch_analyze_Comp_Interp_AvRef_Notch


inFileName = 's02_pb_CFS_P1_srate300_filt1-120_lab_ICA_Renamed_Pruned_Interp_Av-Ref_Notched.set';
inDir = '/home/lisandro/Desktop/EEG_CFS_BsAs/Data/finalSubjects_bsas_controls/s02/';
outDir = '/home/lisandro/Desktop/EEG_CFS_BsAs/Data/finalSubjects_bsas_controls/s02/';
bad_elec = 59;
components = []; %number of components to remove

addName='';
%addName = ''; % overwrite file
selectChannels = []; % 1: select first 128 channels, [] do not select
Av_reference = []; % Empty do not perform av_reference; 1 run av_ref
notchFilter = []; % Empty do not perform av_reference; 1 notch filter at 50Hz

analyze_Comp_Interp_AvRef_Notch (inFileName, bad_elec, components, inDir, outDir, ...
    addName, selectChannels, Av_reference, notchFilter)
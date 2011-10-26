function batch_analyze_Comp_Interp_AvRef_Notch


inFileName = 's07_aa_CFS_P1_srate300_filt1-120_lab_ICA_Renamed.set';
inDir = '/home/lisandro/Desktop/EEG_CFS_BsAs/Data/finalSubjects_bsas_controls/s07/';
outDir = '/home/lisandro/Desktop/EEG_CFS_BsAs/Data/finalSubjects_bsas_controls/s07/';
bad_elec = [8];
components = [8 19]; %number of components to remove

addName='_Pruned_Interp_Av-Ref_Notched';
%addName = ''; % overwrite file
selectChannels = 1; % 1: select first 128 channels, [] do not select
Av_reference = 1; % Empty do not perform av_reference; 1 run av_ref
notchFilter = 1; % Empty do not perform av_reference; 1 notch filter at 50Hz

analyze_Comp_Interp_AvRef_Notch (inFileName, bad_elec, components, inDir, outDir, ...
    addName, selectChannels, Av_reference, notchFilter)
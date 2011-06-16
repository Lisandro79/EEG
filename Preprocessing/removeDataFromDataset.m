function removeDataFromDataset (inFileName)

inDir= '/home/lisandro/Desktop/EEG_CFS_BsAs/Data/finalSubjects_bsas/s11/';
outDir= '/home/lisandro/Desktop/EEG_CFS_BsAs/Data/finalSubjects_bsas/s11/';

%Open and read .SET file into EEG structure
[ALLEEG EEG CURRENTSET] = eeglab;
EEG = pop_loadset('filename', inFileName,'filepath', inDir);

%Remove one or more time windows from the continuous dataset
timeToRemove= [1181 1186];
EEG = pop_select( EEG, 'notime',timeToRemove );

% Save Dataset.
pop_saveset( EEG, 'filename', EEG.filename, 'filepath', outDir);


function extractEpochs (inFileName)

% Take an epoched dataset and extract epochs corresponing to the different
% experimental conditions. Save each of this subsets to disk with an
% appropiate name.

inDir= '/home/lisandro/Work/Project_CFS/DataAnalysis/AvsT_S04AH/';
dir_out= '/home/lisandro/Work/Project_CFS/DataAnalysis/AvsT_S04AH/';
% name= strrep (inFileName, 'allEpochs_clean.set', '');
name= 'AvsT_S04AH_epch_manual';
% Load dataset
EEG = pop_loadset( 'filename', inFileName, 'filepath', inDir);

%% select the epochs among the different conditions
conditionName= '_seenTools'; % animals
epochs = num2cell(51:100); 
% Select epochs
EEGep = pop_epoch( EEG, epochs , [-1  1], 'newname', 'epochs', 'epochinfo', 'yes');
pop_saveset( EEGep, 'filename', [ name conditionName], 'filepath', dir_out);


%% todo

%Check AMAc's triggers because we used 1000 trials
%Check Gerhard's triggers because they should differ from Amac's


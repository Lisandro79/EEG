function EEG= loadEEGData (inFileName, inDir)

% This function loads a dataset 'inFileName' using EEGLAB, declares the EEG 
% structure as a GLOBAL variable so that other functions can access it by reference later
% on.
% The function returns: the fileName for the session label, the EEG
% structure with the raw data and all the information about it
% Example call: loadEEGData ('TestDataset.set', '')

% OPEN .SET FILE
if(~exist('pop_loadset',  'file')) % check if pop_loadset is in the path
    eeglab
    close(findobj('tag', 'EEGLAB')) % close menu window
end

% DECLARE EEG STRUCTURE AS GLOBAL SO THE DATA CAN BE ACCESSED BY REFERENCE 
% FROM OTHER FUNCTIONS.
global EEG
% LOAD SET
EEG = pop_loadset('filename', inFileName, 'filepath', inDir);










function urIndexes= renameEpochsExp (inFileName, trialsFile)

%This script renames events from an EEGlab dataset according to the values
% specified in the Exp structure. It returns the original indexes of the
% epochs that are renamed and saves a new dataset with the 'renamed' tag.

%inFileName: name of the .set file to rename
%trialsFile: name of the .mat file which contains the trials specifications

% Load Exp from .mat file with all the data about the trials
inDir= '/home/lisandro/Desktop/EEG_CFS_BsAs/Data/finalSubjects_bsas/s04/';
outDir= '/home/lisandro/Desktop/EEG_CFS_BsAs/Data/finalSubjects_bsas/s04/';
load([inDir trialsFile]);

%Open and read .SET file into EEG structure
[ALLEEG EEG CURRENTSET] = eeglab;
EEG = pop_loadset('filename', inFileName,'filepath', inDir); 

rawSetName = strrep(inFileName, '.set', '');

nevents = length(EEG.event);
epochCount= 0;
for i=1:nevents
%     if ischar(EEG.event(i).type) && strcmpi(EEG.event(i).type, '77')
    if EEG.event(i).type== 77
        epochCount= epochCount+1;
    end
end

sprintf('The total number of coded epochs is:\t%d', epochCount)

%Preallocate the index vector
urIndexes(1:epochCount)= 0;

if (length(Exp.Trial) ~= epochCount )
    sprintf('%s', ['The total number of epochs inside the dataset does not\n coincide' ...
        'with the total amount of trials on the Exp structure']);
end

% FIRST RENAME THE FIXATION CROSS AND THE RESPONSES: change them to strings
% (This values should be ideally out of the range of the stimuli codes but
% as the port values doesn't allow for it we need to recode them)
for m=1:length(EEG.event)
    if (EEG.event(m).type == 100) %fixation
        EEG.event(m).type= 'S100';
    elseif (EEG.event(m).type == 200) %response
        EEG.event(m).type= 'S200';
    elseif (EEG.event(m).type == 201) %response
        EEG.event(m).type = 'S201';
    elseif (EEG.event(m).type == 202) %response
        EEG.event(m).type = 'S202';
    elseif (EEG.event(m).type == 225) %mondrian start
        EEG.event(m).type = 'S225';
    end
end

% %RENAME THE EPOCHS
% m=0; %events counter
% for i=1:length(Exp.Trial)    
%     while(1)
%         m=m+1;
%         if (EEG.event(m).type== 77)
%             %Rename the Events
%             EEG.event(m).type = double(Exp.Trial(i).TrialCode); %Check the name here
%             urIndexes(i)= EEG.event(m).urevent; %Here we extract the original indexes
%             % of the epochs that are renamed.
%             break;
%         end
%         
%     end
% end

try
%RENAME THE EPOCHS
i=0; %events counter
for m=1:length(EEG.event)      
        if (EEG.event(m).type== 77)
            i=i+1;
            %Rename the Events
            EEG.event(m).type = double(Exp.Trial(i).TrialCode); %Check the name here
            urIndexes(i)= EEG.event(m).urevent; %Here we extract the original indexes
            % of the epochs that are renamed.
        end        
    
end
catch ME1
    rethrow(ME1)
end

EEG = eeg_checkset(EEG, 'eventconsistency');
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG,EEG,CURRENTSET); %#ok
% Save Dataset.
pop_saveset( EEG,  'filename', [rawSetName, '_Renamed'] , 'filepath', outDir); 
% save([outDir rawSetName '_urIndexes'], 'urIndexes');


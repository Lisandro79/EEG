
function extractEpochsBash_BsAs(inFileName, dir_in, dir_out, allEpochNums, allConditions, ...
   conditions, epochNums, timelimit, baseline)

try
    
%% Description:
% Select a continuous dataset (in which artifacts have usually been previouslty cleaned & preprocessed by hand), 
% extract all the epochs and create and epoched dataset, then run the automatic algorithms for artifact
% detection, save the cleaned epochs and the urIndexes.

% With the urIndexes extract the final clean epochs from the continuous 
% dataset and run PyMVPA. 
% With the urIndexes extract the filan clean epochs from the continuous dataset and run Dalponte's script (use pop_selectevent)

% Extract several datasets from the cleaned epoched dataset returned in the
% artifact removal corresponding to the different conditions (to run the ERPs)
% Save them to disk


%% Open EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab; %#ok
%load dataset
EEG = pop_loadset( 'filename',  inFileName, 'filepath', dir_in);
EEG = eeg_checkset( EEG );

% Define rawName
rawName= strrep(inFileName, '.set', '');


%% Create one epoched dataset with all conditions in order to remove the artifacts

% Extract epochs    
OUTEEG= pop_epoch( EEG, allEpochNums{:}, timelimit, 'newname', allConditions , 'epochinfo', 'yes');
OUTEEG = pop_rmbase( OUTEEG, baseline);
OUTEEG = eeg_checkset( OUTEEG );
% Save the epoched dataset   
pop_saveset(OUTEEG, 'filename', [rawName '_allEpochs.set'],'filepath', dir_out);    
%Clean the auxiliary variable to avoid problems
clear OUTEEG;	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RUN THE AUTOMATIC ARTIFACT REJECTION AND SAVE THE CLEAN EPOCH DATASET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[EEG_epoched, cleanIndexes, rejIndexes, indexes] =autoArtiDetection([rawName '_allEpochs.set'], dir_in, dir_out);


%% SELECT THE EPOCHS AMONG THE DIFFERENT CONDITIONS FROM THE EPOCHED DATA

for m=1: length(conditions) 
    % Extract epochs -from the automatically cleaned data-   
    OUTEEG = pop_epoch( EEG_epoched,  epochNums{m}, timelimit, 'newname', conditions{m}  , 'epochinfo', 'yes');
%     OUTEEG = pop_rmbase( OUTEEG, baseline);
    OUTEEG = eeg_checkset( OUTEEG );
    % Save with new name    
    pop_saveset(OUTEEG, 'filename', [rawName '_' conditions{m}],'filepath', dir_out);    
    %Clean the auxiliary variable to avoid problems
    clear OUTEEG;	
end



%% SELECT THE EPOCHS AMONG THE DIFFERENT CONDITIONS FROM THE CONTINUOUS DATA

% Load same continuous dataset as prior to the automatic artifact removal
% EEG = pop_loadset( 'filename',  inFileName, 'filepath', dir_in);
% EEG = eeg_checkset( EEG );

% For Dalponte's script: use the same loaded continuous dataset; just
% 'empty' the rejected events and save dataset with an aggregated name.
z=1;
rejIndexes= sort(rejIndexes);
for m=1:length(EEG.event)
    if ~isempty(rejIndexes) & EEG.event(m).urevent == rejIndexes(z) %#ok
        EEG.event(m).type='rej';
        z= z+1;
        if z>length(rejIndexes), break; end % to avoid exceeding matrix dimensions
    end
end
% Save dataset ready to be run with Dalponte's script
newName= 'Rej';
pop_saveset(EEG, 'filename', [rawName '_' newName],'filepath', dir_out);    

catch
   disp('ji') 
end


% For PyMVPA: take the latencies of the corresponding urevents and save 
% them as a two column vector, 

% JUST TRYDIFFERENTRESOLUTIONS WITH THE REJ DATASET: BY HAND

% Save the whole channel EEG.data as a .mat


% loop through EEG.event taking the type and latency of those
% that match the urevent and create the triggers matrix; save EEG.data



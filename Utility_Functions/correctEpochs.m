function correctEpochs (inFileName,inDir,outDir)

% The trigger for the beginning of the mondrians was left equal to the
% trigger of the target. With this function we change it to 101

try

    % LOAD RAW DATA
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab; %#ok
    EEG = pop_loadset( 'filename', inFileName,'filepath',inDir);
    rawSetName = strrep(inFileName, '.set', '');

    nevents = length(EEG.event);
    epochCount= 0;
    for i=1:nevents
        %     if ischar(EEG.event(i).type) && strcmpi(EEG.event(i).type, '77')
        if EEG.event(i).type== 100
            epochCount= epochCount+1;
        end
    end

    sprintf('The total number of coded epochs is:\t%d', epochCount)


    %RENAME THE EPOCHS
    for m=2:length(EEG.event) +1

        if EEG.event(m-1).type == 100
            %Rename the Events
            EEG.event(m).type = 101; %Check the name here
        end

    end
    
    EEG = eeg_checkset(EEG, 'eventconsistency');
    [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG,EEG,CURRENTSET); %#ok
    % Save Dataset.
    pop_saveset( EEG,  'filename', [rawSetName, '_Renamed'] , 'filepath', outDir);
    % save([outDir rawSetName '_urIndexes'], 'urIndexes');
    
    
    
    
catch ME1
    rethrow(ME1)
end



function [EEG, cleanIndexes, rejIndexes, indexes] =autoArtiDetection(inFileName, inDir, dir_out)

%% Load the EPOCHED dataset
EEG = pop_loadset('filename', inFileName,'filepath', inDir); 

%% Calculate the original Indexes: this part of the code does not work if
%% there are more than one urevents inside an epoch -should be specified
%% which urevent has to be considered-.
indexes= zeros(1,length(EEG.epoch));
for m=1:length(EEG.epoch)
    if length(EEG.epoch(m).eventurevent) < 3
        disp('ja')
    end
    indexes(m)= EEG.epoch(m).eventurevent{3};
end

%% Now do artifact detection and save results
p1=artidet_marco_mariano(EEG);
% save([dir_out 'S0' num2str(subj) 'p1'],'p1');
Tchans =5;
BCS=p1.BCS;
EEG=interpolate_epoched_data_mariano(EEG,BCS,Tchans);
%% Remember p1
EEG.p1=p1;

%% save
inFileName= strrep(inFileName, '.set', '');
EEG = pop_saveset(EEG, 'filename', [inFileName '_automCleaned.set'],'filepath', dir_out);

%% calculate the rejected epoch indexes (to use as parameter for the single
%% trial analysis). Careful with the number of urevents inside each epoch
cleanIndexes(length(EEG.epoch))= 0;
for m=1:length(EEG.epoch)
   cleanIndexes(m)= EEG.epoch(m).eventurevent{3}; 
end

rejIndexes= setdiff(indexes, cleanIndexes);

%% save
save([dir_out inFileName '_Indexes'], 'cleanIndexes','rejIndexes', 'indexes');

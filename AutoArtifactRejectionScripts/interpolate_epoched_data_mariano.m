% function interpolate_epoched_data(BCS)
%
% This fucntion interpolates bad channels for epoched data. 
% and replaces them on the EEG.data structure. 
% The list of bad channels, BCS, is a matrix of 1s (bad elctrode x epoch) and 0s (good) 
% The size of BCS is(number of channesl x number of epochs) 
% Tchans is the number of channels that need to be bad in an epcoh to consider the epoch bad

function EEG=interpolate_epoched_data_mariano(EEG,BCS,Tchans)
badchans_perepoch=sum(BCS);
rej_epochs=(badchans_perepoch>Tchans)';
%badepochs_perchan=sum(BCS')/size(BCS,2);
%badchans=find(badepochs_perchan > Tepochs);
EEG= pop_rejepoch(EEG,rej_epochs,0); % Reject epochs with bad channel number > Tchans
%[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
BCS=BCS(:,~rej_epochs); % Update the matrix of artifacts to eiminate rejected epochs
for i=1:EEG.trials
    badchans=find(BCS(:,i));
    if badchans
    EEG=interpolate_single_epoch_mariano(badchans,i,EEG);
    end
end


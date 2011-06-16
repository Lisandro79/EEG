% function interpolate_single_epoch(badchans,epoch)
%
% This fucntion interpolates bad channels from a specific epoch and
% replaces them on the EEG.data structure. 
% It requires EEG.chanlcos exists. 
% Inputs: the list of bad channels, the epoch number and the EEG structure
% The Number of Interpolating channels is set to 10.

function EEG=interpolate_single_epoch_mariano(badchans,epoch,EEG)
Numb_Interp=10; % The number of electrodes that will be used for interpolation
xpos=[EEG.chanlocs.X];ypos=[EEG.chanlocs.Y];zpos=[EEG.chanlocs.Z];
pos=[xpos',ypos',zpos']; % matrix with the position of all electrodes
goodchans=ones(1,EEG.nbchan);goodchans(badchans)=0;
dat=squeeze(EEG.data(:,:,epoch));
for i=1:max(size(badchans))
    P=pos(badchans(i),:);
    d=pos-repmat(P,EEG.nbchan,1);
    dist=sqrt(sum((d.*d),2));
    dist(badchans)=99999; % Make distance of badchannels infinite so not used for interpolation
    [y,I]=sort(dist); 
    repchas=I(2:Numb_Interp+1); % The closest channels 
    weightchas=exp(-y(2:Numb_Interp+1)); % The weight for averaging of a channel is exponential on the distance
    EEG.data(badchans(i),:,epoch)=sum(dat(I(1:10),:).*repmat(weightchas,1,size(dat,2)))/sum(weightchas);
end

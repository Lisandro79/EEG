function p1=artidet_marco_mariano(EEG)
% function p1=artidet_marco(EEG) computes matrix p1 containing list of bad
% channels per epoch as computed by Joy's artifact tool. Parameters are set
% below. Modified from batchavg.m (look there for the full name of the
% parameters)

p1.reref = 'off';
p1.maxBadChan = 10;
p1.BCList = [];
p1.BCExtra = [];
p1.eyeM = 'off';
p1.eyeB = 'off';
p1.eyeMT = 70;
p1.eyeBT = 70;
p1.method = 'both';
% p1.tf = 56;
% p1.td = 70;
p1.tf = 100; % IMPORTANT
p1.td = 100; % IMPORTANT
p1.fftFreqMin = 0;
p1.fftFreqMax = 20;
p1.fftP = 800000;
p1.minBase = '0';
p1.maxBase = '0';
p1.BaseLine = 'on';
p1.Dtrd = 'off';
p1.Outlier = 3;
p1.AutoBC ={'on'} ;
p1.AutoBCT = 70;
p1.DetrendAve = 'off';
p1.setName=EEG.setname;

%%%%%%%%%%%%%%%%%%  perform artifact detect  %%%%%%%%%%%%%%%%%%
[EEG,p1] = updateartifactdetect_marco_mariano(EEG,p1); % updating artifact detection parameters
p1=dete_marco_mariano(EEG,p1,'notShowResult'); % computing artifact detection matrix
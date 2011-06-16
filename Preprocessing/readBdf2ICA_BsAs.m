function [EEG] = readBdf2ICA_BsAs (inFileName,inDir,outDir)

% This function reads in the .SET format, applies 
% the correct electrode position data, filters data at 1 and 120 HZ, resamples data to
% 300HZ and runs ICA. 
% The output of this script can be used to identify artefactual components.
% EXAMPLE CALL: [EEG] = readBDF2ICA_BsAs (inFileName, subjectNumber)

% Modified to run on BigClic. Assume that there will be no problem with
% memory, so can load whole thing in one go.

tic
datestr(now) % print start time

% PATHS, INPUT
inFilePath = strcat(inDir, inFileName); %#ok

% % CONVERT BDF TO .SET USING CHANNEL 133 AS REFERENCE
% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab; %#ok
% EEG = pop_biosig([ inDir  inFileName], 'ref',133);
% EEG = pop_select(EEG, 'channel', 1:133);
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0, 'setname', subjectNumber, 'gui', 'off'); %#ok


% FILTERING
filter = [1 120];
downSample = (filter(2))*(2.5);


% OUTPUT
% rawSetName = sprintf('%s_lab', strrep(inFileName, '.set', ''));
rawFilePath = sprintf('%s%s_lab.set', outDir, strrep(inFileName, '.set', ''));
outSetName = sprintf('%s srate%i filt%i-%i lab ICA', inFileName, downSample, filter(1), filter(2));
outFilePath = sprintf('%s%s_srate%i_filt%i-%i_lab_ICA.set', outDir, strrep(inFileName, '.set', ''), downSample, filter(1), filter(2));

if exist(rawFilePath) %#ok CHECK IF THIS FILE ALREADY PROCESSED
	fprintf('### skipping %s, cos seems already taken care of\n', inFileName);
	return;
end

% LOAD RAW DATA
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab; %#ok
EEG = pop_loadset( 'filename', inFileName,'filepath',inDir); 
fprintf('### %s (contains total %i channels)\n', inFileName, EEG.nbchan);



%CHECK WHETHER THE FIRST EVENT IN DATA -USUALLY BOUNDARY- HAS LATENCY<1.
if (EEG.event(1).latency < 1)
    EEG = pop_editeventvals(EEG, 'delete',1);
%     EEG = pop_saveset( EEG);
end

% ADD CHANNEL LOCATION DATA
fprintf('\t### Adding electrode labels & locations\n');
channFile = 'coordinates136Ch.xyz';
EEG = pop_chanedit( EEG,  'load', {channFile, 'filetype', 'autodetect'});

% SAVE RAW EEGLAB FORMAT
% fprintf('\t### saving "%s" as "%s"\n', rawSetName, rawFilePath);
% EEG = pop_editset(EEG, 'setname',  rawSetName);
% EEG = pop_saveset( EEG,  'filename', rawSetName, 'filepath', outDir);
%[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);  % delete?

% FILTER AT 1HZ AND AT 120HZ
fprintf('\t### applying high-pass filter at %i Hz\n', filter(1));
EEG = pop_eegfilt( EEG, filter(1), 0, [], 0);
fprintf('\t### applying low-pass filter at %i Hz\n', filter(2));
EEG = pop_eegfilt( EEG, 0, filter(2), [], 0);

% DOWNSAMPLE TO 300HZ
fprintf('\t### downsampling to %i Hz\n', downSample);
EEG = pop_resample( EEG, downSample);

% % AVERAGE REFERENCE
% EEG = pop_reref( EEG, [], 'refstate',0);

% RUN ICA
fprintf('\t### doing ICA\n');
EEG = pop_runica(EEG,  'icatype', 'binica', 'options',{'extended',1});

% SAVE RESAMPLED, FILTERED, ICAed DATA
fprintf('\t### saving "%s" as "%s"\n', outSetName, outFilePath);
EEG = pop_editset(EEG, 'setname',  outSetName);
EEG = pop_saveset( EEG,  'filename', outFilePath, 'savemode', 'onefile');

datestr(now)
toc





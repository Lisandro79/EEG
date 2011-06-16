function fastEEGLAB (EEG)

% Display all windows for doing artifact removal
% -----------------------------------------------------------------

% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% EEG = pop_loadset( 'filename', dataSet , 'filepath', inDir);
% [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

pop_eegplot( EEG, 1, 1, 1);
pop_eegplot( EEG, 0, 1, 1);
pop_topoplot(EEG,0, 1:30 , [EEG.filename '_1:30'],[5 6] ,0, 'electrodes', 'on', 'masksurf', 'on');
pop_topoplot(EEG,0, 31:64 , [EEG.filename '_31:64'],[6 6] ,0, 'electrodes', 'on', 'masksurf', 'on');
eeglab redraw;

% EEGLAB history file generated on the 23-Mar-2009
% ------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset( 'filename', 'CFS_17102008_resamp300_filt1-120_labelled_ICAed_Pruned_Renamed.set', 'filepath', '/home/lisandro/Work/ERPs/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = pop_reref( EEG, [], 'refstate',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', 'reReferenced', 'savenew', '/home/lisandro/Work/ERPs/CFS_17102008_resamp300_filt1-120_labelled_ICAed_Pruned_Renamed_Re-Ref.set', 'gui', 'off'); 
ALLEEG = pop_delset( ALLEEG, [1] );
pop_saveh( ALLCOM, 'eeglabhist.m', '/home/lisandro/Work/ERPs/');
EEG = pop_epoch( EEG, {  'S  1'  }, [-1  1], 'newname', 'reReferenced epochs', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2, 'setname', 'S1', 'savenew', '/home/lisandro/Work/ERPs/CFS_17102008_resamp300_filt1-120_labelled_ICAed_Pruned_Renamed_Re-Ref_S1.set', 'gui', 'off'); 
EEG = pop_rmbase( EEG, [-1000     0]);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
pop_saveh( ALLCOM, 'eeglabhist.m', '/home/lisandro/Work/ERPs/');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'retrieve',2, 'study',0); 
EEG = pop_epoch( EEG, {  'S  1'  'S  2'  'S  3'  'S  4'  }, [-1  1], 'newname', 'reReferenced epochs', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2, 'gui', 'off'); 
EEG = pop_rmbase( EEG, [-1000     0]);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
eeglab redraw;

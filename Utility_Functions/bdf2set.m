[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_readbdf('/home/juank/Experimentos/CFS/EEG_2011/ap_CFS_P1_1-Deci.bdf', [1 1914] ,137,133);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','ap_CFS_P1.set','filepath','/home/juank/Experimentos/CFS/EEG_2011/');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% load coords_LNI_128_toreplaceinEEG
% EEG.chanlocs    = CHANS.chanlocs;
% EEG.urchanlocs  = CHANS.urchanlocs;
% EEG.chaninfo    = CHANS.chaninfo;
% EEG = eeg_checkset( EEG );
% EEG = pop_saveset( EEG, 'filename','ap_CFS_P1.set','filepath','/home/juank/Experimentos/CFS/EEG_2011/');
% [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

clear all
close all
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_readbdf('/home/juank/Experimentos/CFS/EEG_2011/pb_CFS_P1_1-Deci.bdf', [] ,137,133);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','pb_CFS_P1.set','filepath','/home/juank/Experimentos/CFS/EEG_2011/');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
eeglab redraw

% load coords_LNI_128_toreplaceinEEG
% EEG.chanlocs    = CHANS.chanlocs;
% EEG.urchanlocs  = CHANS.urchanlocs;
% EEG.chaninfo    = CHANS.chaninfo;
% EEG = eeg_checkset( EEG );
% EEG = pop_saveset( EEG, 'filename','ap_CFS_P1.set','filepath','/home/juank/Experimentos/CFS/EEG_2011/');
% [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

clear all
close all
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_readbdf('/home/juank/Experimentos/CFS/EEG_2011/jk_CFS_P1_1-Deci.bdf', [] ,137,133);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','jk_CFS_P1.set','filepath','/home/juank/Experimentos/CFS/EEG_2011/');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% load coords_LNI_128_toreplaceinEEG
% EEG.chanlocs    = CHANS.chanlocs;
% EEG.urchanlocs  = CHANS.urchanlocs;
% EEG.chaninfo    = CHANS.chaninfo;
% EEG = eeg_checkset( EEG );
% EEG = pop_saveset( EEG, 'filename','ap_CFS_P1.set','filepath','/home/juank/Experimentos/CFS/EEG_2011/');
% [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

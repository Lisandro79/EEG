function ERP = create_ERPs


% Collects data from different subjects and concatenates them into a single
% 4D matrix. This matrix is saved to disk for later processing

% To work, this function needs the data to be stored in the following way.
% Each subject data should be in a folder named 's01', 's02', ... 'sN' and
% inside that folder the data should be in a folder 'erps'


%% parameters for main Experiment bs as
% %Define the conditions of the experiment
% conditions = {'_seenAnimals', '_seenAnimalsScrambled' ,'_seenMeaningful', '_seenMeaningless', '_seenTools', '_seenToolsScrambled' ...
%     '_unseenAnimals',  '_unseenAnimalsScrambled', '_unseenMeaningful', '_unseenMeaningless', '_unseenTools', '_unseenToolsScrambled'};
% 
% condNames={'sA', 'sAscr' ,'sMF', 'sML', 'sT', 'sTscr', ...
%    'uA', 'uAscr' ,'uMF', 'uML', 'uT', 'uTscr'}; 
% % Define the directories where to look for the files
% inDir ='/home/lisandro/Desktop/EEG_CFS_BsAs/Data/finalSubjects_bsas/';
% outDir='/home/lisandro/Desktop/EEG_CFS_BsAs/Data/finalSubjects_bsas/';
% subjs = {'01' '03' '04' '05' '06' '07' '08' '09' '10' '11' '13' '15'}; 


%% perameters for control bs as

% Conditions names: this names must be part of the file name.
conditions= {'noMondrianAnimals'  'noMondrianAnimalsScrambled' 'noMondrianMeaningful' 'noMondrianMeaningless' 'noMondrianTools' 'noMondrianToolsScrambled' ...
    'lowMondrianAnimals' 'lowMondrianAnimalsScrambled' 'lowMondrianMeaningful' 'lowMondrianMeaningless' 'lowMondrianTools'  'lowMondrianToolsScrambled' ...
      }; 

condNames={'noMondA', 'noMondAscr','noMondMF', 'noMondML', 'noMondT', 'noMondTscr', ...
           'lowMondA', 'lowMondAscr',  'lowMondMF', 'lowMondML', 'lowMondT', 'lowMondTscr', ...
           }; 

% Define the directories where to look for the files
inDir ='/home/lisandro/Desktop/EEG_CFS_BsAs/Data/finalSubjects_bsas_controls/';
outDir='/home/lisandro/Desktop/EEG_CFS_BsAs/Data/finalSubjects_bsas_controls/';
subjs = {'01' '02' '03' '04' '05' '06'}; 

%% Collect ERPs

ERP = ERPs (conditions, condNames, subjs, inDir); 

save([outDir 'ERPs_Control'],'ERP', 'conditions', 'condNames', 'subjs');





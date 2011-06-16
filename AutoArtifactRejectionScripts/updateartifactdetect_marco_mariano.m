%In eeglab, artifact detect update EEG.event, but not EEG.urevent.
%eeglab doesn't use EEG.epoch

%clear up event to include only type TRSP
%from history file, edit -> select epochs/events 
%EEG = pop_selectevent( EEG,  'type',{ 'TRSP'}, 'deleteevents', 'on', 'deleteepochs', 'on');
%[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET);

%[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,  'setname', 'newTRSP', 'save', 'C:\WINDOWS\Desktop\eeglab4.311\data\newTRSP');


%%%%%%%%%%%%%%%%%%%%%%%%%  update event information  %%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%  save parameters  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%keep only TRSP type event in EEG.event
%EEG = pop_selectevent( EEG,  'type',{ 'TRSP'}, 'deleteevents', 'on', 'deleteepochs', 'on');
%[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET);

%function EEG = updateArtifactDetect(EEG,ALLEEG,CURRENTSET)
function [EEG,p1] = updateartifactdetect_marco_mariano(EEG,orip1)

p1=orip1;
BC = [];
BCE = [];

%compose bad channel list and bad channels to extrapolate list
bcL = p1.BCList;

if (~isempty(bcL)) & (isstr(bcL))
	count = 1;
	bc = '';
	
	[head rem] = strtok(bcL);
	if str2num(head) ~= 0
        bc(1).val = str2num(head);
        count = 2;
	end
	while ~isempty(rem)     
        [head rem] = strtok(rem);
        if ~isspace(head)
            if str2num(head) ~= 0
                bc(count).val = str2num(head);
                count = count + 1;
            end
        end
	end
	
	BC = [];
	if size(bc,1) ~= 0
        numBC = size(bc,2);
        for i = 1:numBC
            BC(1,i) = bc(i).val;
        end    
	end
	BC = sort(unique(BC));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bceL = p1.BCExtra;
%bceL = '0 1 3 4';
if ~isempty(bceL) & (isstr(bceL))
	count = 1;
	bce = '';
	
	[head rem] = strtok(bceL);
	if str2num(head) ~= 0
        bce(1).val = str2num(head);
        count = 2;
	end
	while ~isempty(rem)     
        [head rem] = strtok(rem);
        if ~isspace(head)
            if str2num(head) ~= 0
                bce(count).val = str2num(head);
                count = count + 1;
            end
        end
	end
	
	BCE = [];
	if size(bce,1) ~= 0
        numBC = size(bce,2);
        for i = 1:numBC
            BCE(1,i) = bce(i).val;
        end    
	end
	BCE = sort(unique(BCE));
end

p1.BCList = BC;
p1.BCExtra = BCE;

%update EEG.artifactDetect and EEG.event
EEG.artifactDetect.BC = BC;
EEG.artifactDetect.BCE = BCE;


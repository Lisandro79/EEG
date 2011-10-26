function ERP = ERPs (conditions, condNames, subjs, inDir)


Ncond = length(condNames);
Nsubj = length(subjs);

dirs= {Nsubj};
for su=1:Nsubj
    dirs{su} =[inDir,'s',subjs{su},'/erps/'];
end


ERPmedian.data = zeros(Nsubj,Ncond,128,750);
ERPmean.data = zeros(Nsubj,Ncond,128,750);

for su=1:Nsubj
    for co=1:Ncond
        fileName= dir([dirs{su} '*' conditions{co} '.set']);
        EEG = pop_loadset('filename', fileName.name, 'filepath', dirs{su});
        % Do not check the sets here, it takes as long as loading the file
%         EEG = eeg_checkset( EEG );        
        ERP.median.data(su,co,:,:) = median(EEG.data,3); % it takes 6 times longer that 'mean'
        ERP.mean.data(su,co,:,:) = mean(EEG.data,3);
    end
end

ERP.median.times = EEG.times;
ERP.mean.times = EEG.times;


end

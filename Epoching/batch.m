files = dir('*labelled.set');

for m=1: length(files)
    if m==1
        continue
    end
    [EEG] = readBrainVision2ICA_lisandro(files(m).name);
    
end
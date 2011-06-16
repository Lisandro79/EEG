%delete bad channels
function p1=dete_marco_mariano(EEG,orip1, show)

p1=orip1;

if strcmp(EEG.setname,'')
    errordlg('No data found. Please reopen artifact detect after data is loaded.','No Data Error');
else    

%tic
%h = waitbar(0,'Please wait.....'); 
%%%%%%%%%%%%%%%%%%%  Parameters start %%%%%%%%%%%%%%%%%%%%
%Assume data is in the current EEG dataset
%locData = EEG.data; %3D array chan x pnts x seg
%locEventSpec = EEG.epoch;

numChan = size(EEG.data,1);
numData = size(EEG.data,2);
numSeg = size(EEG.data,3);
TEMP= EEG.data;

%load t1p1;

%p1 value to be read from a file
%p1.avgRef = 'off';
%p1.BLCorrect = 'on';
%p1.BLStart = 0;
%p1.BLEnd = 1000;

p1.eye.a64.blink = [11 64 1 63 14 64 6 63 11 14 1 6];
p1.eye.a64.move = [19 60];
p1.eye.a128.blink = [26 127 8 126 33 127 1 126 26 33 8 1];
p1.eye.a128.move = [128 125];
p1.eye.a256.blink = [36 242 18 241 45 242 10 241 36 45 18 10];
p1.eye.a256.move = [251 227];


%convert the variables to the right format

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Detrend %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % I add a trial linear detrend ghis 15/2/2005
if strcmp(p1.Dtrd,'on')
 display('linear detrend of EEG.data is applied')
    for trial=1:EEG.trials
        aga(:,:)=EEG.data(:,:,trial);
        aga=detrend(aga');
        aga=aga';
        EEG.data(:,:,trial)=aga(:,:);
    end   
end


%%%%%%%%%%%%%%%%%%%%%%%%%%  Eye movement and blink detection  %%%%%%%%%%%%%%%%%%%%%%%%%%
EM = zeros(1,numSeg);
EB = zeros(1,numSeg);
EMB = EM;
conclusion = zeros(numChan, numSeg);

%%%%%%%%%%%%%%%%%%%%%  Eye Movement  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(p1.eyeM,'on')
    EM = zeros(1,numSeg);
    if (numChan == 64) || (numChan == 65)  
        eM1 = p1.eye.a64.move(1,1);
        eM2 = p1.eye.a64.move(1,2);       
    elseif (numChan == 128) || (numChan == 129)
        eM1 = p1.eye.a128.move(1,1);
        eM2 = p1.eye.a128.move(1,2);
    elseif (numChan == 256) || (numChan == 257)
        eM1 = p1.eye.a256.move(1,1);
        eM2 = p1.eye.a256.move(1,2);       
    end
    
	%d = abs(EEG.data(eM1,:,:) - EEG.data(eM2,:,:));
    d = EEG.data(eM1,:,:) - EEG.data(eM2,:,:);
    slowMM = d(:,1:10,:);
    slowM = mean(slowMM,2);
    slow = slowM;   
    %fast = slow; %modified for test
    fast = zeros(1,1,numSeg); %original algorithm
    maxFast = zeros(1,1,numSeg);    
    bad = zeros(1,1,numSeg);
                   
	for j=1:size(d,2)    
        diff = d(1,j,:);
        fast = 0.8*fast + 0.2*(diff-slow);
        slow = 0.975*slow + 0.025*diff;
        maxFast = max(abs(fast), maxFast);              
        %bad = abs(fast) > p1.eyeMT;  
	end%for   
    bad = maxFast > p1.eyeMT;   
    EM = reshape(bad,1,numSeg);
    
end %if do eye move
clear d slowMM slowM slow fast diff bad maxFast
% waitbar(0.1);

% %DEBUG
% chanMatrix = 1:1:numSeg;
% nonzeros(EM .* chanMatrix)'
% clear chanMatrix

%%%%%%%%%%%%%%%%%%%%%%%  Eye Blink  %%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(p1.eyeB,'on')   
	i = 1;
	while i <= numSeg
        detect = 0;
		cur = 1;%cur number of eye blink channel
        bad = 0;
        bothGood = 0;
		while (cur <= 12) & (detect == 0)
            if (numChan == 64) || (numChan == 65)
                a = EEG.data(p1.eye.a64.blink(1,cur),:,:);
                b = EEG.data(p1.eye.a64.blink(1,cur+1),:,:);
            elseif (numChan == 128) || (numChan == 129)
                a = EEG.data(p1.eye.a128.blink(1,cur),:,:);
                b = EEG.data(p1.eye.a128.blink(1,cur+1),:,:);
            elseif (numChan == 256) || (numChan == 257)
                a = EEG.data(p1.eye.a256.blink(1,cur),:,:);
                b = EEG.data(p1.eye.a256.blink(1,cur+1),:,:);    
            end
          
            aRes = segBC(a(1,:,i),p1.td,p1.tf);
            bRes = 1;
            if aRes == 0
                bRes = segBC(b(1,:,i),p1.td,p1.tf);
            end
            if (aRes == 0) & (bRes == 0)
                bothGood = 1;
            end    
            
            %eyeblink detection
            if bothGood == 1
                %d = abs(a-b);
                d = a-b;
				slowMM = d(:,1:10,:);
                slowM = mean(slowMM,2);
                slow = slowM(1,1,i);
                %fast = slow; 
                fast = zeros(1,1,1); %original algorithm             
				for j=1:numData       
                    diff = d(1,j,i);
                    fast = 0.8*fast + 0.2*(diff-slow);
                    slow = 0.975*slow + 0.025*diff;
                    if abs(fast) > p1.eyeBT
                        bad = 2;             
                    end
				end%for  
                detect = 1;
             else%eyeblink detection 
                cur = cur + 2;
             end
             
		end%while (cur <= 6) & (detect == 0)
        if detect == 0
            bad = 3;%all eye channels bad
        end
        EB(1,i) = bad;
        i = i + 1;
	end%while still seg left
        
end%do eye blink
% waitbar(0.4);


%%%%%%%%%%%%%%%%%%%%%%%  detect bad channels  %%%%%%%%%%%%%%%%%%%%%%%
varBC = zeros(numChan,1);
for i=1:numChan
    a = reshape(EEG.data(i,:,:),numData,numSeg);
    covB = sum(cov(a) == 0);
    if covB ~= 0
        varBC(i,1) = 6;
    end
end

if strcmp(p1.method,'fs') | strcmp(p1.method,'both')   
    %testing various ways to correct baseline
	meanA = mean(EEG.data,2);  %mean of all the points in the segment  
    first = EEG.data(:,1,:);  %the first point
    if mod(numData,2) == 0
        ha = numData/2;
    else
        ha = (numData+1)/2;
    end
    fHalf = EEG.data(:,1:ha,:);
    fHalf = mean(fHalf,2);  %mean of the first half of the points
    
	slowMM = EEG.data(:,1:10,:);
	slowM = mean(slowMM,2);  %mean of the first 10 points
	slow = slowM;
	%fast = slow;
	fast = zeros(numChan,1,numSeg);
	bad = zeros(numChan,1,numSeg);
    maxFast = zeros(numChan,1,numSeg);
    maxDiff = zeros(numChan,1,numSeg);


	for j=1:numData   
  
        %sv = EEG.data(:,j,:) - first; %sample voltage, original   
        sv = EEG.data(:,j,:) - meanA(:,1,:); %the avg of trial as baseline
        %sv = EEG.data(:,j,:) - fHalf;  %test baseline         
        
        fast = 0.8*fast + 0.2*sv;   
        slow = 0.975*slow + 0.025*sv;    
        diff = fast - slow;
        %25/07/04, added maxFast and maxDiff to save memory
         maxFast = max(abs(fast), maxFast);
         maxDiff = max(abs(diff), maxDiff);
        %works but demanding on memory
      % bad(:,j,:) = 3 * ( (abs(fast) > p1.tf) | (abs(diff) > p1.td) );      
	end%for  
    
    
    bad = 3 * ((maxFast>p1.tf) | (maxDiff>p1.td));
    %bad = mean(bad,2);

	conclusion = reshape(bad,numChan,numSeg);
    clear bad maxFast maxDiff;    
    conclusion(:,:) = 3 * (conclusion(:,:) > 0);
    
end

fftRes = [];
if strcmp(p1.method,'fft') | strcmp(p1.method,'both')
    thres = p1.fftP;
    freqMin = p1.fftFreqMin + 1; %Matrix start from 1 instead of 0
    freqMax = p1.fftFreqMax;
    len = 64;
    
    fa = fft(EEG.data,len,2);
    pfa = fa.*conj(fa)/len;
    
    %apply criterias and update conclusion
    pSum = sum(pfa(:,freqMin:freqMax,:),2);
    pSum = reshape(pSum,numChan,numSeg);
    fftRes = 5 * (pSum > thres);  
       
end
% waitbar(0.9);


%clear locData;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%update EMB based on EM and EB
%update conclusion based on eye movement/blink results 
for i = 1:numSeg
    if (EM(1,i) ~= 0) || (EB(1,i) ~= 0) % il existe un EM ou un EB
        EMB(1,i) = 1;
        conclusion(:,i) = 1;   
    end
end
%update based on zero variance, also on fft if applicable
for i = 1:numChan
    if varBC(i,1) == 6
        conclusion(i,:) = 6;      
    end
    %update based on fft result
    if size(fftRes,1) ~= 0
        for j = 1:numSeg
            if (fftRes(i,j) ~= 0) & (conclusion(i,j) == 0)
                conclusion(i,j) = fftRes(i,j);
            end
        end
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%reject segment based on Max bad channel
segConc = zeros(1,numSeg);
for i = 1:numSeg
    %only need to look at channel 1 since eyemove/blink affect all chan
    if (conclusion(1,i) == 1) || (conclusion(1,i) == 2) %eye move/blink
        segConc(1,i) = conclusion(1,i);
    else
        count = sum(conclusion(:,i)>2);
if count > (p1.maxBadChan * numChan / 100)      
%        if count > p1.maxBadChan
            segConc(1,i) = 3;
        end   
    end
end    

% ghis on �tudie la variance autour de la variance moyenne et on jette si
% trop importante dans chaque essai et chaque �lectrode

TEMP=EEG.data;
index=find(segConc ~= 0);
for i=1:size(index,2)
    TEMP(:,:,index(i))=0;
end
indexBad=find(conclusion >0);
for i=1:size(indexBad,1)
    chan=mod(indexBad(i),numChan);
    if chan==0
        chan=numChan;
    end  
    trial=(floor((indexBad(i)-1)/numChan))+1;
    TEMP(chan,:,trial)=0;
end    
cwd = pwd;
cd(tempdir);
%pack
cd(cwd)
TEMP2=reshape(TEMP,numChan,size(TEMP,2)*size(TEMP,3));
stdvoltage=std(TEMP2'); % STD calcul�e pour chaque electrode
[maxstd,indexmax]=max(stdvoltage);
meanvoltage=mean(std(TEMP2')); % fait la moyenne de la STD calcul�e pour chaque electrode
if strcmp(show,'showResult')  % ghis 3/5/05 
	figure
	plot(stdvoltage)
	hold
	aga=(ones(numChan)*meanvoltage);
	plot(aga,'r')
	display(['the mean standard deviation of the voltage is ' num2str(meanvoltage) ])
	display(['with a max of ' num2str(maxstd) ' for electrode ' num2str(indexmax)])
end
clear TEMP2;
STDA=std(TEMP,0,2);
indexstd=find(STDA>p1.Outlier*meanvoltage);
jajoute=0;
for i=1:size(indexstd,1)
    chan=mod(indexstd(i),numChan);
    if chan==0
        chan=numChan;
    end    
    trial=(floor((indexstd(i)-1)/numChan))+1;
    if conclusion(chan,trial)~=3 
        jajoute=jajoute+1;
        conclusion(chan,trial)=3;
    end    
end    
display(['Excluding trials with too much variance excluded ' num2str(jajoute) ' segments (not trials)'])


%close(h)%% waitbar 
%toc


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%output the results
    emp = sprintf('\n');
 
    numEM = sum(EM(1,:)~=0);
    numEB = sum(EB(1,:)~=0);
    numEMB = sum(EMB(1,:)~=0);
    sEMB = ['EM: ',num2str(numEM),' EB: ',num2str(numEB),' EMB: ',num2str(numEMB)];
    percentM = []; %matrix to keep the percentage information
    
    percent = 0;
    sAllChan = ' ';
    sChan=[];
    newOUT = '';
    chanMatrix = 1:1:numSeg;
    bList = 'all';
    
    %26/07/04
    %display list of bad segments for eyemove/blink
    %embList = mat2str(nonzeros(EM .* chanMatrix)');

	if size(nonzeros(EMB),1) ~= 0    
        embList = mat2str(nonzeros(EMB .* chanMatrix)');
	else
        embList = 'None.';
	end    

    sAllChan = ['Bad segment due to eye move/blink' emp embList emp];
    newOUT = strvcat('Bad segment due to eye move/blink',embList,blanks(2));
    
    %29/07/04
    %display list of bad segments other than due to the eyemove/blink
    %i.e. bad segments found due to > user entered threshold
    
    segBad = (segConc==3);
    if size(nonzeros(segConc),1) ~= 0    
        segBadList = mat2str(nonzeros(segBad.*chanMatrix)');
    else
        segBadList = 'None.';
    end    
    
    sAllChan = [sAllChan 'Bad segment not due to eye move/blink' emp segBadList emp];
    newOUT = strvcat(newOUT,'Bad segment not due to eye move/blink',segBadList,blanks(2));
    
    
    
	for i=1:numChan
        
%        count = sum(conclusion(i,:)>2);
%        numGood = sum((conclusion(i,:)~=1));
    %25/07/04 changed to display all bad (including eyemove/blink)
    count = sum(conclusion(i,:)>0);
    numGood = numSeg;
        
        %display bad segments for one channel
%        chanB = ((conclusion(i,:)==3) | (conclusion(i,:)==5));
        %25/07/04 changed to display all bad (including eyemove/blink)
        chanB = (conclusion(i,:)>0);
        indexB = chanB.*chanMatrix;
        if size(nonzeros(indexB),1) ~= 0
            bList = mat2str(nonzeros(indexB)');
        end
            
        if numGood ~= 0
            percent = 100*(count/numGood);
        end
        %update percentage matrix
        percentM(1,i) = percent;
        
        sChan = ['Channel ',num2str(i),' bad ',num2str(count),'(',num2str(percent,4),'%) times.'];
        %sAllChan = [sAllChan emp sChan];
        %disp(['fast: ',num2str(count3),' diff: ',num2str(count4),' var: ',num2str(count6)]);    
        
        if count == 0
%20/07/04 Don't display the channels that doesn't have bad segments            
%             newOUT = strvcat(newOUT,sChan);
%             sAllChan = [sAllChan emp sChan];
        else
            newOUT = strvcat(newOUT,sChan,bList);
            sAllChan = [sAllChan emp sChan emp bList];
        end
    end
    
	%compose stats for rejected segments
	numBC =sum(segConc(:,:)==3);
	numEMB =sum(segConc(:,:)==1);
	%numEB =sum(segConc(:,:)==2);
    %20/07/04
    numTotalGood = sum(segConc(:,:)==0);
	
    sBC = ['Number of segments rejected for bad channel: ',num2str(numBC),' out of ',num2str(numSeg),' (',num2str(numBC/numSeg*100),'%)'];
	sBE = ['Number of segments rejected for eye move/blink: ',num2str(numEMB),' out of ',num2str(numSeg),' (',num2str(numEMB/numSeg*100),'%)'];
 
    %20/07/04, display total good segment
    sGS = ['Number of good segments left: ',num2str(numTotalGood),' out of ',num2str(numSeg),' (',num2str(numTotalGood/numSeg*100),'%)'];

    
    %compose stats for percentage of bad channels
    chan = 1:1:numChan;
    
    chanB90 = (percentM >= 90);
    indexB90 = chanB90.*chan;
    if size(nonzeros(indexB90),1) ~= 0
        bList90 = ['Channel over 90% bad: ' mat2str(nonzeros(indexB90)')];
    else bList90 = ['Channel over 90% bad: none']; end
    
    chanB80 = (percentM >= 80);
    indexB80 = chanB80.*chan;
    if size(nonzeros(indexB80),1) ~= 0
        bList80 = ['Channel over 80% bad: ' mat2str(nonzeros(indexB80)')];
    else bList80 = ['Channel over 80% bad: none']; end
    
    chanB70 = (percentM >= 70);
    indexB70 = chanB70.*chan;
    if size(nonzeros(indexB70),1) ~= 0
        bList70 = ['Channel over 70% bad: ' mat2str(nonzeros(indexB70)')];
    else bList70 = ['Channel over 70% bad: none']; end
        
    chanB60 = (percentM >= 60);
    indexB60 = chanB60.*chan;
    if size(nonzeros(indexB60),1) ~= 0    
        bList60 = ['Channel over 60% bad: ' mat2str(nonzeros(indexB60)')];
    else bList60 = ['Channel over 60% bad: none']; end
    
    chanB50 = (percentM >= 50);
    indexB50 = chanB50.*chan;
    if size(nonzeros(indexB50),1) ~= 0
        bList50 = ['Channel over 50% bad: ' mat2str(nonzeros(indexB50)')];
    else bList50 = ['Channel over 50% bad: none']; end
    
    chanB40 = (percentM >= 40);
    indexB40 = chanB40.*chan;
    if size(nonzeros(indexB40),1) ~= 0
        bList40 = ['Channel over 40% bad: ' mat2str(nonzeros(indexB40)')];
    else bList40 = ['Channel over 40% bad: none']; end
    
    chanB30 = (percentM >= 30);
    indexB30 = chanB30.*chan;
    if size(nonzeros(indexB30),1) ~= 0
        bList30 = ['Channel over 30% bad: ' mat2str(nonzeros(indexB30)')];
    else bList30 = ['Channel over 30% bad: none']; end
    
    chanB20 = (percentM >= 20);
    indexB20 = chanB20.*chan;
    if size(nonzeros(indexB20),1) ~= 0
        bList20 = ['Channel over 20% bad: ' mat2str(nonzeros(indexB20)')];
    else bList20 = ['Channel over 20% bad: none']; end
    
    chanB10 = (percentM >= 10);
    indexB10 = chanB10.*chan;
    if size(nonzeros(indexB10),1) ~= 0
        bList10 = ['Channel over 10% bad: ' mat2str(nonzeros(indexB10)')];
    else bList10 = ['Channel over 10% bad: none']; end
    
    sPerBCd = strvcat(blanks(1),bList90,bList80,bList70,bList60,bList50,bList40,bList30,bList20,bList10,blanks(1));
    sPerBCf = [emp bList90 emp bList80 emp bList70 emp bList60 emp bList50 emp bList40 emp bList30 emp bList20 emp bList10 emp];
    
%Compose output strings    
%result = strvcat(blanks(2),newOUT,blanks(2),sBC,sBE);

%20/07/04
%result = strvcat(blanks(2),sBC,sBE,sPerBCd,blanks(2),'***  details  ***',blanks(2),newOUT);
result = strvcat(blanks(2),sBC,sBE,sGS,sPerBCd,blanks(2),'***  details  ***',blanks(2),newOUT);

%26/07/04
%fileOutString = [emp sBC emp sBE emp sPerBCf emp emp '***  details  ***' emp emp sAllChan];
fileOutString = [emp sBC emp sBE emp sGS emp sPerBCf emp emp '***  details  ***' emp emp sAllChan];

%display result
%msgbox doesn't work when string is too long.....
%h = msgbox(outString,'Artifact detect result','replace','creatMode');
%05/08/04
if strcmp(show,'showResult')
    testOutBox('test',result,EEG.filename,p1,fileOutString);
end    



%%%%%%%%%%%%%%%%%%%%%%%%%  update event information  %%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%  save parameters  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%compose segment conclusion
BS = segConc ~= 0;
%compose bad segment/channel matrix
BCS = conclusion ~= 0;

p1.BS = BS;
p1.BCS = BCS;
AutoChan = (percentM >= p1.AutoBCT);  % ghis  02/2005
AutoChan = AutoChan.*chan;
p1.checkBC= nonzeros(AutoChan)'
if strcmp(p1.AutoBC,'on')  
    display('I upgrade the BadChannel List')
  %  p1.BCList=num2str(p1.BCList);
   % p1.BCList = [p1.BCList ' ' p1.checkBC];
     p1.BCList = [p1.BCList p1.checkBC];
    
end    
% %save t1p1 p1;
% %updateArtifactDetect;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %save the percentage matrix to be used for topoplot
% setName = EEG.setname;
% save percentResult percentM setName;

end %if there is data loaded

%DEBUG
% chanMatrix = 1:1:numSeg;
% embList = mat2str(nonzeros(EMB .* chanMatrix)');
% BSList = mat2str(nonzeros(p1.BS .* chanMatrix)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %detect if one segment is bad, use only running average, called
  %only from eye blink detection
  %s: data of one channel, one segment
  %bDT: threshold differential, bFT: threshold fast
  function result = segBC(s,bDT,bFT)
  slow = mean(s(:,1:5));
  %fast = slow;
  fast = 0;
  bs = s - mean(s)*ones(1,size(s,2));
  result = 0; %default not bad channel
  for i=1:size(bs,2)
        sv = bs(1,i);
        fast = 0.8*fast + 0.2*sv;
        slow = 0.975*slow + 0.025*sv;
        diff = fast - slow;
        if (abs(diff) > bDT) || (abs(fast) > bFT)
            result = 1;
        end
  end


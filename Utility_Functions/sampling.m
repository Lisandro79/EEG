function sampling

population= rand(1,10000)*100;
% population= random('Uniform',50,15,1,10000);
% [ahat,bhat] = unifit(population);
samples= 1000;
samplesSize= 2;
y= zeros(samplesSize, samples);

for m=1:samples
%     dtemp = population(randperm(length(population)));
%     y(:,m) = dtemp(1:samplesSize);    
    y(:,m) = randsample(population,samplesSize, false)';    
end

%calculate the mean of each sample
means= mean(y);
[h,p,stats] = chi2gof(means)
[hLill ,plILL ,kstat,critval] = lillietest(means)
HK = kstest(means)

%plot the histogram of the means of each sample
if samplesSize==1 %just control that we are not averaging the only sample
    hist(y)
else
    histfit(means)
end


%% Book

% Computational statistics handbook with Matlab. Angel R Martinez


%% To test

% Test goodness of fit for different distributions

% [h,p,stats] = chi2gof(...)
% h = kstest(x) NEEDS SPECIFICATION OF CDF
% h = lillietest(x) against normality

% [ahat,bhat] = unifit(means);


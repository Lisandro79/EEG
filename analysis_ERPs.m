function analysis_ERPs (fileName, inDir)

%% To do

% Check the line of the Mondrians in the graph. The epochs are time locked
% with respect to the target start, therefore the previous mondrians are
% variable

% Add the bonferroni correction for the 30ms bins when we do the wilcoxon
% test. -plot only the p values < 0.025.


%% Load data

load([inDir fileName])

% (subjects, conditions, channels, samples)
ERP= ERP.median;

% Grand ERPs for all conditions
gERP    = squeeze(mean(ERP.data,1));
% Target - scramble ERPs for 6 conditions: sA, sMF, sT, uA, uMF, uT.
dERP    = squeeze(mean( ERP.data(:,1:2:end,:,:)-ERP.data(:,2:2:end,:,:) )); % target - scrambled

times   = ERP.times;

load coords_LNI_128_toreplaceinEEG


%% Plot the ERPs for the conditions of dERP simultaneously

TITLES              = {'sA','sT','s(A+T)','uA','uT','u(A+T)'};
conditions          = [1 2];
conditionsToPlot    = {TITLES{1} TITLES{2} };
name                = cat(2, TITLES{1}, '_', TITLES{2});
color               = rainbow_colors(length(TITLES));
color               = color(conditions,:); % to keep a constant color for each condition across graphs

for chan = 1:128;   
    z= figure(100);
    set(z, 'visible', 'off')
    set(z,'Color','w',...
        'Position',[0 0 1280 500])
    set(z, 'PaperPositionMode', 'auto')
    set(z, 'InvertHardcopy', 'off')

    box on
    hold on
    title(['TARGET - SCRAMBLED: ',CHANS.chanlocs(chan).labels])
    ylimits         = [-4 4];

    % format
    xlimits         = [-1000 max(times)];%[min(times) max(times)];
    xmondrians_on   = [-500 -500];
    xstimulus_on    = [0 0];
    xstimulus_off   = [600 600];
    xmondrians_off  = [900 900];

    hLine1=plot(xmondrians_on, ylimits,'k-'); text(xmondrians_on(1),ylimits(2)-1,  'mondrians ON', 'HorizontalAlignment','Right')
    hLine2=plot(xstimulus_on,  ylimits,'k-'); text(xstimulus_on(1),ylimits(2)-1,   'stimulus ON', 'HorizontalAlignment','Right')
    hLine3=plot(xstimulus_off, ylimits,'k-'); text(xstimulus_off(1),ylimits(2)-1,  'stimulus OFF', 'HorizontalAlignment','Right')
    hLine4=plot(xmondrians_off,ylimits,'k-'); text(xmondrians_off(1),ylimits(2)-1, 'mondrians OFF', 'HorizontalAlignment','Right')

    set(get(get(hLine1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    set(get(get(hLine2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    set(get(get(hLine3,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    set(get(get(hLine4,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend

    set(gca,'XLim',xlimits,'YLim',ylimits)
    xlabel('Time (ms)');
    ylabel('Voltage (uV)');

    for co=1:length(conditionsToPlot)
        p(co)= plot(times,smooth(squeeze(dERP(conditions(co),chan,:))),'Color',color(co,:),'LineStyle','-','LineWidth',2);        
    end
    hold off
    legend(p,conditionsToPlot,'Location','NorthWest')
    print(z,'-dpng','-loose', ['erp_target-scrambled_ch',CHANS.chanlocs(chan).labels, name])
    close 100
end


%% Plot the ERPs for the conditions of gERP simultaneously

TITLES              = { 'sA', 'sAscr' ,'sMF', 'sML', 'sT', 'sTscr',...
                        'uA', 'uAscr' ,'uMF', 'uML', 'uT', 'uTscr'};
conditions          = [3 4];
conditionsToPlot    = {TITLES{3} TITLES{4} };
name                = cat(2, TITLES{3}, '_', TITLES{4});
color               = rainbow_colors(length(TITLES));
color               = color([1 6],:); % to keep a constant color for each condition across graphs

for chan = 1:128;   
    z= figure(100);
    set(z, 'visible', 'off') % makes the figure invisible. Saves time when there are many plots
    set(z,'Color','w',...
        'Position',[0 0 1280 500])
    set(z, 'PaperPositionMode', 'auto') % sets the position of the figure
    set(z, 'InvertHardcopy', 'off') % Don't know what exactly does yet... just copied it from the help

    box on
    hold on
    title(['TARGET - SCRAMBLED: ',CHANS.chanlocs(chan).labels])
    ylimits         = [-4 4];

    % format
    xlimits         = [-1000 max(times)];%[min(times) max(times)];
    xmondrians_on   = [-500 -500];
    xstimulus_on    = [0 0];
    xstimulus_off   = [600 600];
    xmondrians_off  = [900 900];

    hLine1=plot(xmondrians_on, ylimits,'k-'); text(xmondrians_on(1),ylimits(2)-1,  'mondrians ON', 'HorizontalAlignment','Right')
    hLine2=plot(xstimulus_on,  ylimits,'k-'); text(xstimulus_on(1),ylimits(2)-1,   'stimulus ON', 'HorizontalAlignment','Right')
    hLine3=plot(xstimulus_off, ylimits,'k-'); text(xstimulus_off(1),ylimits(2)-1,  'stimulus OFF', 'HorizontalAlignment','Right')
    hLine4=plot(xmondrians_off,ylimits,'k-'); text(xmondrians_off(1),ylimits(2)-1, 'mondrians OFF', 'HorizontalAlignment','Right')

    set(get(get(hLine1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    set(get(get(hLine2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    set(get(get(hLine3,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    set(get(get(hLine4,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend

    set(gca,'XLim',xlimits,'YLim',ylimits)
    xlabel('Time (ms)');
    ylabel('Voltage (uV)');

    for co=1:length(conditionsToPlot)
        % Saving the handle of each ba
        p(co)= plot(times,smooth(squeeze(gERP(conditions(co),chan,:))),'Color',color(co,:),'LineStyle','-','LineWidth',2);        
    end
    hold off
    legend(p,conditionsToPlot,'Location','NorthWest')
%     legend('sA','sT','s(A+T)','uA','uT','u(A+T)','Location','NorthWest')
    print(gcf,'-dpng','-loose', ['erp_target-scrambled_ch',CHANS.chanlocs(chan).labels, name])
    close 100
end



%% Raster plots dERP

TITLES = {'sA','sT','s(A+T)','uA','uT','u(A+T)'};
% Choose conditions to plot
CO = [1 2 3];
figure(10);
set(gcf,'Color','w',...
    'Position',[0 0 1280 500])
set(gcf, 'PaperPositionMode', 'auto')
set(gcf, 'InvertHardcopy', 'off')

for co=1:2
    subplot(2,1,co)
    box on
    hold on
    title([TITLES{CO(co)},' (target-scrambled): allchans'])
    ylimits         = [1 128];
    imagesc(times,1:128,squeeze(dERP(CO(co),:,:)),[-2.5 2.5]);

    % formato
    xlimits         = [-1000 max(times)];%[min(times) max(times)];
    xmondrians_on   = [-500 -500];
    xstimulus_on    = [0 0];
    xstimulus_off   = [600 600];
    xmondrians_off  = [900 900];


    % if co==1;
    text(xmondrians_on(1),  ylimits(1)-1,  'mondrians ON', 'HorizontalAlignment','Right')
    text(xstimulus_on(1),   ylimits(1)-1,   'stimulus ON', 'HorizontalAlignment','Right')
    text(xstimulus_off(1),  ylimits(1)-1,  'stimulus OFF', 'HorizontalAlignment','Right')
    text(xmondrians_off(1), ylimits(1)-1, 'mondrians OFF', 'HorizontalAlignment','Right')
    % end

    hLine1=plot(xmondrians_on, ylimits,'k-');
    hLine2=plot(xstimulus_on,  ylimits,'k-');
    hLine3=plot(xstimulus_off, ylimits,'k-');
    hLine4=plot(xmondrians_off,ylimits,'k-');

    set(get(get(hLine1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    set(get(get(hLine2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    set(get(get(hLine3,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    set(get(get(hLine4,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend

    set(gca,'XLim',xlimits,'YLim',ylimits)
    ylabel('Channel');
    %                 if co==2
    xlabel('Time (ms)');
    %                 else
    %                     set(gca,'XTick',[]);
    %                 end
    hold off
    colorbar
end
print(gcf,'-depsc2', '-loose',['erp_target-scrambled_allchan_',TITLES{CO(1)},'_',TITLES{CO(2)}])
close 10
%     legend('A ','T ','MF','Location','SouthEast')



%% Raster plots gERP

TITLES = { 'sA', 'sAscr' ,'sMF', 'sML', 'sT', 'sTscr',...
    'uA', 'uAscr' ,'uMF', 'uML', 'uT', 'uTscr'};
% Choose conditions to plot
CO = [9 10];
figure(10);
set(gcf,'Color','w',...
    'Position',[0 0 1280 500])
set(gcf, 'PaperPositionMode', 'auto')
set(gcf, 'InvertHardcopy', 'off')

for co=1:2
    subplot(2,1,co)
    box on
    hold on
    title([TITLES{CO(co)},' (target-scrambled): allchans'])
    ylimits         = [1 128];
    imagesc(times,1:128,squeeze(gERP(CO(co),:,:)),[-2.5 2.5]);

    % formato
    xlimits         = [-1000 max(times)];%[min(times) max(times)];
    xmondrians_on   = [-500 -500];
    xstimulus_on    = [0 0];
    xstimulus_off   = [600 600];
    xmondrians_off  = [900 900];


    % if co==1;
    text(xmondrians_on(1),  ylimits(1)-1,  'mondrians ON', 'HorizontalAlignment','Right')
    text(xstimulus_on(1),   ylimits(1)-1,   'stimulus ON', 'HorizontalAlignment','Right')
    text(xstimulus_off(1),  ylimits(1)-1,  'stimulus OFF', 'HorizontalAlignment','Right')
    text(xmondrians_off(1), ylimits(1)-1, 'mondrians OFF', 'HorizontalAlignment','Right')
    % end

    hLine1=plot(xmondrians_on, ylimits,'k-');
    hLine2=plot(xstimulus_on,  ylimits,'k-');
    hLine3=plot(xstimulus_off, ylimits,'k-');
    hLine4=plot(xmondrians_off,ylimits,'k-');

    set(get(get(hLine1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    set(get(get(hLine2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    set(get(get(hLine3,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    set(get(get(hLine4,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend

    set(gca,'XLim',xlimits,'YLim',ylimits)
    ylabel('Channel');
    %                 if co==2
    xlabel('Time (ms)');
    %                 else
    %                     set(gca,'XTick',[]);
    %                 end
    hold off
    colorbar
end
print(gcf,'-depsc2', '-loose',['erp_target-scrambled_allchan_',TITLES{CO(1)},'_',TITLES{CO(2)}])
close 10
%     legend('A ','T ','MF','Location','SouthEast')







%% Topographical plots??

cond    = 1; % condition
t       = 100; % Time
figure;
set(gcf,'Color','w')
[aux mom] = min(abs(ERP.times-t));
title(['Time = ',num2str(ERP.times(mom)),'ms']);
topoplot(squeeze(dERP(cond,:,mom)), CHANS.chanlocs,'maplimits',[-2.5 2.5],'plotrad' ,0.7,'electrodes' ,'on');



%% Estadistica: t-test
% First Run: P =run_ttest(1,4). Runs the t-test for every channel and every sample
% across subjects, for the conditions specified. It saves the matrix with
% the p-values in a .mat 

% Once the data is saved to disk we can plot the conditions with the ttest
% condition

%% Estadistica: wilcoxon
% First Run P=run_wilcoxon(co1,co2)

TITLES = {'sMF_sML','sA_uA','sT_uT','sAT_uAT','sA_sT','uA_uT'};

for k =1:1 % length(TITLES)
    
    testToPlot= 'wilcoxon_'; % Use 'ttest_' or 'wilcoxon_'
    load([testToPlot,TITLES{k}]);
    
    figure(1);
    set(gcf,'Color','w',...
        'Position',[0 0 1280 500])
    set(gcf, 'PaperPositionMode', 'auto')
    set(gcf, 'InvertHardcopy', 'off')
    box on
    hold on
    title([testToPlot ' ' 'P-value: ',TITLES{k},' (target-scrambled): allchans'])
    ylimits         = [1 128];
    imagesc(times,1:128,P,[0 0.01]); colormap bone

    % formato
    xlimits         = [-1000 max(times)];%[min(times) max(times)];
    xmondrians_on   = [-500 -500];
    xstimulus_on    = [0 0];
    xstimulus_off   = [600 600];
    xmondrians_off  = [900 900];

    text(xmondrians_on(1),  ylimits(2)-3,  'mondrians ON', 'HorizontalAlignment','Right')
    text(xstimulus_on(1),   ylimits(2)-3,   'stimulus ON', 'HorizontalAlignment','Right')
    text(xstimulus_off(1),  ylimits(2)-3,  'stimulus OFF', 'HorizontalAlignment','Right')
    text(xmondrians_off(1), ylimits(2)-3, 'mondrians OFF', 'HorizontalAlignment','Right')

    hLine1=plot(xmondrians_on, ylimits,'k-','LineWidth',2.5);
    hLine2=plot(xstimulus_on,  ylimits,'k-','LineWidth',2.5);
    hLine3=plot(xstimulus_off, ylimits,'k-','LineWidth',2.5);
    hLine4=plot(xmondrians_off,ylimits,'k-','LineWidth',2.5);

    set(get(get(hLine1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    set(get(get(hLine2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    set(get(get(hLine3,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    set(get(get(hLine4,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend

    set(gca,'XLim',xlimits,'YLim',ylimits,'LineWidth',5)
    ylabel('Channel');
    xlabel('Time (ms)');
    hold off
    colorbar
    print(gcf,'-depsc2','-loose', [testToPlot '_' 'pvalue_target-scrambled_allchan_',TITLES{k}])
%     close(1)

    %%
    pthr = 0.05;

    P_subthr = (P<pthr);

    N = 9; % 20ms

    U = zeros(size(P,1),size(P,2)-N,N);
    for i = 1:N
        U(:,:,i) = (P_subthr(:,i:end-N+(i-1))==1);
    end

    V = (sum(U,3)==N);

    W = zeros(size(P,1),size(P,2));
    for i = 1:N
        W(:,i:end-N+(i-1)) = W(:,i:end-N+(i-1)) + V;
    end
    W = (W>0);

    figure(2);imagesc(times,1:128,1-W); colormap bone
%     close(2)
    %%
    PP= P;
    PP(~W)=1;

    figure;
    set(gcf,'Color','w',...
        'Position',[0 0 1280 500])
    set(gcf, 'PaperPositionMode', 'auto')
    set(gcf, 'InvertHardcopy', 'off')
    box on
    hold on
    title([testToPlot ' ' 'P-value Corrected (BIN=',num2str(N),'): ',TITLES{k},' (target-scrambled): allchans'])
    ylimits         = [1 128];
    imagesc(times,1:128,PP,[0 0.05]); colormap bone

    % formato
    xlimits         = [-1000 max(times)];%[min(times) max(times)];
    xmondrians_on   = [-500 -500];
    xstimulus_on    = [0 0];
    xstimulus_off   = [600 600];
    xmondrians_off  = [900 900];

    text(xmondrians_on(1),  ylimits(2)-3,  'mondrians ON', 'HorizontalAlignment','Right')
    text(xstimulus_on(1),   ylimits(2)-3,   'stimulus ON', 'HorizontalAlignment','Right')
    text(xstimulus_off(1),  ylimits(2)-3,  'stimulus OFF', 'HorizontalAlignment','Right')
    text(xmondrians_off(1), ylimits(2)-3, 'mondrians OFF', 'HorizontalAlignment','Right')

    hLine1=plot(xmondrians_on, ylimits,'k-','LineWidth',2.5);
    hLine2=plot(xstimulus_on,  ylimits,'k-','LineWidth',2.5);
    hLine3=plot(xstimulus_off, ylimits,'k-','LineWidth',2.5);
    hLine4=plot(xmondrians_off,ylimits,'k-','LineWidth',2.5);

    set(get(get(hLine1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    set(get(get(hLine2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    set(get(get(hLine3,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    set(get(get(hLine4,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend

    set(gca,'XLim',xlimits,'YLim',ylimits,'LineWidth',5)
    ylabel('Channel');
    xlabel('Time (ms)');
    hold off
    colorbar
    print(gcf,'-depsc2','-loose', [testToPlot '_' 'pvalue_corrected_target-scrambled_allchan_',TITLES{k}])

    %%
    t = [200 220 240 260 280 300 320 340];
    figure;
    set(gcf,'Color','w',...
        'Position',[0 0 1280 500])
    set(gcf, 'PaperPositionMode', 'auto')
    set(gcf, 'InvertHardcopy', 'off')
    for i=1:length(t)
        subplot(2,length(t)/2,i);
        [aux mom] = min(abs(ERP.times-t(i)));
        hold on
        title(['Time = ',num2str(ERP.times(mom)),'ms']);
        topoplot(squeeze(PP(:,mom)), CHANS.chanlocs,'maplimits',[0 0.05],'plotrad' ,0.7,'electrodes' ,'on','style','map');
        hold off
        colormap bone
    end    
    print(gcf,'-dbmp','-loose', [testToPlot '_' 'pvalue_corrected_target-scrambled_topoplot_220ms_',TITLES{k}])
%     close(4)
    %%
    t = [480 500 520 540];
    figure;
    set(gcf,'Color','w',...
        'Position',[0 0 1280 500])
    set(gcf, 'PaperPositionMode', 'auto')
    set(gcf, 'InvertHardcopy', 'off')
    for i=1:length(t)
        subplot(1,length(t),i);
        [aux mom] = min(abs(ERP.times-t(i)));
        hold on
        title(['Time = ',num2str(ERP.times(mom)),'ms']);
        topoplot(squeeze(PP(:,mom)), CHANS.chanlocs,'maplimits',[0 0.05],'plotrad' ,0.7,'electrodes' ,'on','style','map');
        hold off
        colormap bone
    end    
    print(gcf,'-dbmp','-loose', [testToPlot '_' 'pvalue_corrected_target-scrambled_topoplot_520ms_',TITLES{k}])

end

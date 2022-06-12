% a script to import data, process it, and generate figures

%% IMPORT && CLEAN UP DATA
n_files = 2;
filenames = {'MA_Exer_PikesPeak_Females.txt';'MA_Exer_PikesPeak_Males';};
flabel = {'Females';'Males';};

if ~exist('data_f','var') || ~exist('data_m','var')
    % import data
    data_f = readtable('MA_Exer_PikesPeak_Females.txt');
    data_m = readtable('MA_Exer_PikesPeak_Males.txt');

    % clean up and pre-process data
    data_f = Deloitte_DataClean(data_f);
    data_m = Deloitte_DataClean(data_m);
end

% create an alternate data set where everyone is sorted into their divisions
% dim 1: divisions 
% dim 2: gender
div_data = cell(9,2); % creates a series of tables of different sizes
n_female = size(data_f,1);
n_male = size(data_m,1);

for i = 1:n_female
    d_ind = data_f{i,2};
    if d_ind ~= -1
        div_data{d_ind,1} = [div_data{d_ind,1};data_f(i,:)];
    end
end

for i = 1:n_male
    d_ind = data_m{i,2};
    if d_ind ~= -1
        div_data{d_ind,2} = [div_data{d_ind,2};data_m(i,:)];
    end
end

%% PREPARATION
bins = 25:2:100;
a_bold = 0.8;
a_thin = 0.2;

%% 1) What are the mean, median, mode, and range of the race results for all racers by gender?
net_time_f = cell2mat(data_f{:,10});
net_time_m = cell2mat(data_m{:,10});

% dim 1, mean median mode min max (in that order)
% dim 2, female male (in that order)
nt_stats = zeros(5,2);

% females
nt_stats(1,1) = mean(net_time_f,'all');
nt_stats(2,1) = median(net_time_f,'all');
nt_stats(3,1) = mode(net_time_f,'all');
nt_stats(4,1) = min(net_time_f,[],'all');
nt_stats(5,1) = max(net_time_f,[],'all');

% males
nt_stats(1,2) = mean(net_time_m,'all');
nt_stats(2,2) = median(net_time_m,'all');
nt_stats(3,2) = mode(net_time_m,'all');
nt_stats(4,2) = min(net_time_m,[],'all');
nt_stats(5,2) = max(net_time_m,[],'all');

% histograms w/ stats
% female
figure
h = histogram(net_time_f,bins,'facealpha',a_bold,'edgecolor','none'), hold on;
histogram(net_time_m,bins,'facealpha',a_thin,'edgecolor','none')
% draw a line for mean and median
xl = xline(nt_stats(1,1),'--',['Mean time: ' time2clock(nt_stats(1,1),'m')]);
xl.LabelHorizontalAlignment =  'left';
xline(nt_stats(2,1),'--',['Median time: ' time2clock(nt_stats(2,1),'m')]);
% label axes
xlabel('Time (min)')
ylabel('Count')
% write a message of the stats
y = get(get(h,'Parent'),'Ylim');
x = get(get(h,'Parent'),'Xlim');
txt = {['Stats for Females:'];...
    ['Mean:    ' time2clock(nt_stats(1,1),'m')];...
    ['Median:  ' time2clock(nt_stats(2,1),'m')];... 
    ['Mode:    ' time2clock(nt_stats(3,1),'m')];...
    ['Range:   ' time2clock(nt_stats(4,1),'m') ' - ' time2clock(nt_stats(5,1),'m')]};
text([x(2)*0.7],[y(2)/2],txt);
% boring figure stuff
box off
axis tight
ftitle = 'Females - Net Time Stats';
title(ftitle)
legend('Females (bolded)','Males','location','northeast')
legend boxoff
saveas(gcf,['1 - ' ftitle],'png');

% male
figure
h = histogram(net_time_f,bins,'facealpha',a_thin,'edgecolor','none'), hold on;
histogram(net_time_m,bins,'facealpha',a_bold,'edgecolor','none')
% draw lines for mean and median
xl = xline(nt_stats(1,2),'--',['Mean time: ' time2clock(nt_stats(1,2),'m')]);
xl.LabelHorizontalAlignment =  'left';
xline(nt_stats(2,2),'--',['Median time: ' time2clock(nt_stats(2,2),'m')]);
% label axes
xlabel('Time (min)')
ylabel('Count')
% write a message of the stats
y = get(get(h,'Parent'),'Ylim');
x = get(get(h,'Parent'),'Xlim');
txt = {['Stats for Males:'];...
    ['Mean:    ' time2clock(nt_stats(1,2),'m')];...
    ['Median:  ' time2clock(nt_stats(2,2),'m')];... 
    ['Mode:    ' time2clock(nt_stats(3,2),'m')];...
    ['Range:   ' time2clock(nt_stats(4,2),'m') ' - ' time2clock(nt_stats(5,2),'m')]};
text([x(2)*0.7],[y(2)/2],txt);
% boring figure stuff
box off
axis tight
ftitle = 'Males - Net Time Stats';
title(ftitle)
legend('Females','Males (bolded)','location','northeast')
legend boxoff
saveas(gcf,['1 - ' ftitle],'png');

%% 2) Analyze the difference between gun and net time race results.
% grab gun times
gun_time_f = cell2mat(data_f{:,9});
gun_time_m = cell2mat(data_m{:,9});

% gun time differential (gtd), the difference between net time and gun time
gtd_f = (gun_time_f-net_time_f)*60;
gtd_m = (gun_time_m-net_time_m)*60;

% gtd stats, by division
gtd_stats = zeros(9,5,2);
for i = 1:9
    % grab the female division and compute gtd for it
    temp = div_data{i,1};
    if ~isempty(temp)
        temp_gtd_f = (cell2mat(temp{:,9})-cell2mat(temp{:,10}))*60;
    else
        temp_gtd_f = 0;
    end
    
    % grab the male division and compute gtd for it
    temp = div_data{i,2};
    if ~isempty(temp)
        temp_gtd_m = (cell2mat(temp{:,9})-cell2mat(temp{:,10}))*60;
    else
        temp_gtd_m = 0;
    end
    
    % compute stats
    gtd_stats(i,1,1) = mean((temp_gtd_f),'all');
    gtd_stats(i,2,1) = median((temp_gtd_f),'all');
    gtd_stats(i,3,1) = mode((temp_gtd_f),'all');
    gtd_stats(i,4,1) = min((temp_gtd_f),[],'all');
    gtd_stats(i,5,1) = max((temp_gtd_f),[],'all');

    % males
    gtd_stats(i,1,2) = mean((temp_gtd_m),'all');
    gtd_stats(i,2,2) = median((temp_gtd_m),'all');
    gtd_stats(i,3,2) = mode((temp_gtd_m),'all');
    gtd_stats(i,4,2) = min((temp_gtd_m),[],'all');
    gtd_stats(i,5,2) = max((temp_gtd_m),[],'all');
end

% plot of gtd by division
figure
plot(gtd_stats(1:end-1,2,1),'LineWidth',2), hold on
plot(gtd_stats(:,2,2),'LineWidth',2)
xlabel('Division')
ylabel('Median GTD (seconds)')
ftitle = 'Division VS Median Gun Time Differential (GTD)';
title(ftitle)
legend('Female GTD','Male GTD','location','northwest')
hold off
saveas(gcf,['2 - ' ftitle],'png');

% plot of gtd by place
figure
p = plot(smoothdata(gtd_f,'gaussian')), hold on;
plot(smoothdata(gtd_m)), hold on
xlabel('Place in Race Results (Count)')
ylabel('GTD (seconds)')
ftitle = 'Race Result VS Gun Time Differential';
title(ftitle);
legend('Female GTD','Male GTD','location','northwest')
[y] = get(get(p,'Parent'),'Ylim');
[x] = get(get(p,'Parent'),'Xlim');
% correlation hard coded because I didn't think to run this until I did the write up...
txt = {['Female correlation:  ' num2str(0.6804)];['Male correlation:      ' num2str(0.7508)]}
text([x(2)*0.025],[y(2)*0.7],txt);
hold off
saveas(gcf,['2 - ' ftitle],'png');

%% 3) How much time separates Chris Doe from the top 10 percentile of racers of the same division?
target = 'Chris Doe';
g_ind = 2; % gender index, female = 1, male = 2; %FEMALE NOT WORKING FOR NOW
t_div = -1;
div_ind = -1;
cutoff = 0.10;  % cut off percentage, as a decimal

% find the target's division
for i = 1:n_male
    if contains(cell2mat(data_m{i,6}),target)
        t_div = data_m{i,g_ind};
    end
end

% if they were found, bring up the table of JUST their division and find them again
if t_div ~= -1
    temp = div_data{t_div,g_ind};
    for i = 1:size(temp,1)
        if contains(cell2mat(temp{i,6}),target)
            div_ind = i;
        end
    end
    % grab the times
    n_div = size(temp,1);
    div_net_time = cell2mat(temp{:,10});
    
    % grab target and top % time
    t10_time = cell2mat(temp{round(n_div*cutoff),10});
    t_time = cell2mat(temp{div_ind,10});
    
    % generate histogram figure
    figure
    hold on
    h = histogram(div_net_time,bins,'facealpha',a_bold,'edgecolor','none');
    % draw lines
    xline(t_time,'--',{[target ': ' time2clock(t_time,'m')]});
    xline(t10_time,'--',{['Top ' num2str(cutoff*100) '% Cutoff: ' time2clock(t10_time,'m')]});
    % message
    [y] = get(get(h,'Parent'),'Ylim');
    [x] = get(get(h,'Parent'),'Xlim');
    text([x(2)*0.6],[y(2)/2],{['Time difference between:']; [target ' and top ' num2str(cutoff*100) '%:']; [time2clock(t_time-t10_time,'m')]});
    
    % boring plot labels
    xlabel('Time (min)')
    ylabel('Count')
    box off
    axis tight
    title(['Net Time of  ' target ' VS Top ' num2str(cutoff*100) '% in Division ' num2str(t_div)])
    legend('Net Time across division','location','northeast')
    legend boxoff
    saveas(gcf,['3 - ' target ' VS Top Percentage'],'png');
end

%% 4) Compare the race results of each division

% computed stats by division
div_nt_stats = zeros(9,5,2);
% run through all the divisions
for i = 1:9
    % grab the female division and their net times
    temp = div_data{i,1};
    if ~isempty(temp)
        temp_nt_f = cell2mat(temp{:,10});
    else
        temp_nt_f = 0;
    end
    
    % grab the male division and their net times
    temp = div_data{i,2};
    if ~isempty(temp)
        temp_nt_m = cell2mat(temp{:,10});
    else
        temp_nt_m = 0;
    end
    
    % compute stats
    div_nt_stats(i,1,1) = mean((temp_nt_f),'all');
    div_nt_stats(i,2,1) = median((temp_nt_f),'all');
    div_nt_stats(i,3,1) = mode((temp_nt_f),'all');
    div_nt_stats(i,4,1) = min((temp_nt_f),[],'all');
    div_nt_stats(i,5,1) = max((temp_nt_f),[],'all');

    % males
    div_nt_stats(i,1,2) = mean((temp_nt_m),'all');
    div_nt_stats(i,2,2) = median((temp_nt_m),'all');
    div_nt_stats(i,3,2) = mode((temp_nt_m),'all');
    div_nt_stats(i,4,2) = min((temp_nt_m),[],'all');
    div_nt_stats(i,5,2) = max((temp_nt_m),[],'all');
end

% plot median net time, by division, both genders
figure
plot(div_nt_stats(1:end-1,2,1),'LineWidth',2), hold on
plot(div_nt_stats(:,2,2),'LineWidth',2)
xlabel('Division')
ylabel('Median Net Time (min)')
ftitle = 'Net Time VS Division';
title(ftitle)
legend('Female','Male','location','northwest')
hold off
saveas(gcf,['4 - ' ftitle],'png');


%% some quick statistical tests
% 1)
var(net_time_f)
var(net_time_m)
[h,p] = ttest2(net_time_f,net_time_m)
% 2)
men = [1:1265];
women = [1:1105];
corrcoef(men,gtd_m)
corrcoef(women,gtd_f)

var(gtd_m)
var(gtd_f)





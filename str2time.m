function [time] = str2time(a,hms)
% helper function to convert a time expressed as hours:minutes:seconds into
% a decimal of the desired unit, hms (hours, minutes, or seconds)
% automatically cleans up and deletes non-numerical, non-colon characters

%% PREPARATION
% length of the string
len = size(a,2);
% a temporary string containing the cleaned up data, but still a string
timestr = [];

%% CONSTRUCT A CLEANED STRING
for i = 1:len
    chr = a(i);
    val = double(chr);
    if val >= 48 && val <= 58
        timestr = [timestr,chr];
    end
    
end

% check for safety
colons = strfind(timestr,':');
if isempty(colons) || isempty(timestr)
    msg = ['The input string: "' a '" was not a valid time. Please check input data.'];
    error(msg)
end

%% CONVERT THE CLEANED STRING TO NUMERICAL DATA
% number of colons tells us how data are formatted
n_colon = size(colons,2);
hrs = 0;
min = 0;
sec = 0;

if n_colon == 2
    hrs = str2double(timestr(1:colons(1)-1));
    min = str2double(timestr(colons(1)+1:colons(2)-1));
    sec = str2double(timestr(colons(2)+1:end));
elseif n_colon == 1
    min = str2double(timestr(1:colons(1)-1));
    sec = str2double(timestr(colons(1)+1:end));
else
    msg = ['The resulting time string is wrong somehow: ' timestr];
    error(msg);
end
    
%% CONVERT THE HOURS, MINUTES, AND SECONDS TO THE DESIRED UNIT
if strcmp(hms,'h')
    time = hrs+min/60+sec/3600;
elseif strcmp(hms,'m')
    time = hrs*60+min+sec/60;
elseif strcmp(hms,'s')
    time = hrs*3600+min*60+sec;
else
    msg = ['The value for hours, minutes, or seconds is invalid: ' hms];
    error(msg);
end




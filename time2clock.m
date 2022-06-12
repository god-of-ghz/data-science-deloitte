function [readtime] = time2clock(a, hms)
% helper function to turn decimal time into readable time using colons

h = 0;
m = 0;
s = 0;

if strcmp(hms,'h') || strcmp(hms,'hour') || strcmp(hms,'hours') || strcmp(hms,'hrs')
elseif strcmp(hms,'m') || strcmp(hms,'min') || strcmp(hms,'minute') || strcmp(hms,'minutes')
    % hours
    rem = a;
    h = floor(a/60);
    rem = rem - h*60;
    
    % minutes
    m = floor(rem);
    rem = rem - m;
    
    % seconds
    s = floor(rem*60);
    
    % ignore milliseconds
elseif strcmp(hms,'s') || strcmp(hms,'sec') || strcmp(hms,'second') || strcmp(hms,'seconds')
else
    msg = ['Units are invalid.'];
    error(msg)
end

readtime = [];
if h > 0
    readtime = [readtime num2str(h) ':'];
end
if m > 0
    temp = num2str(m);
    if size(temp,2) == 1
        temp = ['0' temp];
    end
    readtime = [readtime temp ':'];
end
if s > 0
    temp = num2str(s);
    if size(temp,2) == 1
        temp = ['0' temp];
    end
    readtime = [readtime temp];
end

return;
function [clean_data] = Deloitte_DataClean(raw_data)
% helper function to parse through the table, cleaning up mistakes
% does the following:
% - recalculates division
% - removes unnecessary characters from times
% - converts clock-based time into decimal time
% - fixes hometown

% copy table
clean_data = raw_data;

% extract info
n_entry = size(clean_data,1);

%% ADD TABLE ENTRIES
Div = zeros(n_entry,1);
PlaceInDiv = Div;

% statistics to easily compute divisions later on
% row 1 = running sum to compute total the first time
% row 2 = running count to compute place in division
div_stats = zeros(2,12);

clean_data = addvars(clean_data,Div,'Before','Div_Tot');
clean_data = addvars(clean_data,PlaceInDiv,'Before','Div_Tot');


%% FIX TABLE, LINE BY LINE, EXCEPT FOR DIVISION STATISTICS
for i = 1:n_entry
    % compute division #
    clean_data{i,2} = divcalc(clean_data{i,7});

    % collect statistics on divisions
    ind = clean_data{i,2};
    if ind ~= -1
        div_stats(1,ind) = div_stats(1,ind)+1;
    else
        disp('There is a person with an invalid age & division!')
    end

    % fix hometown as needed
    temp = clean_data{i,9};
    temp = temp{:};
    chr = double(temp(1));
    % if the first character of gun time is a capital letter...
    if chr >= 65 && chr <= 90
        % append the 'hometown' with it
        temp = clean_data{i,8};
        temp = temp{:};
        temp = [temp, char(chr)];
        clean_data{i,8} = {temp};
    end
    
    % clean up times
    for j = 9:11
        temp = clean_data{i,j};
        temp = temp{:};
        clean_data{i,j} = {str2time(temp,'m')};
    end
end

%% FIX DIVISIONS
for i = 1:n_entry
    % grab division
    ind = clean_data{i,2};
    
    % assign div_tot if the division is valid
    if ind ~= -1
        clean_data{i,4} = {div_stats(1,ind)};
    
        % increment current place in division
        div_stats(2,ind) = div_stats(2,ind)+1;
        % assign PlaceInDiv
        clean_data{i,3} = div_stats(2,ind);
    end
end

% safety check - NOT NEEDED
% for i = 1:12
%     assert(div_stats(i,1) == div_stats(i,2));
% end



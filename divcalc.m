function [div] = divcalc(age)
% helper function to rapidly compute division based on age

% returns -1 if age is invalid
if isempty(age) || isnan(age) || age < 0 || age >= 120  % we dont expect anyone to be older than 120...
    div = -1;
    return;
end

% compute division
div = floor(age/10)+1;
% special case for kids and young teens 14 and under
if age <= 14
    div = 1;
end
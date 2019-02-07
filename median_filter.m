function [ vector1, vector2 ] = median_filter( vector1, vector2, window_size, threshold)
%median_filter: recover outliers using median value.
%   For data in the window, if the difference between a data and the median 
%   value is larger than the given threshold, the data will be treated as an 
%   outlier and be replaced with median value in the window.

% centralize position, avoid head tilting
overall_med_1 = median(vector1);
overall_med_2 = median(vector2);

vector1 = vector1 - overall_med_1;
vector2 = vector2 - overall_med_2;

% filt outliers
% 移植到C++时注意最大值是否能取到 / When you convert the codes to cpp, be aware the whether
% the largest value in a for loop is accessible.
for ct = 1 : length(vector1) - window_size + 1
    % find outliers
    med_window_1 = median(vector1( ct : ct+window_size-1 ));
    outlier_inds1  = find( abs(vector1( ct : ct+window_size-1 ) - med_window_1) > threshold );
    
    med_window_2 = median(vector2( ct : ct+window_size-1 ));
    outlier_inds2  = find( abs(vector2( ct : ct+window_size-1 ) - med_window_2) > threshold );
    
    % correct outliers
    % 移植到C++时注意索引起点为0 / When you convert the codes to cpp, be aware the the first index of a vector in cpp is 0
    if isempty(outlier_inds1) && isempty(outlier_inds2) 
        % if there is no outlier in the two vectors
        continue;
    elseif ~isempty(outlier_inds1) && ~isempty(outlier_inds2)
        % if both of the vectors have outliers
        vector1( outlier_inds1 + ct - 1) = med_window_1;
        vector2( outlier_inds2 + ct - 1) = med_window_2;
    elseif isempty(outlier_inds2)
        % if vector 2 has no outliers while vector 1 has several outliers
        vector1( outlier_inds1 + ct - 1) = med_window_1;
    else
        % if vector 1 has no outliers while vector 2 has several outliers
        vector2( outlier_inds2 + ct - 1) = med_window_2;
    end
end

vector1 = vector1 + overall_med_1;
vector2 = vector2 + overall_med_2;

end


%  Copyright (c) 2018, Nusrat Sharmin
%  All rights reserved.
%
%  Redistribution and use in source and binary forms, with or without 
%  modification, are permitted provided that the following conditions are 
%  met:
%
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%      
%  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%  POSSIBILITY OF SUCH DAMAGE.

function [total_effective_land_price, land_price_map] = calculate_land_price(num_land_data)
global num_block_data_global
disp('calculate_land_price() ...');
column_university_per_10k = 8;

% Key : plot_id
% Value : land_price
land_price_map = containers.Map('KeyType','double','ValueType','double');

% Map for memoization
% Key : block no
% Value : [percent_of_commercial_use_in_block,
% percent_of_office_use_in_block, percent_of_civic_use_in_block,
% number_of_university_per_10k_sqft]
land_use_parameters_in_block_map = containers.Map('KeyType','double','ValueType','any');

% land price of only residential, commercial, office plots and mixed use of
% these three (including the ratio)
total_effective_land_price = 0;

[numRows, ~] = size(num_land_data);
for i = 1:numRows
    if(not(utility_functions.is_alteration_allowed(i)))
        continue;
    end

    plot_id = num_land_data(i, land_data_excel_columns.plot_ID);
    block_no = num_land_data(i, land_data_excel_columns.block_no);
    if(not(isKey(land_use_parameters_in_block_map, block_no)))
        [percent_comm, percent_off, percent_civic] = utility_functions.get_percent_of_land_uses_in_block(block_no, num_land_data);
        number_of_university_per_10k_sqft = num_block_data_global(block_no, column_university_per_10k);
        land_use_parameters_in_block_map(block_no) = [percent_comm, percent_off, percent_civic, number_of_university_per_10k_sqft];
    end

    land_price_parameters = land_use_parameters_in_block_map(block_no);
    
    is_residential = num_land_data(i, land_data_excel_columns.res);
    ln_distance_to_new_market = num_land_data(i, land_data_excel_columns.ln_distant_to_nwmkt);
    is_lakeview = num_land_data(i, land_data_excel_columns.lake_view);
    is_plot_adjacent_to_major_road = num_land_data(i, land_data_excel_columns.adjacent_major_rd);
    percentage_commercial_block = land_price_parameters(1);
    percentage_office_block = land_price_parameters(2);
    ln_total_plot_size = num_land_data(i, land_data_excel_columns.ln_tot_plot_size);
    num_of_uni_10k = land_price_parameters(4);
    percentage_civic_block = land_price_parameters(3);
    total_plot_size = num_land_data(i, land_data_excel_columns.plot_size);

    land_price = utility_functions.get_land_price(is_residential, ln_distance_to_new_market, is_lakeview, is_plot_adjacent_to_major_road, percentage_commercial_block, percentage_office_block, ln_total_plot_size, num_of_uni_10k, percentage_civic_block, total_plot_size);
    land_price_map(plot_id) = land_price;
    total_effective_land_price = total_effective_land_price + land_price;
end

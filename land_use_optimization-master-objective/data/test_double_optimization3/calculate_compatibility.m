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

function [total_compatibility, compatibility_map] = calculate_compatibility(num_land_data)
global num_neighborhood_global
global text_neighborhood_global
global num_compatibility_index_global

disp('calculate_compatibility() ...');
% Key : Plot id
% Value : 
% [total_floor_space, ratio_residential, ratio_commercial, ratio_office, ratio_school_college, ratio_university, ratio_health, ratio_civic]
compatibility_parameters_per_plot_map = containers.Map('KeyType','double','ValueType','any');

% Key : plot_id
% Value : compatibility
compatibility_map = containers.Map('KeyType','double','ValueType','double');

[num_rows, ~] = size(num_land_data);
for plot_index = 1 : num_rows
    plot_id = num_land_data(plot_index, land_data_excel_columns.plot_ID);
    [total_floor_space, ratio_residential, ratio_commercial, ratio_office, ratio_school_college, ratio_university, ratio_health, ratio_civic] = utility_functions.get_compatibility_parameters(plot_index, num_land_data);
    compatibility_parameters_per_plot_map(plot_id) = [total_floor_space, ratio_residential, ratio_commercial, ratio_office, ratio_school_college, ratio_university, ratio_health, ratio_civic];
end

total_compatibility = 0;
[num_neighbor_rows, ~] = size(num_neighborhood_global);
for self_index = 1 : num_neighbor_rows
    % initialize compatibility value
    compatibility = 0;

    % to avoid header text
    text_plot_index = self_index + 1;

    self_plot_id = num_neighborhood_global(self_index, neighborhood_excel_columns.plot_id);

    neighbors_cell = text_neighborhood_global(text_plot_index, neighborhood_excel_columns.neighbors);
    neighbors_string = [neighbors_cell{:}];
    splitted_neighborhood = strsplit(neighbors_string, ',');
    [~, num_of_neighbors] = size(splitted_neighborhood);
    for neighbor_index = 1 : num_of_neighbors
        neighbor = splitted_neighborhood(neighbor_index);
        neighbor = strtrim(neighbor);
        neighbor_plot_id = str2double(neighbor);

        % to avoid empty string ''
        if(isnan(neighbor_plot_id))
            continue;
        end

        self_compatibility_parameters = compatibility_parameters_per_plot_map(self_plot_id);
        neighbor_compatibility_parameters = compatibility_parameters_per_plot_map(neighbor_plot_id);

        for land_use_index_self = compatibility_excel_fields.residential : compatibility_excel_fields.civic
            for land_use_index_neighbor = compatibility_excel_fields.residential : compatibility_excel_fields.civic
                % [self_total_floor_space, self_ratio_residential, self_ratio_commercial, self_ratio_office, self_ratio_school_college, self_ratio_university, self_ratio_health, self_ratio_civic]
                % [neighbor_total_floor_space, neighbor_ratio_residential, neighbor_ratio_commercial, neighbor_ratio_office, neighbor_ratio_school_college, neighbor_ratio_university, neighbor_ratio_health, neighbor_ratio_civic]
                compatibility_index_self_neighbor = num_compatibility_index_global(land_use_index_self, land_use_index_neighbor);
                self_total_floor_space = self_compatibility_parameters(1);
                neighbor_total_floor_space = neighbor_compatibility_parameters(1);
                self_land_use_ratio = self_compatibility_parameters(land_use_index_self + 1);
                neighbor_land_use_ratio = neighbor_compatibility_parameters(land_use_index_neighbor + 1);
                compatibility = compatibility + (self_total_floor_space * neighbor_total_floor_space * compatibility_index_self_neighbor * self_land_use_ratio * neighbor_land_use_ratio);
            end
        end
    end

    total_compatibility = total_compatibility + compatibility;
    compatibility_map(self_plot_id) = compatibility;
end

end

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

function initialize_population(population, initialization_change_allowed)

global population_decimal_global
global population_ternary_global
global land_price_compatibility_array_global

global num_land_data_global
global original_decimal_values_global
global original_ternary_values_global

[total_plot_number, ~] = size(num_land_data_global);

% population_decimal_global is a three dimensional array [solution_number, plot_index, variable fields decimal representation]

% land_price_compatibility_array_global is an array of each population element and
% its total land price and total compatibility.
land_price_compatibility_array_global = zeros([population 3]);

iteration_count = 1;
while(iteration_count <= population)
    decimal_values_per_solution = [];
    ternary_values_per_solution = containers.Map('KeyType','int32','ValueType','char');
    output_num_land_data = num_land_data_global;
    effective_plot_index = 1;
    plot_index = 1;
    while (plot_index <= total_plot_number)
        if(not(utility_functions.is_alteration_allowed(plot_index)))
            plot_index = plot_index + 1;
            continue;
        end

        if(rand(1) > initialization_change_allowed)
            decimal_values_per_solution(effective_plot_index, 1) = original_decimal_values_global(effective_plot_index, 1);
            decimal_values_per_solution(effective_plot_index, 2) = original_decimal_values_global(effective_plot_index, 2);
            decimal_values_per_solution(effective_plot_index, 3) = 0;
            plot_id = original_decimal_values_global(effective_plot_index, 1);
            ternary_values_per_solution(plot_id) = original_ternary_values_global(plot_id);
            plot_index = plot_index + 1;
            effective_plot_index = effective_plot_index + 1;
            continue;
        end

        decimal_value = utility_functions.get_random_decimal_value_by_plot(plot_index);
        decimal_values_per_solution(effective_plot_index, 1) = output_num_land_data(plot_index, land_data_excel_columns.plot_ID);
        decimal_values_per_solution(effective_plot_index, 2) = decimal_value;
        decimal_values_per_solution(effective_plot_index, 3) = 1;

        expected_length = num_land_data_global(plot_index, land_data_excel_columns.bldg_storey);
        ternary_array = utility_functions.get_ternary_value(decimal_value, expected_length);
        plot_id = output_num_land_data(plot_index, land_data_excel_columns.plot_ID);
        ternary_values_per_solution(plot_id) = ternary_array;

        output_num_land_data = utility_functions.update_num_land_data(plot_index, output_num_land_data, ternary_array);

        effective_plot_index = effective_plot_index + 1;
        plot_index = plot_index + 1;
    end

    population_decimal_global(iteration_count, : , :) = decimal_values_per_solution;
    population_ternary_global(iteration_count) = ternary_values_per_solution;
    [total_land_price, total_compatibility] = evaluate_objectives(output_num_land_data);
    land_price_compatibility_array_global(iteration_count, :, :) = [iteration_count total_land_price total_compatibility];
    iteration_count = iteration_count + 1;
end
end

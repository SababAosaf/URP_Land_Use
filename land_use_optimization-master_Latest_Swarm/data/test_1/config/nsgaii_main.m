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

number_of_generations = 150;
population = 100;
total_number_of_changeable_plots = 1290;

% Initialization change allowed - 25% plots are allowed to be changed
initialization_change_allowed = 0.25;

% Genetic operators change allowed - 20% plots are allowed to be changed by
% crossover operator
genetic_operators_change_allowed = 0.20;

% Costraints limits
percentage_change_allowed = 0.30; % for 30% per land use change
minimum_total_effective_land_price = 130000000000; % Value from the field data
maximum_total_effective_land_price = 145000000000; % Assumption

global population_decimal_global
global population_ternary_global
global land_price_compatibility_array_global

global num_land_data_global
global original_decimal_values_global
global original_ternary_values_global
global best_decimal_global
global best_ternary_global
global the_best_decimal_global
global the_best_ternary_global
handle_input();


population_decimal_global = [];
population_ternary_global = containers.Map('KeyType','int32','ValueType','any');
land_price_compatibility_array_global = [];

% Find the decimal values for original excel file
[original_decimal_values_global, original_ternary_values_global] = ...
    utility_functions.get_values_by_num_land_data(num_land_data_global);

initialize_population(population, initialization_change_allowed);
best_decimal_global=population_decimal_global;
best_ternary_global=population_ternary_global;
% write outputs in files
filename = strcat(fileparts(mfilename('fullpath')),'/data/initial_population.xlsx');
xlswrite(filename, land_price_compatibility_array_global);

% land_price_compatibility_array_global is the chromosome
% we have to map it to the population_decimal_global, this can be treated as the
% database
non_dominated_sorting();

l_limit = zeros(total_number_of_changeable_plots, 1);
u_limit = utility_functions.upper_limit_per_plot();

sorted_land_price_compatibility_array = non_dominated_sorting_constraint( ...
			percentage_change_allowed, minimum_total_effective_land_price, ...
            maximum_total_effective_land_price);
best_id=sorted_land_price_compatibility_array(1);
disp(best_id);
the_best_decimal_global=population_decimal_global(best_id,:,:);
the_best_ternary_global=population_ternary_global(best_id);
% test code
% number_of_generations = 3;

for generation_iteration = 1 : number_of_generations
    disp('Starting Generation ...');
    disp(generation_iteration);

   
    crossover_probability = 0.9;
    mutation_probability = 0.1;
    M = 2;
    [~, V, ~] = size(population_decimal_global);
    mu = 10;% mu - distribution index for crossover (read the enlcosed pdf file
    mum = 20;% mum - distribution index for mutation (read the enclosed pdf file

    genetic_operator(land_price_compatibility_array_global, total_number_of_changeable_plots, mu, mum, l_limit, u_limit, ...
            percentage_change_allowed, minimum_total_effective_land_price, ...
            maximum_total_effective_land_price, genetic_operators_change_allowed);

    sorted_land_price_compatibility_array = non_dominated_sorting_constraint( ...
			percentage_change_allowed, minimum_total_effective_land_price, ...
            maximum_total_effective_land_price);

    final_land_price_compatibility_array = replace_chromosome(sorted_land_price_compatibility_array, 2, 1, population);

    clear sorted_land_price_compatibility_array;
    
    temp_decimal = population_decimal_global;
    population_decimal_global = [];
    temp_ternary = containers.Map('KeyType','int32','ValueType','any');
    land_price_compatibility_array_global = [];
    [size_of_next_gen, ~] = size(final_land_price_compatibility_array);
    for next_gen_iteration = 1:size_of_next_gen
        population_number = final_land_price_compatibility_array(next_gen_iteration, 1);
        decimal_num_land_data = squeeze(temp_decimal(population_number, :, :));
        population_decimal_global(next_gen_iteration, :, :) = decimal_num_land_data;
        temp_ternary(next_gen_iteration) = population_ternary_global(population_number);
        land_price_compatibility_array_global(next_gen_iteration, 1) = next_gen_iteration;
        land_price_compatibility_array_global(next_gen_iteration, 2) = final_land_price_compatibility_array(next_gen_iteration, 2);
        land_price_compatibility_array_global(next_gen_iteration, 3) = final_land_price_compatibility_array(next_gen_iteration, 3);
        land_price_compatibility_array_global(next_gen_iteration, 4) = final_land_price_compatibility_array(next_gen_iteration, 4);
        land_price_compatibility_array_global(next_gen_iteration, 5) = final_land_price_compatibility_array(next_gen_iteration, 5);
    end

    if(mod(generation_iteration, 2) == 0)
        % write outputs in files
        filename = strcat(fileparts(mfilename('fullpath')),'/data/iteration_convergence_');
        filename = strcat(filename, strcat(num2str(generation_iteration), '.xlsx'));
        xlswrite(filename, land_price_compatibility_array_global);
    end

    population_ternary_global = temp_ternary;

    clear temp_decimal;
    clear temp_ternary;
    clear final_land_price_compatibility_array;
    
    disp('Finished Generation ...');
    disp(generation_iteration);
end

[original_total_effective_land_price, original_land_price_map] = ...
    calculate_land_price(num_land_data_global);

size_of_output = size(population_ternary_global);

for output_iteration = 1:size_of_output
    % Generate total output file
    decimal_array = squeeze(population_decimal_global(output_iteration, :, :));
    ternary_array = population_ternary_global(output_iteration);
    output_num_land_data = utility_functions.get_num_land_data_from_values(decimal_array, ternary_array);
    filename = strcat(fileparts(mfilename('fullpath')),'/data/output_');
    filename = strcat(filename, strcat(num2str(output_iteration), '.xlsx'));
    % Generate land price output for per plot
    xlswrite(filename, output_num_land_data);
    [total_effective_land_price, land_price_map] = calculate_land_price(output_num_land_data);
    land_price_map_keys = keys(land_price_map);
    land_price_map_values = values(land_price_map);
    original_land_price_values = values(original_land_price_map);
    land_price_data = [];
    for land_price_iteration = 1 : length(land_price_map_values)
        plot_id = land_price_map_keys{land_price_iteration};
        plot_land_price = land_price_map_values{land_price_iteration};
        original_plot_land_price = original_land_price_values{land_price_iteration};
        price_difference = plot_land_price - original_plot_land_price;
        price_difference_count = 0;
        if (price_difference > 0)
            price_difference_count = 1;
        end
        land_price_data = [land_price_data; plot_id plot_land_price original_plot_land_price price_difference price_difference_count];
    end
    filename = strcat(fileparts(mfilename('fullpath')),'/data/comparative_land_price_');
    filename = strcat(filename, strcat(num2str(output_iteration), '.xlsx'));
    xlswrite(filename, land_price_data);
end
% write outputs in files
filename = strcat(fileparts(mfilename('fullpath')),'/data/ranking.xlsx');
xlswrite(filename, land_price_compatibility_array_global);

%  Copyright (c) 2009, Aravind Seshadri
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

% function f  = genetic_operator(parent_chromosome, V, mu, mum, l_limit, 
% u_limit, percentage_change_allowed, minimum_total_effective_land_price, 
% maximum_total_effective_land_price, genetic_operators_change_allowed)
%
% This function is utilized to produce offsprings from parent chromosomes.
% The genetic operators implemented here are crossover and mutation.
% The genetic operation is performed only on the decision variables,
% that is the first V elements in the chromosome vector.

function genetic_operator(parent_chromosome, V, mu, mum, l_limit, u_limit,...
    percentage_change_allowed, minimum_total_effective_land_price, ...
    maximum_total_effective_land_price, genetic_operators_change_allowed)

global original_decimal_values_global
global original_ternary_values_global
global num_land_data_global
global population_decimal_global
global population_ternary_global
global land_price_compatibility_array_global
global best_decimal_global
global best_ternary_global
global the_best_decimal_global
global the_best_ternary_global

disp('genetic_operator() ...');

[N,~,~] = size(population_decimal_global);


i = 1;
while(i <= N)
    parent_chromosome_inf = tournament_selection(1, 50);
    informant=parent_chromosome_inf(1,1);
    informant = population_decimal_global(informant,:,:);

    personal_best=best_decimal_global(i,:,:);

    offspring_num_land_data_1 = [];
    child_1_choromosome = [];
    child_1_ternary_chromosome = containers.Map('KeyType','int32','ValueType','char');


    parent_1 = i;
    parent_1 = parent_chromosome(parent_1, 1);
    offspring_num_land_data_1 = num_land_data_global;
    parent_1_chromosome = population_decimal_global(parent_1,:,:);

    j = 1;
    while (j <= V)
        % To ensure that 30% plots are changed
        if(rand(1) > genetic_operators_change_allowed)
            % Set the plot to original state for each child
            plot_id_j = original_decimal_values_global(j, 1);
            child_1_chromosome(j, 1) = original_decimal_values_global(j, 1);
            child_1_chromosome(j, 2) = original_decimal_values_global(j, 2);
            child_1_chromosome(j, 3) = 0;
            child_1_ternary_chromosome(plot_id_j) = original_ternary_values_global(plot_id_j);
 
            j = j + 1;
            continue;
        end
        a=1;
        b=1;
        c=1;
        d=.5;
      
        augments = ...
            round(d*1+ a* (informant(1,j,2)-parent_1_chromosome(1,j,2)) + b * (the_best_decimal_global(1,j,2)-parent_1_chromosome(1,j,2)) + c * (personal_best(1,j,2) - parent_1_chromosome(1,j,2)) );
        child_1 = round(parent_1_chromosome(1,j,2)+augments*.1);
        disp('VALUES');
        disp(parent_1_chromosome(1,j,2));
        disp(child_1);
        if child_1 > u_limit(j)
            child_1 = u_limit(j);
        elseif child_1 < l_limit(j)
            child_1 = l_limit(j);
        end
      

        parent_1_plot_id = parent_1_chromosome(1,j,1);
        excel_index = utility_functions.get_excel_index_from_plot_id(parent_1_plot_id, offspring_num_land_data_1);
        expected_length = offspring_num_land_data_1(excel_index, land_data_excel_columns.bldg_storey);
        offspring_ternary_array_1 = utility_functions.get_ternary_value(child_1, expected_length);
        offspring_num_land_data_1 = utility_functions.update_num_land_data(excel_index, offspring_num_land_data_1, offspring_ternary_array_1);
        child_1_chromosome(j, 1) = parent_1_plot_id;
        child_1_chromosome(j, 2) = child_1;
        child_1_chromosome(j, 3) = 1;
        child_1_ternary_chromosome(parent_1_plot_id) = offspring_ternary_array_1;

        j = j + 1;
    end

    if(not(isempty(offspring_num_land_data_1)) && i <= N)
        % check constraint
        % constraints_satisfied = utility_functions.is_percentage_change_constraint_satisfied(percentage_change_allowed, offspring_num_land_data_1);
        
        [total_effective_land_price, ~] = calculate_land_price(offspring_num_land_data_1);
        
        constraints_satisfied = utility_functions.is_constraint_satisfied(percentage_change_allowed, ...
            offspring_num_land_data_1, minimum_total_effective_land_price, ...
            maximum_total_effective_land_price, total_effective_land_price);
        if(constraints_satisfied)
            disp('>>>>>>>>>>>>>>>>>>>Crossover Child 1: Constraint fulfilled<<<<<<<<<<<<<<<<<<<<');
            population_ternary_global(i) = child_1_ternary_chromosome;
            population_decimal_global( i, :, :) = child_1_chromosome;
            total_compatibility = calculate_compatibility(offspring_num_land_data_1);
            index = i;
            land_price_compatibility_array_global(index, :, :, :, :) = [index total_effective_land_price total_compatibility 0 0];
            
            best_num_data  = utility_functions.get_num_land_data_from_values(best_decimal_global(i,:,:), best_ternary_global(i));
            [best_total_effective_land_price, ~] = calculate_land_price(best_num_data);
            best_total_compatibility = calculate_compatibility(best_num_data);
            disp([total_effective_land_price,best_total_effective_land_price,total_compatibility,best_total_compatibility])
            if (best_total_effective_land_price<=total_effective_land_price && best_total_compatibility<=total_compatibility)
                best_decimal_global(i,:,:)= child_1_chromosome;
                best_ternary_global(i) = child_1_ternary_chromosome;
            end

            the_best_num_data  = utility_functions.get_num_land_data_from_values(the_best_decimal_global, the_best_ternary_global);
            
            [the_best_total_effective_land_price, ~] = calculate_land_price(the_best_num_data);
            the_best_total_compatibility = calculate_compatibility(the_best_num_data);
            
            if (the_best_total_effective_land_price<=total_effective_land_price && the_best_total_compatibility<=total_compatibility)
                the_best_decimal_global= child_1_chromosome;
                the_best_ternary_global = child_1_ternary_chromosome;
            end

           

        end
        
    end
    i = i + 1;

    
end

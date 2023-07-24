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

disp('genetic_operator() ...');

[N,~,~] = size(population_decimal_global);
[pool_size, ~] = size(parent_chromosome);

i = 1;
while(i <= N)
    offspring_num_land_data_1 = [];
    offspring_num_land_data_2 = [];
    offspring_num_land_data_3 = [];
    child_1_choromosome = [];
    child_1_ternary_chromosome = containers.Map('KeyType','int32','ValueType','char');
    child_2_choromosome = [];
    child_2_ternary_chromosome = containers.Map('KeyType','int32','ValueType','char');
    child_3_choromosome = [];
    child_3_ternary_chromosome = containers.Map('KeyType','int32','ValueType','char');
    % With 90 % probability perform crossover
    if rand(1) <= 0.9
        % Select the first parent
        parent_1 = 0;
        parent_2 = 0;
        while(parent_1 == parent_2)
            random_parent = randperm(pool_size, 2);
            parent_1 = random_parent(1);
            parent_2 = random_parent(2);
            parent_1 = parent_chromosome(parent_1, 1);
            parent_2 = parent_chromosome(parent_2, 1);
        end
        % Get the chromosome information for each randomnly selected
        % parents
        offspring_num_land_data_1 = num_land_data_global;
        offspring_num_land_data_2 = num_land_data_global;
        parent_1_chromosome = population_decimal_global(parent_1,:,:);
        parent_2_chromosome = population_decimal_global(parent_2,:,:);

%         % debug code
%         diary on;
%         disp('>>>>>>>>>>>>>>>>>>>>>>> Calculation for parent 1');
%         utility_functions.is_percentage_change_constraint_satisfied(percentage_change_allowed, num_land_data_global, num_land_data_1);
%         disp('Calculation for parent 1 finished');
%         disp('>>>>>>>>>>>>>>>> Calculation for parent 2');
%         utility_functions.is_percentage_change_constraint_satisfied(percentage_change_allowed, num_land_data_global, num_land_data_2);
%         disp('Calculation for parent 2 finished');
%         diary off;
%         % debug code
        
        % Perform corssover for each decision variable in the chromosome.
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
                child_2_chromosome(j, 1) = original_decimal_values_global(j, 1);
                child_2_chromosome(j, 2) = original_decimal_values_global(j, 2);
                child_2_chromosome(j, 3) = 0;
                child_2_ternary_chromosome(plot_id_j) = original_ternary_values_global(plot_id_j);
                j = j + 1;
                continue;
            end

            % SBX (Simulated Binary Crossover).
            % For more information about SBX refer the enclosed pdf file.
            % Generate a random number
            u(j) = rand(1);
            if u(j) <= 0.5
                bq(j) = (2*u(j))^(1/(mu+1));
            else
                bq(j) = (1/(2*(1 - u(j))))^(1/(mu+1));
            end
            % Generate the jth element of first child
            child_1 = ...
                round(0.5*(((1 + bq(j))*parent_1_chromosome(1,j,2)) + (1 - bq(j))*parent_2_chromosome(1,j,2)));
            % Generate the jth element of second child
            child_2 = ...
                round(0.5*(((1 - bq(j))*parent_1_chromosome(1,j,2)) + (1 + bq(j))*parent_2_chromosome(1,j,2)));

            % Make sure that the generated element is within the specified
            % decision space else set it to the appropriate extrema.
            if child_1 > u_limit(j)
                child_1 = u_limit(j);
            elseif child_1 < l_limit(j)
                child_1 = l_limit(j);
            end
            if child_2 > u_limit(j)
                child_2 = u_limit(j);
            elseif child_2 < l_limit(j)
                child_2 = l_limit(j);
            end
            
            % make offspring array after crossover
            % convert into 3 base number
            parent_1_plot_id = parent_1_chromosome(1,j,1);
            parent_2_plot_id = parent_2_chromosome(1,j,1);
            
%           offspring_ternary_array(1, j, 1) = parent_1_plot_id;
            excel_index = utility_functions.get_excel_index_from_plot_id(parent_1_plot_id, offspring_num_land_data_1);
            expected_length = offspring_num_land_data_1(excel_index, land_data_excel_columns.bldg_storey);
            offspring_ternary_array_1 = utility_functions.get_ternary_value(child_1, expected_length);
            offspring_num_land_data_1 = utility_functions.update_num_land_data(excel_index, offspring_num_land_data_1, offspring_ternary_array_1);
            child_1_chromosome(j, 1) = parent_1_plot_id;
            child_1_chromosome(j, 2) = child_1;
            child_1_chromosome(j, 3) = 1;
            child_1_ternary_chromosome(parent_1_plot_id) = offspring_ternary_array_1;

            excel_index = utility_functions.get_excel_index_from_plot_id(parent_2_plot_id, offspring_num_land_data_2);
            expected_length = offspring_num_land_data_2(excel_index, land_data_excel_columns.bldg_storey);
            offspring_ternary_array_2 = utility_functions.get_ternary_value(child_2, expected_length);
            offspring_num_land_data_2 = utility_functions.update_num_land_data(excel_index, offspring_num_land_data_2, offspring_ternary_array_2);
            child_2_chromosome(j, 1) = parent_2_plot_id;
            child_2_chromosome(j, 2) = child_2;
            child_2_chromosome(j, 3) = 1;
            child_2_ternary_chromosome(parent_2_plot_id) = offspring_ternary_array_2;
            j = j + 1;
        end
        
    % With 10 % probability perform mutation. Mutation is based on
    % polynomial mutation.
    else
        % Select at random the parent
        parent_3 = randperm(pool_size, 1);
        if parent_3 < 1
            parent_3 = 1;
        end
        % Get the chromosome information for the randomnly selected parent.
        offspring_num_land_data_3 = num_land_data_global;
        parent_3 = parent_chromosome(parent_3, 1);
        parent_3_chromosome = population_decimal_global(parent_3,:,:);
        % Perform mutation on eact element of the 
        % selected parent.
        j = 1;
        while (j <= V)
           % To ensure that 30% plots are changed
           if(rand(1) > genetic_operators_change_allowed)
               % Set the plot to original state for the child
               plot_id_j = original_decimal_values_global(j, 1);
               child_3_chromosome(j, 1) = original_decimal_values_global(j, 1);
               child_3_chromosome(j, 2) = original_decimal_values_global(j, 2);
               child_3_chromosome(j, 3) = 0;
               child_3_ternary_chromosome(plot_id_j) = original_ternary_values_global(plot_id_j);
               j = j + 1;
               continue;
           end

           r(j) = rand(1);
           if r(j) < 0.5
               delta(j) = (2*r(j))^(1/(mum+1)) - 1;
           else
               delta(j) = 1 - (2*(1 - r(j)))^(1/(mum+1));
           end
           % Generate the corresponding child element.
           child_3 = round(parent_3_chromosome(1,j,2) + (u_limit(j) - l_limit(j)) * delta(j));

           % Make sure that the generated element is within the decision
           % space.
           if child_3 > u_limit(j)
               child_3 = u_limit(j);
           elseif child_3 < l_limit(j)
               child_3 = l_limit(j);
           end
            parent_3_plot_id = parent_3_chromosome(1,j,1);
            excel_index = utility_functions.get_excel_index_from_plot_id(parent_3_plot_id, offspring_num_land_data_3);
            expected_length = offspring_num_land_data_3(excel_index, land_data_excel_columns.bldg_storey);
            offspring_ternary_array_3 = utility_functions.get_ternary_value(child_3, expected_length);
            offspring_num_land_data_3 = utility_functions.update_num_land_data(excel_index, offspring_num_land_data_3, offspring_ternary_array_3);
            child_3_chromosome(j, 1) = parent_3_plot_id;
            child_3_chromosome(j, 2) = child_3;
            child_3_chromosome(j, 3) = 1;
            child_3_ternary_chromosome(parent_3_plot_id) = offspring_ternary_array_3;
            j = j + 1;
        end
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
            population_ternary_global(N + i) = child_1_ternary_chromosome;
            population_decimal_global(N + i, :, :) = child_1_chromosome;
            total_compatibility = calculate_compatibility(offspring_num_land_data_1);
            index = N+i;
            land_price_compatibility_array_global(index, :, :, :, :) = [index total_effective_land_price total_compatibility 0 0];
            i = i + 1;
        end
    end

    if(not(isempty(offspring_num_land_data_2)) && i <= N)
        % check constraint
        % constraints_satisfied = utility_functions.is_percentage_change_constraint_satisfied(percentage_change_allowed, offspring_num_land_data_2);
        [total_effective_land_price, ~] = calculate_land_price(offspring_num_land_data_2);
        constraints_satisfied = utility_functions.is_constraint_satisfied(percentage_change_allowed, ...
            offspring_num_land_data_2, minimum_total_effective_land_price, ...
            maximum_total_effective_land_price, total_effective_land_price);
        if(constraints_satisfied)
            disp('>>>>>>>>>>>>>>>>>>>Crossover Child 2: Constraint fulfilled<<<<<<<<<<<<<<<<<<<<');
            population_ternary_global(N + i) = child_2_ternary_chromosome;
            population_decimal_global(N + i, :, :) = child_2_chromosome;
            total_compatibility = calculate_compatibility(offspring_num_land_data_2);
            index = N+i;
            land_price_compatibility_array_global(index, :, :, :, :) = [index total_effective_land_price total_compatibility 0 0];
            i = i + 1;
        end
    end

    if(not(isempty(offspring_num_land_data_3)) && i <= N)
        % check constraint
        % constraints_satisfied = utility_functions.is_percentage_change_constraint_satisfied(percentage_change_allowed, offspring_num_land_data_3);
        [total_effective_land_price, ~] = calculate_land_price(offspring_num_land_data_3);
        constraints_satisfied = utility_functions.is_constraint_satisfied(percentage_change_allowed, ...
            offspring_num_land_data_3, minimum_total_effective_land_price, ...
            maximum_total_effective_land_price, total_effective_land_price);
        if(constraints_satisfied)
            disp('>>>>>>>>>>>>>>>>>>>Mutation Child 3: Constraint fulfilled<<<<<<<<<<<<<<<<<<<<');
            population_ternary_global(N + i) = child_3_ternary_chromosome;
            population_decimal_global(N + i, :, :) = child_3_chromosome;
            total_compatibility = calculate_compatibility(offspring_num_land_data_3);
            index = N+i;
            land_price_compatibility_array_global(index, :, :, :, :) = [index total_effective_land_price total_compatibility 0 0];
            i = i + 1;
        end
    end
end

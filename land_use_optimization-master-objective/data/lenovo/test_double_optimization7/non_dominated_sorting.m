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

function non_dominated_sorting()
global land_price_compatibility_array_global
disp('non_dominated_sorting() ...');
% Initialize the front number to 1.
front = 1;
F(front).f = [];

individual = [];

[array_size, ~, ~] = size(land_price_compatibility_array_global);
number_of_objectives = 2;

for array_index_i = 1 : array_size
    % Number of individuals that dominate this individual, np
    individual(array_index_i).n = 0;
    % Individuals which this individual dominate, sp
    individual(array_index_i).p = [];

    for array_index_j = 1 : array_size
        i_dominates_j_on_objective = 0;
        i_equals_j_on_objective = 0;
        j_dominates_i_on_objective = 0;

        for objective = 1 : number_of_objectives
            if (land_price_compatibility_array_global(array_index_i, objective + 1) > land_price_compatibility_array_global(array_index_j, objective + 1))
                i_dominates_j_on_objective = i_dominates_j_on_objective + 1;
            elseif (land_price_compatibility_array_global(array_index_i, objective + 1) == land_price_compatibility_array_global(array_index_j, objective + 1))
                i_equals_j_on_objective = i_equals_j_on_objective + 1;
            else
                j_dominates_i_on_objective = j_dominates_i_on_objective + 1;
            end
        end
        if i_dominates_j_on_objective == 0 && i_equals_j_on_objective ~= number_of_objectives
            individual(array_index_i).n = individual(array_index_i).n + 1;
        elseif j_dominates_i_on_objective == 0 && i_equals_j_on_objective ~= number_of_objectives
            individual(array_index_i).p = [individual(array_index_i).p array_index_j];
        end
    end
    if individual(array_index_i).n == 0
        % third element is the rank
        land_price_compatibility_array_global(array_index_i, number_of_objectives + 2) = 1;
        F(front).f = [F(front).f array_index_i];
    end
end

% Find the subsequent fronts
while ~isempty(F(front).f)
   Q = [];
   for i = 1 : length(F(front).f)
       if ~isempty(individual(F(front).f(i)).p)
            for j = 1 : length(individual(F(front).f(i)).p)
            	individual(individual(F(front).f(i)).p(j)).n = ...
                	individual(individual(F(front).f(i)).p(j)).n - 1;
                if individual(individual(F(front).f(i)).p(j)).n == 0
               		land_price_compatibility_array_global(individual(F(front).f(i)).p(j), number_of_objectives + 1 + 1) = ...
                        front + 1;
                    Q = [Q individual(F(front).f(i)).p(j)];
                end
            end
       end
   end
   front =  front + 1;
   F(front).f = Q;
end

[~,index_of_fronts] = sort(land_price_compatibility_array_global(:,number_of_objectives + 1 + 1));
for i = 1 : length(index_of_fronts)
    sorted_based_on_front(i,:) = land_price_compatibility_array_global(index_of_fronts(i),:);
end

% Find the crowding distance for each individual in each front
current_index = 0;
for front = 1 : (length(F) - 1)
    y = [];
    previous_index = current_index + 1;
    for i = 1 : length(F(front).f)
        y(i,:) = sorted_based_on_front(current_index + i,:);
    end
    current_index = current_index + i;
    % Sort each individual based on the objective
    sorted_based_on_objective = [];
    for objective = 1 : number_of_objectives
        [~, index_of_objectives] = ...
            sort(y(:,objective + 1));
        sorted_based_on_objective = [];
        for j = 1 : length(index_of_objectives)
            sorted_based_on_objective(j,:) = y(index_of_objectives(j),:);
        end
        f_max = ...
            sorted_based_on_objective(length(index_of_objectives), objective + 1);
        f_min = sorted_based_on_objective(1, objective + 1);
        y(index_of_objectives(length(index_of_objectives)), number_of_objectives + 1 + 1 + objective)...
            = Inf;
        y(index_of_objectives(1), number_of_objectives + 1 + 1 + objective) = Inf;
         for j = 2 : length(index_of_objectives) - 1
            next_obj  = sorted_based_on_objective(j + 1, 1 + objective);
            previous_obj  = sorted_based_on_objective(j - 1, 1 + objective);
            if (f_max - f_min == 0)
                y(index_of_objectives(j), number_of_objectives + 1 + 1 + objective) = Inf;
            else
                y(index_of_objectives(j), number_of_objectives + 1 + 1 + objective) = ...
                     (next_obj - previous_obj)/(f_max - f_min);
            end
         end
    end
    distance = [];
    distance(:,1) = zeros(length(F(front).f),1);
    for objective = 1 : number_of_objectives
        distance(:,1) = distance(:,1) + y(:,number_of_objectives + 1 + 1 + objective);
    end
    y(:, number_of_objectives + 1 + 2) = distance;
    y = y(:,1 : number_of_objectives + 1 + 2);
    z(previous_index:current_index,:) = y;
end
land_price_compatibility_array_global = z();

end

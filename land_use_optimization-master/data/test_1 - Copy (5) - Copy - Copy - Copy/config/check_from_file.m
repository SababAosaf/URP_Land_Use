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
global num_block_data_global
global num_land_data_global
global original_decimal_values_global
global original_ternary_values_global
global num_land_data_global2

num_land_data_global = xlsread(strcat(fileparts(mfilename('fullpath')),'/data/input_data.xlsx'),'total_land_data');
num_block_data_global= xlsread(strcat(fileparts(mfilename('fullpath')),'/data/input_data.xlsx'),'block_area');
p_c=xlsread(strcat(fileparts(mfilename('fullpath')),'/data/iteration_convergence_150.xlsx'));
g_c=[];
in=0;
for j = 1:100

   
%num_land_data_global = xlsread(strcat(fileparts(mfilename('fullpath')),'/data/input_data.xlsx'),'total_land_data');
%num_block_data_global= xlsread(strcat(fileparts(mfilename('fullpath')),'/data/input_data.xlsx'),'block_area');
%p_c=xlsread(strcat(fileparts(mfilename('fullpath')),'/data/iteration_convergence_150.xlsx'));

i=j+in;
if (i>100)
    break;
end
    %if(i==46)
      
     %     num_land_data_global=[];
      %    num_block_data_global=[];
      %  num_land_data_global = xlsread(strcat(fileparts(mfilename('fullpath')),'/data/input_data.xlsx'),'total_land_data');
      %  num_block_data_global= xlsread(strcat(fileparts(mfilename('fullpath')),'/data/input_data.xlsx'),'block_area');
   
    %end    

 disp('/data/output_'+string(i)+'.xlsx');
    num_land_data = xlsread(strcat(fileparts(mfilename('fullpath')),'/data/output_'+string(i)+'.xlsx'));

    [total_effective_land_price, ~] = calculate_land_price(num_land_data);
disp(55);
disp(total_effective_land_price);
    p=  Copy_of_utility_functions.is_percentage_change_constraint_satisfied1(1,num_land_data);
disp([p_c(i,:) p]);
disp(77);
constraints_satisfied = utility_functions.is_constraint_satisfied(0.3, num_land_data, 130000000000, 145000000000, total_effective_land_price);
constraints_satisfied2=utility_functions.is_constraint_satisfied(0.4, num_land_data, 130000000000, 145000000000, total_effective_land_price);
constraints_satisfied3=utility_functions.is_constraint_satisfied(0.6, num_land_data, 130000000000, 145000000000, total_effective_land_price);
constraints_satisfied4=utility_functions.is_constraint_satisfied(0.8, num_land_data, 130000000000, 145000000000, total_effective_land_price);



s=555555;
disp(445);
if (constraints_satisfied)
    s=1;
end
s2=555555;
disp(445);
if (constraints_satisfied2)
    s2=1;
end

s3=555555;
disp(445);
if (constraints_satisfied3)
    s3=1;
end

s4=555555;
disp(445);
if (constraints_satisfied4)
    s4=1;
end

g_c(j,:)=[p_c(i,:) p s s2 s3 s4];
%clear num_land_data;
end
disp(44);
disp(g_c);

f=strcat(fileparts(mfilename('fullpath')),'/data/compares'+string(in)+'.xlsx');
 xlswrite(f, g_c);



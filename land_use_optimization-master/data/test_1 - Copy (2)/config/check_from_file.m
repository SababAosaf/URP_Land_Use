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
for i = 1:100
    if(i==46)
      
          num_land_data_global=[];
          num_block_data_global=[];
        num_land_data_global = xlsread(strcat(fileparts(mfilename('fullpath')),'/data/input_data.xlsx'),'total_land_data');
        num_block_data_global= xlsread(strcat(fileparts(mfilename('fullpath')),'/data/input_data.xlsx'),'block_area');
   
    end    

 
    num_land_data = xlsread(strcat(fileparts(mfilename('fullpath')),'/data/output_'+string(i)+'.xlsx'));

    [total_effective_land_price, ~] = calculate_land_price(num_land_data);
p=  is_percentage_change_constraint_satisfied1(1,num_land_data);
disp([p_c(i,:) p]);
g_c(i,:)=[p_c(i,:) p];
clear num_land_data;
end
disp(g_c);

f=strcat(fileparts(mfilename('fullpath')),'/data/compare.xlsx');
 xlswrite(f, g_c);

   function percentage_change_constraint_satisfied1 = is_percentage_change_constraint_satisfied1(percentage_change_allowed, num_land_data)
            %percentage_change_constraint_satisfied = true;
            global num_land_data_global
            total_residential = 0;
            total_commercial = 0;
            total_office = 0;
            original_total_residential = 0;
            original_total_commercial = 0;
            original_total_office = 0;
            [total_plot_number, ~] = size(num_land_data);
            for plot_index = 1 : total_plot_number

                if(not(utility_functions.is_alteration_allowed(plot_index)))
                    continue;
                end

                % Calculation of total residential space in a plot.
                for land_use_index = land_data_excel_columns.resgr : land_data_excel_columns.res13
                    total_residential = total_residential + num_land_data(plot_index, land_use_index);
                    original_total_residential = original_total_residential + num_land_data_global(plot_index, land_use_index);
                end

                % Calculation of total commercial space in a plot.
                for land_use_index = land_data_excel_columns.comgr : land_data_excel_columns.com13
                    total_commercial = total_commercial + num_land_data(plot_index, land_use_index);
                    original_total_commercial = original_total_commercial + num_land_data_global(plot_index, land_use_index);
                end

                % Calculation of total office space in a plot.
                for land_use_index = land_data_excel_columns.offgr : land_data_excel_columns.off13
                    total_office = total_office + num_land_data(plot_index, land_use_index);
                    original_total_office = original_total_office + num_land_data_global(plot_index, land_use_index);
                end 
            end
            tr=0;
            c=0;
            fc=0;

            if(total_residential >= original_total_residential + original_total_residential * percentage_change_allowed )
              tr=(total_residential-(original_total_residential + original_total_residential * percentage_change_allowed))/(original_total_residential + original_total_residential * percentage_change_allowed);
            elseif(total_residential <= original_total_residential - original_total_residential * percentage_change_allowed )
              tr=((original_total_residential - original_total_residential * percentage_change_allowed )-total_residential)/(original_total_residential - original_total_residential * percentage_change_allowed );
            end
            disp(total_residential);
            disp(original_total_residential);
            disp(total_office);
            disp(original_total_office);
            disp(total_commercial);
            disp(original_total_commercial);
            tr= (total_residential-original_total_residential)/original_total_residential;
                    
            if( total_commercial >= original_total_commercial + original_total_commercial * percentage_change_allowed )
              c=(total_commercial-(original_total_residential + original_total_residential * percentage_change_allowed))/total_residential;
         
            
            elseif(total_commercial <= original_total_commercial - original_total_commercial * percentage_change_allowed )
                c=((original_total_commercial - original_total_commercial * percentage_change_allowed )-total_commercial)/total_commercial;
        
            end
            c= (total_commercial-original_total_commercial)/original_total_commercial;
            disp(c);
            if(total_office >= original_total_office + original_total_office * percentage_change_allowed)
               fc=(total_commercial-(original_total_residential + original_total_residential * percentage_change_allowed))/total_residential;
         
            elseif(total_office <= original_total_office - original_total_office * percentage_change_allowed)
               fc=((original_total_office - original_total_office * percentage_change_allowed )-total_office)/total_office;
        
            end
                  fc= (total_office-original_total_office)/original_total_office;

                 percentage_change_constraint_satisfied1 = [original_total_residential total_residential original_total_commercial total_commercial original_total_office total_office tr c fc];
           disp(percentage_change_constraint_satisfied1);
        end



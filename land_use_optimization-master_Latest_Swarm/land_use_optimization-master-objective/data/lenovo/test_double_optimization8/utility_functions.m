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

classdef  (Sealed) utility_functions
methods (Access = private)
        function obj = utility_functions
        end
end
methods (Static)
        function alteration_allowed = is_alteration_allowed(plot_index)
            alteration_allowed = false;
            global num_land_data_global
            check = num_land_data_global(plot_index, land_data_excel_columns.change);
            if(check == 1)
                alteration_allowed = true;
            end
        end

        function [percent_of_commercial_use_in_block, percent_of_office_use_in_block, percent_of_civic_use_in_block] = get_percent_of_land_uses_in_block(block_no, num_land_data)

            total_commercial_area = 0;
            total_residential_area = 0;
            total_office_area = 0;
            total_civic_area = 0;
            total_miscellaneous = 0;

            [row, ~] = size(num_land_data);
            for i = 1 : row
                if(num_land_data(i, land_data_excel_columns.block_no) == block_no)
                    for j = land_data_excel_columns.comgr : land_data_excel_columns.com13
                        total_commercial_area = total_commercial_area + num_land_data(i,j);
                    end
                    for j = land_data_excel_columns.resgr : land_data_excel_columns.res13
                        total_residential_area = total_residential_area + num_land_data(i,j);
                    end
                    for j = land_data_excel_columns.offgr : land_data_excel_columns.off13
                        total_office_area = total_office_area + num_land_data(i,j);
                    end
                    for j = land_data_excel_columns.civicgr : land_data_excel_columns.civic13
                        total_civic_area = total_civic_area + num_land_data(i,j);
                    end
                    for j = land_data_excel_columns.schclggr : land_data_excel_columns.health13
                        total_miscellaneous = total_miscellaneous + num_land_data(i,j);
                    end
                end
            end

            total_block_area = total_commercial_area + total_residential_area + total_office_area + total_civic_area + total_miscellaneous;
            
            percent_of_commercial_use_in_block = total_commercial_area / total_block_area;
            percent_of_office_use_in_block = total_office_area / total_block_area;
            percent_of_civic_use_in_block = total_civic_area / total_block_area;
        end

        function land_price = get_land_price(is_residential, ln_distance_to_new_market, is_lakeview, is_plot_adjacent_to_major_road, percentage_commercial_block, percentage_office_block, ln_total_plot_size, num_of_uni_10k, percentage_civic_block, total_plot_size)
            ln_land_price_per_sqft = 8.288 - 0.403 * is_residential + 0.173 * ln_distance_to_new_market + 0.152 * is_lakeview + 0.105 * is_plot_adjacent_to_major_road - 0.149 * percentage_commercial_block + 0.344 * percentage_office_block + 0.047 * ln_total_plot_size + 0.808 * num_of_uni_10k + 0.443 * percentage_civic_block;
            land_price = exp(ln_land_price_per_sqft) * total_plot_size;
        end

        function [total_floor_space, ratio_residential, ratio_commercial, ratio_office, ratio_school_college, ratio_university, ratio_health, ratio_civic] = get_compatibility_parameters(plot_index, num_land_data)
            total_floor_space = 0;
            total_residential = 0;
            total_commercial = 0;
            total_office = 0;
            total_school_college = 0;
            total_university = 0;
            total_health = 0;
            total_civic = 0;

            % Calculation of total residential space in a plot.
            for land_use_index = land_data_excel_columns.resgr : land_data_excel_columns.res13
                total_residential = total_residential + num_land_data(plot_index, land_use_index);
            end
            total_floor_space = total_floor_space + total_residential;

            % Calculation of total commercial space in a plot.
            for land_use_index = land_data_excel_columns.comgr : land_data_excel_columns.com13
                total_commercial = total_commercial + num_land_data(plot_index, land_use_index);
            end
            total_floor_space = total_floor_space + total_commercial;

            % Calculation of total office space in a plot.
            for land_use_index = land_data_excel_columns.offgr : land_data_excel_columns.off13
                total_office = total_office + num_land_data(plot_index, land_use_index);
            end
            total_floor_space = total_floor_space + total_office;

            % Calculation of total school_college space in a plot.
            for land_use_index = land_data_excel_columns.schclggr : land_data_excel_columns.schclg13
                total_school_college = total_school_college + num_land_data(plot_index, land_use_index);
            end
            total_floor_space = total_floor_space + total_school_college;

            % Calculation of total university space in a plot.
            for land_use_index = land_data_excel_columns.unigr : land_data_excel_columns.uni13
                total_university = total_university + num_land_data(plot_index, land_use_index);
            end
            total_floor_space = total_floor_space + total_university;

            % Calculation of total health space in a plot.
            for land_use_index = land_data_excel_columns.healthgr : land_data_excel_columns.health13
                total_health = total_health + num_land_data(plot_index, land_use_index);
            end
            total_floor_space = total_floor_space + total_health;

            % Calculation of total civic space in a plot.
            for land_use_index = land_data_excel_columns.civicgr : land_data_excel_columns.civic13
                total_civic = total_civic + num_land_data(plot_index, land_use_index);
            end
            total_floor_space = total_floor_space + total_civic;

            % Avoid dividing 0 with 0 which could result in undefined value
            % or NaN
            if(total_floor_space == 0)
                total_floor_space = 1;
            end

            ratio_residential = total_residential / total_floor_space;
            ratio_commercial = total_commercial / total_floor_space;
            ratio_office = total_office / total_floor_space;
            ratio_school_college = total_school_college / total_floor_space;
            ratio_university = total_university / total_floor_space;
            ratio_health = total_health / total_floor_space;
            ratio_civic = total_civic / total_floor_space;
        end

        function [space_per_floor, parking_space, building_storey] = get_space_per_floor_with_parking(plot_index, num_land_data)
            total_floor_space = num_land_data(plot_index, land_data_excel_columns.total_floor_space);
            parking_space = num_land_data(plot_index, land_data_excel_columns.parking);
            building_storey = num_land_data(plot_index, land_data_excel_columns.bldg_storey);
            space_per_floor = (total_floor_space + parking_space) / building_storey;
        end
        
        function land_use_code = get_land_use_code(plot_index, num_land_data)
            total_residential = 0;
            total_commercial = 0;
            total_office = 0;
            land_use_code = 0;

            % Calculation of total residential space in a plot.
            for land_use_index = land_data_excel_columns.resgr : land_data_excel_columns.res13
                total_residential = total_residential + num_land_data(plot_index, land_use_index);
            end

            % Calculation of total commercial space in a plot.
            for land_use_index = land_data_excel_columns.comgr : land_data_excel_columns.com13
                total_commercial = total_commercial + num_land_data(plot_index, land_use_index);
            end

            % Calculation of total office space in a plot.
            for land_use_index = land_data_excel_columns.offgr : land_data_excel_columns.off13
                total_office = total_office + num_land_data(plot_index, land_use_index);
            end
            
            if((total_residential && total_commercial) || (total_commercial && total_office) || (total_office && total_residential) || (total_residential && total_commercial && total_office))
                land_use_code = land_uses.mixed;
            else
                if(total_residential)
                        land_use_code = land_uses.residential;
                end
                if(total_commercial)
                        land_use_code = land_uses.commercial;
                end
                if(total_office)
                        land_use_code = land_uses.office;
                end
            end
        end
        
        function percentage_change_constraint_satisfied = is_percentage_change_constraint_satisfied(percentage_change_allowed, num_land_data)
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
            if(total_residential >= original_total_residential + original_total_residential * percentage_change_allowed || total_residential <= original_total_residential - original_total_residential * percentage_change_allowed || total_commercial >= original_total_commercial + original_total_commercial * percentage_change_allowed || total_commercial <= original_total_commercial - original_total_commercial * percentage_change_allowed || total_office >= original_total_office + original_total_office * percentage_change_allowed || total_office <= original_total_office - original_total_office * percentage_change_allowed)
                percentage_change_constraint_satisfied = false;
            else
                percentage_change_constraint_satisfied = true;
            end
        end
        
        function total_effective_land_price_constraint_satisfied = is_total_effective_land_price_constraint_satisfied(minimum_total_effective_land_price, maximum_total_effective_land_price, total_effective_land_price)
            total_effective_land_price_constraint_satisfied = false;
            if(total_effective_land_price >= minimum_total_effective_land_price && total_effective_land_price <= maximum_total_effective_land_price)
                total_effective_land_price_constraint_satisfied = true;
            end
        end
        
        function constraints_satisfied = is_constraint_satisfied(percentage_change_allowed, num_land_data, minimum_total_effective_land_price, maximum_total_effective_land_price, total_effective_land_price)
            disp('Checking Constraints ...');
            constraints_satisfied = false;
            % check whether the randomization is under percentage change allowed
            percentage_change_constraint_satisfied = utility_functions.is_percentage_change_constraint_satisfied(percentage_change_allowed, num_land_data);
            % check whether the total effective land price is within the range
            total_effective_land_price_constraint_satisfied = utility_functions.is_total_effective_land_price_constraint_satisfied(minimum_total_effective_land_price, maximum_total_effective_land_price, total_effective_land_price);

            if(percentage_change_constraint_satisfied && total_effective_land_price_constraint_satisfied)
                constraints_satisfied = true;
            end
        end
        
        function land_price_compatibility_array = evaluate_objectives_array(population_array, num_block_data, ...
                num_neighborhood, text_neighborhood, num_compatibility_index)
            population = size(population_array);
            land_price_compatibility_array = zeros([population 3]);
            for iteration_count = 1 : population
                num_land_data = squeeze(population_array(iteration_count, : , :));
                [total_land_price, total_compatibility] = evaluate_objectives(num_land_data, num_block_data, num_neighborhood, ...
                    text_neighborhood, num_compatibility_index);

                land_price_compatibility_array(iteration_count, 1) = iteration_count; 
                land_price_compatibility_array(iteration_count, 2) = total_land_price;
                land_price_compatibility_array(iteration_count, 3) = total_compatibility;
            end
        end
        
        function decimal_value = get_random_decimal_value_by_plot(plot_index)
            global num_land_data_global
            building_storey = num_land_data_global(plot_index, land_data_excel_columns.bldg_storey);
            ternary_string = [];
            for storey = 1 : building_storey
                land_use = ceil(unifrnd(0,3));
                land_use = land_use - 1;
                ternary_string = [ternary_string num2str(land_use)];
            end
            decimal_value = base2dec(ternary_string, 3);
        end

        function [plot_decimal_value, plot_ternary_value] = get_values_by_num_land_data(num_land_data)
            maximum_storey_per_building = land_data_excel_columns.res13 - land_data_excel_columns.resgr + 1;
            number_of_plot = size(num_land_data);
            plot_decimal_value = [];
            plot_ternary_value = containers.Map('KeyType','int32','ValueType','char');
            effective_j = 1;
            for j = 1 : number_of_plot

                if(not(utility_functions.is_alteration_allowed(j)))
                    continue;
                end

                storey = num_land_data(j, land_data_excel_columns.bldg_storey);
                ternary_representation = [];
                for k = 1 : storey
                    excel_field = land_data_excel_columns.resgr;
                    res_used_space = num_land_data(j, excel_field + k - 1);
                    excel_field = excel_field + maximum_storey_per_building;
                    com_used_space = num_land_data(j, excel_field + k - 1);
                    excel_field = excel_field + maximum_storey_per_building;
                    off_used_space = num_land_data(j, excel_field + k - 1);
                    if(res_used_space > 0)
                        ternary_representation = [ternary_representation '0'];
                    elseif(com_used_space > 0)
                        ternary_representation = [ternary_representation '1'];
                    elseif(off_used_space > 0)
                        ternary_representation = [ternary_representation '2'];
                    end
                end
                [space_per_floor, parking_space, ~] = utility_functions.get_space_per_floor_with_parking(j, num_land_data);

                if(space_per_floor == parking_space)
                    ternary_representation = ['0' ternary_representation];
                end

                decimal_representation = base2dec(ternary_representation, 3);
                plot_id = num_land_data(j, land_data_excel_columns.plot_ID);
                plot_decimal_value(effective_j, 1) = plot_id;
                plot_decimal_value(effective_j, 2) = decimal_representation;
                plot_decimal_value(effective_j, 3) = 1;
                plot_ternary_value(plot_id) = ternary_representation;
                effective_j = effective_j + 1;
            end
        end

        function plot_decimal_value = get_decimal_values_by_num_land_data(num_land_data)
            maximum_storey_per_building = land_data_excel_columns.res13 - land_data_excel_columns.resgr + 1;
            number_of_plot = size(num_land_data);
            plot_decimal_value = [];
            effective_j = 1;
            for j = 1 : number_of_plot

                if(not(utility_functions.is_alteration_allowed(j)))
                    continue;
                end

                storey = num_land_data(j, land_data_excel_columns.bldg_storey);
                ternary_representation = [];
                for k = 1 : storey
                    excel_field = land_data_excel_columns.resgr;
                    res_used_space = num_land_data(j, excel_field + k - 1);
                    excel_field = excel_field + maximum_storey_per_building;
                    com_used_space = num_land_data(j, excel_field + k - 1);
                    excel_field = excel_field + maximum_storey_per_building;
                    off_used_space = num_land_data(j, excel_field + k - 1);
                    if(res_used_space > 0)
                        ternary_representation = [ternary_representation '0'];
                    end
                    if(com_used_space > 0)
                        ternary_representation = [ternary_representation '1'];
                    end
                    if(off_used_space > 0)
                        ternary_representation = [ternary_representation '2'];
                    end
                end
                decimal_representation = base2dec(ternary_representation, 3);
                plot_decimal_value(effective_j, 1) = num_land_data(j, land_data_excel_columns.plot_ID);
                plot_decimal_value(effective_j, 2) = decimal_representation;
                effective_j = effective_j + 1;
            end
        end
        
        function [population_decimal_values, population_ternary_values] = get_decimal_value_of_variables(population_array)
            population = size(population_array);
            maximum_storey_per_building = land_data_excel_columns.res13 - land_data_excel_columns.resgr + 1;
            for i = 1 : population
                num_land_data = squeeze(population_array(i, :, :));
                number_of_plot = size(num_land_data);
                
                plot_decimal_value = [];
                plot_ternary_value = [];
                effective_j = 1;
                for j = 1 : number_of_plot

                    if(not(utility_functions.is_alteration_allowed(j)))
                        continue;
                    end

                    storey = num_land_data(j, land_data_excel_columns.bldg_storey);
                    ternary_representation = [];
                    for k = 1 : storey
                        excel_field = land_data_excel_columns.resgr;
                        res_used_space = num_land_data(j, excel_field + k - 1);
                        excel_field = excel_field + maximum_storey_per_building;
                        com_used_space = num_land_data(j, excel_field + k - 1);
                        excel_field = excel_field + maximum_storey_per_building;
                        off_used_space = num_land_data(j, excel_field + k - 1);
                        if(res_used_space > 0)
                            ternary_representation = [ternary_representation '0'];
                        end
                        if(com_used_space > 0)
                            ternary_representation = [ternary_representation '1'];
                        end
                        if(off_used_space > 0)
                            ternary_representation = [ternary_representation '2'];
                        end
                    end
                    decimal_representation = base2dec(ternary_representation, 3);
                    plot_decimal_value(effective_j, 1) = num_land_data(j, land_data_excel_columns.plot_ID);
                    plot_decimal_value(effective_j, 2) = decimal_representation;
                    plot_ternary_value{effective_j} = ternary_representation;
                    effective_j = effective_j + 1;
                end
                population_decimal_values(i, :, :) = plot_decimal_value;
                population_ternary_values(i, :, :) = plot_ternary_value;
            end
        end
        
        function u_limit = upper_limit_per_plot()
            global num_land_data_global
            [number_of_plots, ~] = size(num_land_data_global);
            u_limit = [];
            for i = 1 : number_of_plots
                if(not(utility_functions.is_alteration_allowed(i)))
                    continue;
                end

                storey = num_land_data_global(i, land_data_excel_columns.bldg_storey);
                highest_use = [];
                for j = 1 : storey
                    highest_use = [highest_use '2'];
                end
                highest_use_num = base2dec(highest_use, 3);
                u_limit = [u_limit; highest_use_num];
            end
        end
        
        function ternary_value = get_ternary_value(decimal_value, expected_length)
            ternary_value = dec2base(decimal_value, 3);
            [~,ternary_value_size] = size(ternary_value);
            length_diff = expected_length - ternary_value_size;
            iteration = 1;
            while(iteration <= length_diff)
                ternary_value = ['0' ternary_value];
                iteration = iteration + 1;
            end
        end
        
        function excel_index = get_excel_index_from_plot_id(plot_id, num_land_data)
            [row_count, ~] = size(num_land_data);
            for row = 1 : row_count
                if(plot_id == num_land_data(row, land_data_excel_columns.plot_ID))
                    excel_index = row;
                    break;
                end
            end
        end
        
        function out_num_land_data = update_num_land_data(plot_index, num_land_data, land_use_string)
            maximum_storey_per_building = land_data_excel_columns.res13 - land_data_excel_columns.resgr + 1;
            [space_per_floor, parking_space, building_storey] = utility_functions.get_space_per_floor_with_parking(plot_index, num_land_data);
            original_space_per_floor = space_per_floor;

            for storey = 1 : building_storey
                land_use = land_use_string(storey);
                if(storey == 1) % subtract parking space from the ground floor
                    space_per_floor = space_per_floor - parking_space;
                else
                    space_per_floor = original_space_per_floor;
                end
                switch land_use
                    case '0'
                        storey_res_in_excel = land_data_excel_columns.resgr + storey - 1;
                        storey_com_in_excel = storey_res_in_excel + maximum_storey_per_building;
                        storey_off_in_excel = storey_com_in_excel + maximum_storey_per_building;
                        num_land_data(plot_index, storey_res_in_excel) = space_per_floor;
                        num_land_data(plot_index, storey_com_in_excel) = 0;
                        num_land_data(plot_index, storey_off_in_excel) = 0;
                    case '1'
                        storey_com_in_excel = land_data_excel_columns.comgr + storey - 1;
                        storey_res_in_excel = storey_com_in_excel - maximum_storey_per_building;
                        storey_off_in_excel = storey_com_in_excel + maximum_storey_per_building;
                        num_land_data(plot_index, storey_com_in_excel) = space_per_floor;
                        num_land_data(plot_index, storey_res_in_excel) = 0;
                        num_land_data(plot_index, storey_off_in_excel) = 0;
                    case '2'
                        storey_off_in_excel = land_data_excel_columns.offgr + storey - 1;
                        storey_com_in_excel = storey_off_in_excel - maximum_storey_per_building;
                        storey_res_in_excel = storey_com_in_excel - maximum_storey_per_building;
                        num_land_data(plot_index, storey_off_in_excel) = space_per_floor;
                        num_land_data(plot_index, storey_com_in_excel) = 0;
                        num_land_data(plot_index, storey_res_in_excel) = 0;
                    otherwise
                end
            end

            % update land use code accordingly
            land_use_code = utility_functions.get_land_use_code(plot_index, num_land_data);
            num_land_data(plot_index, land_data_excel_columns.landuse_code) = land_use_code;
            out_num_land_data = num_land_data;
        end
        
        function out_num_land_data = get_num_land_data_from_values(decimal_values_per_solution, ternary_values_per_solution)
            global num_land_data_global
            out_num_land_data = num_land_data_global;
            num_of_plots = size(decimal_values_per_solution);
            for plot_index = 1 : num_of_plots
                is_change = decimal_values_per_solution(plot_index, 3);
                if(is_change)
                    plot_id = decimal_values_per_solution(plot_index, 1);
                    ternary_value = ternary_values_per_solution(plot_id);
                    excel_index = utility_functions.get_excel_index_from_plot_id(plot_id, out_num_land_data);
                    out_num_land_data = utility_functions.update_num_land_data(excel_index, out_num_land_data, ternary_value);
                end
            end
        end
end
end

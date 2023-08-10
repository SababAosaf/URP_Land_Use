## Generating Alternative Land Use Allocation for Mixed Use Areas: Multi-Objective Optimization Approach
This research has been carried out with an intension to present an optimization approach for the urban land use allocation problem by generating Pareto optimum Solutions considering two objectives - maximizing compatibility among adjacent land uses of a study area without compromising the area’s total land price and maximizing the price of each plot. Considering the non-linear characteristics of the objective functions, here a multi-objective evolutionary algorithm approach called Non-Dominated Sorting Genetic Algorithm-II (NSGA-II) has been applied to obtain Pareto optimal land use allocation subject to different set of constraints. The resulting NSGA-II model produces 24 Pareto optimal Solutions of land use allocation, allowing tradeoff between maximizing compatibility and land price from one solution to other. 

In this repository, the MATLAB implementation of the research work has been added here.

### MATLAB Implementation for Land Use Optimization using NSGA-II
This project consists of the following files:
* calculate\_compatibility.m
* handle\_input.m
* land\_uses.m
* non\_dominated\_sorting.m
* replace\_chromosome.m
* utility\_functions.m
* calculate\_land\_price.m
* evaluate\_objectives.m
* initialize\_population.m
* neighborhood\_excel\_columns.m
* nsgaii\_main.m
* compatibility\_excel\_fields.m
* genetic\_operator.m
* land\_data\_excel\_columns.m
* non\_dominated\_sorting\_constraint.m
* tournament\_selection.m

Besides, a sample data file has been added in the expected format with dummy data:
* data/input\_data.xlsx

#### Functionality of Each File
The functionalities of all the included files are depicted below:
* **calculate\_compatibility.m** - This file has the implementation of a function *calculate_compatibility*, which calculates the compatibility of each plot with respect to the neighboring plots' land use. For this calculation, the values from *compatibility_index* sheet of *input_data.xlsx* are used.
* **handle\_input.m** - The function *handle_input* defined in this file, is used to load the data in all the sheets of *input_data.xlsx* into data structures that are globally accessible to the whole system.
* **land\_uses.m** - This file defines a class *land_uses* with the values *residential* equal to 1, *commercial* equal to 2, *office* equal to 3 and *mixed* equal to 8.
* **non\_dominated\_sorting.m** - This file consists of *non_dominated_sorting* function which applies the Non dominated sorting algorithm on the initial population that is generated randomly in the beginning of the entire process.
* **replace\_chromosome.m** - This file consists a function *replace_chromosome* that replaces the chromosomes based on rank and crowding distance. Initially, each front is added one by one until addition of a complete front which results in exceeding the population size. At this point the chromosomes in that front is added subsequently to the population based on crowding distance.
* **utility\_functions.m** - This file has the definition of *utility_functions* class which implements the utility functions, such as *evaluate_objectives_array* to generate the array of plot index and the objectives (i.e. land price and compatibility), *get_random_decimal_value_by_plot* to generate random land uses per plot etc.
* **calculate\_land\_price.m** - This file implements *calculate_land_price* method that calculates the land prices of all the plots and returns the land prices of all the plots in the study area.
* **evaluate\_objectives.m** - This file consists of *evaluate_objectives* function that calls *calculate_land_price* and *calculate_compatibility* and returns the objective values (i.e. both land price and compatibility) of all the plots in the study area.
* **initialize\_population.m** - This file implements *initialize_population* function to generate the initial population for the whole process that has randomized combination of land uses on the plots of the study area. Besides, it evaluates the objective functions on the initial population and stores the objective values per plot.
* **neighborhood\_excel\_columns.m** - This file defines a class *neighborhood_excel_columns* with the values *plot_id* equal to 1 and *neighbors* equal to 2.
* **nsgaii\_main.m** - This file is the entry point of the NSGA-II implementation. The user can customize different parameters in the source code to adjust the procedure according to specific requirements.
* **compatibility\_excel\_fields.m** - This file defines a class *compatibility_excel_fields* with the values *residential* equal to 1, *commercial* equal to 2, *office* equal to 3, *school_college* equal to 4, *university* equal to 5, *health* equal to 6 and *civic* equal to 7.
* **genetic\_operator.m** - The function *genetic_operator(parent_chromosome, V, mu, mum, l_limit, u_limit, percentage_change_allowed, minimum_total_effective_land_price, maximum_total_effective_land_price, genetic_operators_change_allowed)* in this file is utilized to produce offsprings from parent chromosomes. The genetic operators implemented here are crossover and mutation. The genetic operation is performed only on the decision variables, that is the first V elements in the chromosome vector.
* **land\_data\_excel\_columns.m** - This file defines a class *land_data_excel_columns* that maps the excel column values of *total_land_data* sheet in the *input_data.xlsx* file to readable names.
* **non\_dominated\_sorting\_constraint.m** - This file consists of *non_dominated_sorting_constraint* function which applies the Non dominated sorting algorithm on the population of each iteration of NSGA-II algorithm and returns the population that satisfy the given constraints, such as the percentage of change allowed on the map, minimum total effective land price and  maximum total effective land price.
* **tournament\_selection.m** - This file implements a function *tournament_selection(pool_size, tour_size)* which is the selection policy for selecting the individuals for the mating pool. The selection is based on tournament selection. By varying the tournament size the selection pressure can be adjusted. But for NSGA-II, the tournament size is fixed to two, but the user may feel free to experiment with different tournament sizes.
* **data/input\_data.xlsx** - This file has the sample input data that will be required for operating the code. The file name, the data sheet names, and all the column names should remain exactly same in order to run the script. The excel file has 4 sheets: 
<br />
**total_land_data** - It has the sample land use information of a plot. The user needs to create records of different plots of a concerned area that will comprise of the listed land use variables mentioned in the sheet.
<br />
**neighborhood** - The plots sharing the boundary of a particular plot is considered as the neighbors of that plot. A list of neighboring plots of each plot in the study area has to be recorded in this sheet according to the sample input provided.
<br />
**compatibility_index** - This sheet includes the compatibility indices of different land uses.
<br />
**block_area** - It has the sample required information of a block. The user needs to create records of different blocks of a concerned area that will comprise of the listed variables mentioned in the sheet.

#### How to Use
* **Pre-requisites** - Install MATLAB 2013 or higher in the system.
* **Populate Data** - Populate data of the concerned study area in the *data/input_data.xlsx* file according to the information provided in the previous section.
* **Customizations** - In the nsgaii_main.m file, change the values of the following variables according to the user requirement:
<br />
**number_of_generations** - Total iterations in the NSGA-II
<br />
**population** - The size of initial population
<br />
**total_number_of_changeable_plots** - Total number of plots for which changes are allowed
<br />
**initialization_change_allowed** - The percentage of allowed change during the initialization of the population
<br />
**genetic_operators_change_allowed** - The percentage of allowed change during crossover and mutation processes
<br />
**percentage_change_allowed** - The percentage of land use change during each iteration of the algorithm
<br />
**minimum_total_effective_land_price** - The minimum allowed total land price of the system
<br />
**maximum_total_effective_land_price** - The maximum allowed total land price of the system
* **How to Run** - After performing all the customizations and adding the records of the concerned study area in the *data/input_data.xlsx* file, simply run the *nsgaii_main.m* script from the MATLAB console.
* **Results** - After successful completion of the script, the following resultant files will be generated:
<br />
**output_[solution_id].xlsx** - The detailed information of each solution of the final generation in the format of *total_land_data* sheet in *input_data.xlsx* file.
<br />
**initial_population.xlsx** - The value of objective functions of each solution of the initial population.
<br />
**comparative_land_price_[solution_id]** - The land price information of each solution of the final generation compared to that of the original population.
<br />
**iteration_convergence_[generation_id]** - The ranking information of the total population at each tenth iteration.
<br />
**ranking.xlsx** - This file will contain generated land price, compatibility, pareto front number and crowding distance for each solution of the final generation. The pareto optimal solution can be determined from this result. Upon determining the pareto optimal solution, the relevant land use code can be found from the "output_[solution_id].xlsx file, from which the user will be able to produce a land use map of pareto optimal solution using ArcGIS Software.

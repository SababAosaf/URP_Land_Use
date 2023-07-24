# This is a sample Python script.

# Press Shift+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.
import os
import openpyxl

base_compatibility=3355496014875
base_price=132353281248.2



big_price=5
big_compatibility=5

compatibility_of_big_price=5
price_of_big_compatibility=5
file_of_big_compatibility=''

list_good_solutions = []
row=''


for i in range(8,9):

    data_folder='D://Projects//Msc_Research//URP_Land_Use//land_use_optimization-master_DE//data//test_'+str(i)+'//'
    #data_folder='D://Projects//Msc_Research//URP_Land_Use//land_use_optimization-master_DE//data//test_7//config//data//'
    lists=os.listdir(data_folder)
    list_files=[]
    file_name = 'iteration_convergence_85.xlsx' # change it to the name of your excel file
    for i in lists:
        if 'iteration_convergence' in i:
            list_files.append(i)
            file=data_folder+file_name

    for file in list_files:
        workbook = openpyxl.load_workbook(data_folder+file).active

        for row in workbook.iter_rows(min_row=1, max_row=100,min_col=1,max_col=3,values_only=True):
           price=row[1]
           compatibility=row[2]

           if price>big_price:
               big_price=price
               compatibility_of_big_price=compatibility
           if compatibility>big_compatibility:
               big_compatibility=compatibility
               price_of_big_compatibility=price
               file_of_big_compatibility=data_folder+file

           if price>base_price and compatibility>base_compatibility:
               list_good_solutions.append((data_folder+file,price,compatibility))



    print(big_price)
    print(compatibility_of_big_price)
    print()

    print(price_of_big_compatibility)
    print(big_compatibility)
    print(file_of_big_compatibility)

for i in list_good_solutions:
    print(i)

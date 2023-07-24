import openpyxl

file1 = open('D:\\Projects\\Msc_Research\\URP_Land_Use\\files.txt', 'r')
file_1=open('D:\\Projects\\Msc_Research\\URP_Land_Use\\results_.csv','w')
Lines = file1.readlines()
best_price=0
best_file=''
best_compatibility=0
best_file_comp=''
fn=1
for i in Lines:
    try:
        file=i.replace('\n','')+'\\iteration_convergence_150.xlsx'
        workbook = openpyxl.load_workbook(file).active


        for row in workbook.iter_rows(min_row=1, max_row=100,min_col=1,max_col=5,values_only=True):

           if row[3]==1:
               #print(row)
               price=row[1]
               compatibility=row[2]
               if price>best_price:
                   best_price=price
                   best_file=file
               if compatibility>best_compatibility:
                   best_compatibility=compatibility
                   best_file_comp=file
               rw=str(fn)+','+str(price)+','+str(compatibility)+'\n'
               print(rw)
               file_1.writelines(rw)
        fn=fn+1
    except:
        pass
print(best_price)
print(best_file)
file_1.close()

print(best_compatibility)
print(best_file_comp)

'''price=row[1]
compatibility=row[2]
pareto=row[3]
value=row[4]
print(price)
print(compatibility)
print(pareto)
print(value)'''




import traceback

import openpyxl

file1 = open('D:\\Projects\\Msc_Research\\URP_Land_Use\\files.txt', 'r')
file_1=open('D:\\Projects\\Msc_Research\\URP_Land_Use\\results_.csv','w')
Lines = file1.readlines()
best_price=0
best_file=''
best_compatibility=0
best_file_comp=''
fn=1

try:
    file='initial_population.xlsx'
    workbook = openpyxl.load_workbook(file).active
    pareto=[]
    s=[]
    s1=[]

    for row in workbook.iter_rows(min_row=1, max_row=100,min_col=1,max_col=5,values_only=True):
        s.append(row)
        s1.append(row)
    for r in s:
        flag=2
        for r1 in s1:
            if r[1]<r1[1] and r[2]<r1[2]:
                flag=4
        if flag==2:
            pareto.append(r)
    print(pareto)
    f=open('s.csv','w')
    for i in pareto:
        f.write(str(i[1])+','+str(i[2])+'\n')

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




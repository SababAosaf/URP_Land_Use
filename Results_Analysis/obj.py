import traceback

import openpyxl

file1 = open('D:\\Projects\\Msc_Research\\URP_Land_Use\\file.txt', 'r')
Lines = file1.readlines()
best_price=0
best_file=''
best_compatibility=0
best_file_comp=''
fn=1
#for i in Lines:
if True:
    #if 'lenovo' in i:
    #    ij=i.split(' ')
    #    i='D:\\Projects\\Msc_Research\\URP_Land_Use\\land_use_optimization-master-objective\\data\\lenovo\\'+ij[1]+'\\data\\iteration_convergence_150.xlsx'+' '+ij[2]


    #ij=i.split(' ')

    ij="D:\\Projects\\Msc_Research\\URP_Land_Use\\land_use_optimization-master-objective\\data\\test_double_optimization6 - Copy (2)\\data\\iteration_convergence_150.xlsx 22.5"

    ik="D:\\Projects\\Msc_Research\\URP_Land_Use\\land_use_optimization-master-objective\\data\\test_double_optimization6 - Copy (2)\\data\\iteration_convergence_150.xlsx"
    ik="D:\\Projects\\Msc_Research\\URP_Land_Use\\land_use_optimization-master-objective\\data\\test_double_optimization6 - Copy (5)\\data\\compare.xlsx"
    ik2="22.5"


    if 'c' not in ik2:
        ik2=float(ik2)
        ikp=ik2/(ik2+1)
        ikc=1/(ik2+1)

    else:
        ik2=float(ik2[1:])
        ikc=ik2/(ik2+1)
        ikp=1/(ik2+1)


    try:
        workbook = openpyxl.load_workbook(ik).active
        vals=0
        prices=0
        c=0
        hikp=0
        hikc=0

        for row in workbook.iter_rows(min_row=1, max_row=83,min_col=1,max_col=5,values_only=True):

           if True:

               price=row[1]
               compatibility=row[2]

               val=price*ikp+compatibility*ikp
               print(val)
               if val>vals:
                   vals=val
                   prices=price
                   c=compatibility
                   hikc=ikc
                   hikp=ikp
        fn=fn+1

        print(str(hikp)+','+str(hikc)+','+str(vals)+','+str(prices)+','+str(c))


    except:
        traceback.print_exc()
        pass




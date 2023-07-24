import traceback

import openpyxl

def name_file(num):
    return 'output_'+str(num)+'.xlsx'

file1 = open('D:\\Projects\\Msc_Research\\URP_Land_Use\\files.txt', 'r')
file_1=open('D:\\Projects\\Msc_Research\\URP_Land_Use\\results_.csv','w')
info=[ 'SBX+Mu 60% Best Compatibility','SBX+Mu 60% Largest Crowding','SBX+Mu 60% Best Price', 'SBX+Mu 80% Best Compatibility','SBX+Mu 80% Largest Crowding','SBX+Mu 80% Best Price', 'SBX+Mu 100% Best Compatibility','SBX+Mu 100% Largest Crowding Distance','SBX+Mu 100% Best Price','CR+DES 40% LC Best Compatibility','CR+DES 40% LC Largest Crowding Distance','CR+DES 40% LC Best Price','CR+DES 40% LC Best Compatibility','CR+DES 40% LC Largest Crowding Distance','CR+DES 40% LC Best Price']
staic_mixed=80
sbx_60='D:\\Projects\\Msc_Research\\URP_Land_Use\\land_use_optimization-master\\data\\test_1 - Copy (5) - Copy\\config\\data'
sbx_80='D:\\Projects\\Msc_Research\\URP_Land_Use\\land_use_optimization-master\\data\\test_1 - Copy (5) - Copy - Copy\\config\\data'
sbx_100='D:\\Projects\\Msc_Research\\URP_Land_Use\\land_use_optimization-master\\data\\test_1 - Copy (5) - Copy - Copy - Copy\\config\\data'
cr_des_40_lc='D:\\Projects\\Msc_Research\\URP_Land_Use\\land_use_optimization-master\\data\\test_c - Copy - Copy - Copy (3) - Copy\\data'
cr_des_40_coa='D:\\Projects\\Msc_Research\\URP_Land_Use\\land_use_optimization-master\\data\\test_c - Copy - Copy - Copy (5) - Copy\\data'
Lines = [sbx_60+'\\'+name_file(7),sbx_60+'\\'+name_file(4),sbx_60+'\\'+name_file(2),sbx_80+'\\'+name_file(1),sbx_80+'\\'+name_file(4),sbx_80+'\\'+name_file(2),sbx_100+'\\'+name_file(2),sbx_100+'\\'+name_file(5),sbx_100+'\\'+name_file(1),cr_des_40_lc+'\\'+name_file(2),cr_des_40_lc+'\\'+name_file(8),cr_des_40_lc+'\\'+name_file(4),cr_des_40_coa+'\\'+name_file(5),cr_des_40_coa+'\\'+name_file(1),cr_des_40_coa+'\\'+name_file(3)]
best_price=0
best_file=''
best_compatibility=0
best_file_comp=''
fn=1
flag=1
the_cse=0
current=0
for i in Lines:
    the_cse=0
    try:
        file=i

        workbook = openpyxl.load_workbook(file).active


        list_plot=[]
        res=0
        co=0
        oo=0
        m=0
        static_=0
        flag=1
        rs=[]
        cm=[]
        wk=[]
        row_count=0
        for row in workbook.iter_rows(min_row=1, max_row=1568,min_col=1,max_col=150,values_only=True):
            try:
               row_count=row_count+1


               r=0
               c=0
               o=0
               for pc in range(7,21):
                   r=r+row[pc]
               for pc in range(21, 35):
                   c=c+row[pc]
               for pc in range(35, 49):
                   o = o + row[pc]
               ar=0

               sc=0
               uni=0
               hos=0
               civil=0
               for pc in range(49,63):
                   sc=sc+row[pc]
               for pc in range(63,77):
                   uni=uni+row[pc]
               for pc in range(77,91):
                   hos=hos+row[pc]
               for pc in range(91,105):
                   civil=civil+row[pc]
               ar=sc+uni+hos+civil
               rs1=0
               if ar!=0:
                   if o>0 or r>0 or c>0:
                       m=m+1
                       static_=static_+1
                   elif (sc!=0 and uni!=0) or (uni!=0 and hos!=0) or (hos!=0 and civil!=0) or (uni!=0 and hos!=0) or (uni!=0 and civil!=0) or (hos!=0 and civil!=0) :
                       m=m+1
                       static_=static_+1
               elif o==0 and c==0 and r!=0:
                   res=res+1
                   rs1=1
               elif c==0 and r==0 and o!=0:
                   oo=oo+1
                   pass
               elif o==0 and r==0 and c!=0:
                   co=co+1
                   pass
               elif o>0 or r>0 or c>0:
                   m=m+1
                   the_cse=the_cse+1
                   pass

            except :
                traceback.print_exc()
                pass
        print(info[current]+","+str(res)+ ','+str(co)+','+str(oo)+','+str(m))

        flag=0





    except:
        traceback.print_exc()
        pass

    current=current+1
'''price=row[1]
compatibility=row[2]
pareto=row[3]
value=row[4]
print(price)
print(compatibility)
print(pareto)
print(value)'''




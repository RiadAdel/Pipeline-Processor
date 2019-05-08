# all numbers in hex format
# we always start by reset signal
#this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
2
#you should ignore empty lines

.ORG 1  #this is the interrupt address
100

.ORG 2
in R1          #R1 =1000 , C--> 0, N --> 0, Z -->  0
inc R2	       #R2 =0001 , C --> 0 , N --> 0 , Z --> 0
Add R1,R2	   #R2= 1001, C--> 0, N -->0 , Z-->0
Sub R2,R3      #R3 = FFFF , C --> 0 , N --> 1 ,z  -->0
OUT R3

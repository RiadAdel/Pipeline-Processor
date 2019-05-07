# all numbers in hex format
# we always start by reset signal
#this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
2
#you should ignore empty lines

.ORG 1  #this is the interrupt address
100

.ORG 2
inc R1         #R1 =0001 , C--> 0, N --> 0, Z -->  0
inc R2	       #R2 =0001 , C --> 0 , N --> 0 , Z --> 0
add R2,R1	       #R2= FFEF, C--> no change, N -->1,Z-->0
inc R1

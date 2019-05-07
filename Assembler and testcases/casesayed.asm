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
dec R2
inc R4
inc R3              #R2 =0001 , C --> 0 , N --> 0 , Z --> 0
inc R5
inc R6
out R1
add R2,R4	       #R2= FFEF, C--> no change, N -->1,Z-->0

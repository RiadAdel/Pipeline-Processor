# all numbers in hex format
# we always start by reset signal
#this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
2
#you should ignore empty lines

.ORG 1  #this is the interrupt address
100

.ORG 2
inc R1
inc R2
STD R1 , R2
STD R1 , R3





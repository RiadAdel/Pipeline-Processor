import re
import sys

class processedCommand():
    def __init__(self, instr, reg1, reg2, address):
        self.instr = instr
        self.reg1 = reg1
        self.reg2 = reg2
        self.address = address
    
instruction = {
    
    #____________ONE_operand_____________
    "nop" :	"00000",
    "setc": "00001",
    "clrc": "00010",
    "not" :	"00011",
    "inc" :	"00100",
    "dec" :	"00101",
    "out" :	"00110",
    "in"  :	"00111",
    #____________TWO_operand_____________
    "mov" : "01000",
	"add" : "01001",
	"sub" : "01010",
	"and" : "01011",
	"or"  : "01100",
	"shl" : "01101",
	"shr" : "01110",
    #____________MEMORY_operand_____________
    "push": "10000",
    "pop" : "10001",
    "ldm" : "10010",
    "ldd" : "10011",
    "std" : "10100",
    #____________Branch_and_Change_of_Control_Operations_____________
    "jz"  : "11000",
    "jn"  : "11001",
    "jc"  : "11010",
    "jmp" : "11011",
    "call": "11100",
    "ret" : "11101",
    "rti" : "11110"

}

register = {
   "r0" : "000",
	"r1" : "001",
	"r2" : "010",
	"r3" : "011",
	"r4" : "100",
	"r5" : "101",
	"r6" : "110",
	"r7" : "111"
}

branch=["br","beq","bne","blo","bls" ,"bhi","bhs"]


command = list()
def readCommands(filename):
        with open(filename) as f:
            global command
            command = f.readlines()

if(len(sys.argv) > 1):
    filePath = sys.argv[1]
else:
    filePath = input("Enter file path:\n")
readCommands(filePath)
pCommandList = []

OneOperandDst = ["pop" , "in" , "not" , "inc" , "dec" ]

address = -1
for i in range(0, len(command)):
    command[i] = command[i].lower().replace("\n","")
    commandList = command[i].split("#")[0].split(" ")
    commandList = list(filter(lambda a: a != "", commandList))
    instr = ""
    if(len(commandList) != 0):
        instr = commandList[0]
        opr1 = ""
        opr2 = ""
        currentAddress = address
        if (instr == ".org"):
            address = int(commandList[1]) - 1
        elif(len(commandList) == 2):	#[mov "ro,r1"] or [inc "r1"]
            if(',' in commandList[1]):
                opr1 = commandList[1].split(",")[0]
                opr2 = commandList[1].split(",")[1]
            else:
                opr1 = commandList[1] #one operand
        elif(len(commandList) == 3):	#[mov "r0 " ",r1"] or [mov "r0," " r1"]
            opr1 = commandList[1].replace(",","")
            opr2 = commandList[2].replace(",","")
        elif(len(commandList) == 4):	#[mov "r0" "," "r1"]
            opr1 = commandList[1]
            opr2 = commandList[3]
        #------------------------------------------------------------------------------
        if (opr1 !="" and opr2==""):
            if (instr in OneOperandDst):
                    opr2 = opr1
                    opr1 = ""
        elif (opr1!="" & opr2 !=""):
            if (instr == "shl" or instr == "shr"):
                temp = opr1
                opr1 = opr2
                opr2 = temp
            elif (instr == "ldm"):
                 pCommandList.append(processedCommand(instr, "" , opr1, currentAddress))
                 pCommandList.append(processedCommand(opr2, "" , "", currentAddress+1))
                 address+=1
                 
                 
        
        address += 1
        if(instr != ".org" and instr!="ldm"):
            reg1, reg2 = opr1, opr2
            pCommandList.append(processedCommand(instr, reg1 , reg2, currentAddress))
        #------------------------------------------------------------------------------



f = open("output10.txt", "w")
get_bin = lambda x , n:format(x , 'b').zfill(n)
for c in pCommandList:
    #print (c)
    data1 = ""
    data2 = ""
    
    if(c.instr not in instruction):    #.org  # handle hex
        integer = int(c.instr)
        integer = get_bin(integer, 16)
        f.write(str(integer) + "\n")
        continue
    
    f.write(instruction[c.instr])
    #m3ltsh srcExist w dstExist lsa
    #mgrbtsh kter
    #el print 3moman msh 5lsan lsa
    
    if(c.reg1 != ""):   
        f.write('1')
    else :
        f.write('0')
    if (c.reg2!= ""):
        f.write('1')
    else :
        f.write('0')
    
    if(c.reg1 != ""):
        if(c.reg1 not in register):    #.org
            integer = int(c.reg1)
            integer = get_bin(integer, 6)
            f.write(str(integer))
        else:
            f.write("000")
            f.write(register[c.reg1])
    else:
        f.write("000000")
    
    
    
    if(c.reg2 != ""): 
        f.write(register[c.reg2])
    else :
        f.write("000")

   
    
    f.write("\n")
f.close()
   
        
for c in pCommandList:
    print(c.address, c.instr, c.reg1, c.reg2)

"""for i in range(0, len(command)):
    print(command[i].split(" "))"""
    
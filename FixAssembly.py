import argparse

parser = argparse.ArgumentParser(description='Fix problems directly in assembly')
parser.add_argument('--inFilename', type=str, action='store', required=True,
                    help='filename of the input assembly file')

args = parser.parse_args()

# Substitue original register with corresponding shadow in an instruction
def substituteRegs(s):
    new_s = s.split(",")
    orig_regs = ["x" + str(i) for i in [0,4,5,6,19,20,7,8,29,30,1,2,3]]
    shadow_regs = ["x" + str(i) for i in [23,10,11,22,12,13,14,16,17,18,24,15,9]]
    orig_regs.extend(["fp","lr","sp"])
    shadow_regs.extend(["x17", "x18", "x21"])
    orig_regs.extend(["w" + str(i) for i in [0,4,5,6,19,20,7,8,29,30,1,2,3]])
    shadow_regs.extend(["w" + str(i) for i in [23,10,11,22,12,13,14,16,17,18,24,15,9]])
    orig_regs.append("wsp")
    shadow_regs.append("w21")
    for prefix in ["d", "q", "h", "b", "s"]:
        orig_regs.extend([prefix + str(i) for i in [0,4,5,6,19,20,7,8,29,30,1,2,3]])
        shadow_regs.extend([prefix + str(i) for i in [23,10,11,22,12,13,14,16,17,18,24,15,9]])
    for i in range(len(new_s)):
        for j in range(len(orig_regs)):
            if orig_regs[j] in new_s[i] and not "0" + orig_regs[j] in new_s[i]:
                new_s[i] = new_s[i].replace(orig_regs[j], shadow_regs[j])
                break
    return ",".join(new_s)

with open(args.inFilename,'r') as f:
    numLines = 0
    buffer = []
    for line in f:
        if numLines < 3:
            numLines += 1
            buffer.append(line.replace("\n",""))
        else:
            buffer[0] = buffer[1]
            buffer[1] = buffer[2]
            buffer[2] = line.replace("\n","")
        if buffer[0] == "// BB#1:" and buffer[1] == "\tsub\t x25, x25, x25" and ".Lfunc_end" in buffer[2]:
            # Found a block that the label was removed, adding back in
            funcID = buffer[2][10:-1]
            buffer[0] = ".LBB" + funcID + "_1:"
        if "\tldp\t" in buffer[0] and buffer[0].split()[1] == buffer[0].split()[2]:
            # Found ldp with the same register as destination twice
            separate_loads_imm = 0
            if buffer[0].split()[-1][0] == "#" and buffer[0].split()[-1][-1] == "]":
                separate_loads_imm = eval(buffer[0].split("#")[1].split("]")[0])
            separate_loads = ["\tldr\t" + buffer[0].split()[1] + " " + " ".join(buffer[0].split()[3:]), 
                              "\tldr\t" + buffer[0].split()[1] + " " + buffer[0].split()[3].split(",")[0].split("]")[0]+ ", #" + str(separate_loads_imm+4) + "]"]
            # Substitute with a scalar load from the first memory location
            buffer[0] = separate_loads[0]
        if len(buffer[0].split()) > 0 and buffer[0].split()[0] in ["subs", "adds", "orrs", "ands"]:
            # Found non-duplicated flag setting arithmatic
            nonFlagOp = buffer[0].split()[0][:-1]
            newRegs = substituteRegs(" ".join(buffer[0].split()[1:]))
            # Add non-flag setting version with shadow registers
            print("\t" + nonFlagOp + "\t" + newRegs)
        if buffer[0] == "\tsub\t x25, x25, x25":
            # Error handling code
            print(buffer[0])
            # Add instruction to force segmentation fault on detecting error
            buffer[0] = "\tstr\tx25, [x25]"
        print(buffer[0])
    print(buffer[1])
    print(buffer[2])
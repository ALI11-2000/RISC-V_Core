with open("disassembly.txt","r") as files:
    target = [i for i in files.readlines()]
    a = target.index("Disassembly of section .text:\n")
    for i in target[a+2:]:
        if(":\t" in i):
            print(i)
    with open("../srcs/instruction_mem.mem","w") as out:
        for i in target[a+2:]:
            if(":\t" in i):
                b = i.index(":\t")+2
                out.write(i[b:b+8]+"\n")
    
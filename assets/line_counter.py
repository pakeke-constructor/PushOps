



import os
from os.path import isfile

PATH = 'D:\PROGRAMMING\LUA\SCRIPTS\push_game'




def count(fpath):
    tot = 0
    
    if not fpath.endswith(".lua"):
        return 0
    
    with open(fpath, "r") as f:
        st = f.read()
        for line in st.split("\n"):
            if line.replace(" ",""):
                tot += 1
                
    return tot
        



def count_lines(path):
    tot = 0
    
    for fname in os.listdir(path):
        if fname.startswith("NM_"):
            # Not my code!
            continue

        if isfile(path + "/" + fname):
            tot += count(path + "/" + fname)
        else:
            # Its a folder
            tot += count_lines(path + "/" + fname)
    
    return tot
    


print("Your project has ", count_lines(PATH), "lines of code.")
    



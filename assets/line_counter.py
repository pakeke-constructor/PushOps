




import os
from os.path import isfile

PATH = 'D:\PROGRAMMING\LUA\SCRIPTS\push_game'




def count(fpath):
    tot = 0
    
    if not (fpath.endswith(".lua") or fpath.endswith(".fnl") or fpath.endswith(".glsl")):
        return 0
    
    with open(fpath, "r") as f:
        st = f.read()
        for line in st.split("\n"):
            if line.replace(" ",""):
                tot += 1
                
    return tot
        



def count_lines(path):
    tot = 0
    incl_tot = 0
    
    for fname in os.listdir(path):
        if fname.startswith("NM_"):
            # Not my code!
            # add to inclusive total.
            if isfile(path + "/" + fname):
                l = count(path + "/" + fname)
            else:
                _, l = count_lines(path + "/" + fname)
            incl_tot += l
            continue

        if isfile(path + "/" + fname):
            lines = count(path + "/" + fname)
            tot += lines
            incl_tot += lines
        else:
            # Its a folder
            tot_l, incl_l = count_lines(path + "/" + fname)
            tot += tot_l
            incl_tot += incl_l
    
    return tot, incl_tot
    

TOT, INCLUSIVE = count_lines(PATH)
print("Your project has " + str(TOT) + " lines of code that you wrote.")
print("However, there are " + str(INCLUSIVE) + " lines of code total, including other's code.")
    



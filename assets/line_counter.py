




import os
from os.path import isfile

PATH = 'D:\\PROGRAMMING\\LUA\\_SCRIPTS\\push_game'

IGNORE = ["binpack", "set", "sset", "sets"]




def count(fpath):
    tot = 0
    
    if not (fpath.endswith(".lua") or fpath.endswith(".fnl") or fpath.endswith(".glsl")):
        return 0

    if fpath==".git":
        return 0
    
    with open(fpath, "r") as f:
        st = f.read()
        for line in st.split("\n"):
            if line.replace(" ","").replace("\t",""):
                tot += 1
                
    return tot
        



def count_lines(path):
    tot = 0
    incl_tot = 0
    files = 0
    incl_files = 0
    
    for fname in os.listdir(path):
        if fname.startswith("."):
            # avoiding local git repo!
            continue

        if fname.startswith("NM_") or (fname.replace(".lua","").lower() in IGNORE):
            # Not my code!
            # add to inclusive total.
            if isfile(path + "/" + fname):
                l = count(path + "/" + fname)
                incl_files += 1
            else:
                _, ll, _, ff = count_lines(path + "/" + fname)
                incl_tot += ll
                incl_files += ff
            continue

        if isfile(path + "/" + fname):
            lines = count(path + "/" + fname)
            tot += lines
            incl_tot += lines
            files += 1
            incl_files += 1
        else:
            # Its a folder
            tot_l, incl_l, f, incl_f = count_lines(path + "/" + fname)
            
            tot += tot_l
            incl_tot += incl_l
            files += f
            incl_files += incl_f
    
    return tot, incl_tot, files, incl_files
    

TOT, INCLUSIVE, FTOT, FINCLUSIVE = count_lines(PATH)
print("\n"+("="*50))
print("\nYour project has " + str(TOT) + " lines of code that you wrote,")
print("spread across " + str(FTOT) + " of your files.\n")
print("However, there are " + str(INCLUSIVE) + " lines of code total, including other's code.")
print("All the code is spread across " + str(FINCLUSIVE) + " files.")
print("\n" + "="*50)



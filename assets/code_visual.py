




import os
from os.path import isfile

PATH = 'D:\\PROGRAMMING\\LUA\\SCRIPTS\\push_game'




def add_lines(fpath):
    tot = 0
    
    if not (fpath.endswith(".lua") or fpath.endswith(".fnl") or fpath.endswith(".glsl")):
        return 0

    if fpath==".git":
        return 0

    st = ''
    
    with open(fpath, "r") as f:
        st = f.read()
        for line in st.split("\n"):
            if line.replace(" ","").replace("\t",""):
                st += (line + "\n")

    return st
        



def add_all_lines(path):
    string = ''
    for fname in os.listdir(path):
        if fname.startswith(".") or fname.startswith("_NM"):
            continue

        pth = path + "/" + fname
        if isfile(pth):
            string += add_lines(pth)
        else:
            string += add_all_lines(pth)
            # is folder
    
    return string

with open("_NEW_LUA_VISUAL.lua", "w+") as f:
    f.write(add_all_lines(PATH))


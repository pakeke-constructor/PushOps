
'''

Packs all of my code into one lua file,
because it looks cool




'''



import os
from os.path import isfile

PATH = 'D:\\PROGRAMMING\\LUA\\SCRIPTS\\push_game'




def add_lines(fpath):
    if not (fpath.endswith(".lua") or fpath.endswith(".fnl") or fpath.endswith(".glsl")):
        return ''

    if fpath==".git":
        return ''

    st = ''
    
    with open(fpath, "r") as f:
        strr = f.read()
        for line in strr.split("\n"):
            if line.replace(" ","").replace("\t",""):
                st += (line + "\n")

    return st
        



def add_all_lines(path):
    string = ''
    for fname in os.listdir(path):
        if fname.startswith("."):
            continue

        if fname.startswith("NM_"):
            continue

        pth = path + "/" + fname
        if isfile(pth):
            string += add_lines(pth)
        else:
            string += add_all_lines(pth)
            # is folder
    return string




with open("_NM_NEW_LUA_VISUAL.lua", "w+") as f:
    f.write(add_all_lines(PATH))



'''

Packs all of my code into one lua file,
because it looks cool




'''



import os
from os.path import isfile

PATH = 'D:\\PROGRAMMING\\LUA\\SCRIPTS\\push_game'


IGNORE = ["binpack", "set", "sset", "sets"]


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

        should_cont = 0
        for ignore in IGNORE:
            if fname.replace(".lua","").lower() == ignore:
                should_cont = 1

        if should_cont:
            continue

        pth = path + "/" + fname
        if isfile(pth):
            string += add_lines(pth)
        else:
            string += add_all_lines(pth)
            # is folder
    return string


START_NOTE = '''


--[[


Hello, reader

This file is to visualize the scale of my project.
It consists of all the lua files that I am responsible for
making throughout my project. (Other people's libraries
are not shown.)











]]



'''




with open("_NM_NEW_LUA_VISUAL.lua", "w+") as f:
    f.write(START_NOTE + add_all_lines(PATH))


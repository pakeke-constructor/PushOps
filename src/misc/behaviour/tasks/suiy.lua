

local B=require'libs.BehaviourTree'



local er_no_hp = "Entity had no HP, how were you expecting to kill it??"

local task = B.Task("suiy")
task.run=function(t,e)
    assert(e.hp, er_no_hp)
    Cyan.call("damage", e, 0xfffffffffff)
    return "n"
end



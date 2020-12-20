


(macro LET_TABLE [exp]
    `(let [tab table]
        ,exp))

(LET_TABLE
    (tab.insert _G 'hi'))


(macro LOCALIZE_IO [exp ...]
    `(do
        (local io io)
        ,exp
        ,...))


(LOCALIZE_IO
    (local f (io.open "file.txt" "w+"))
    (f:write "banana"))


(macro F_CTOR [expr1 ...]
`(fn [x y z]
    (do
        ,expr1
        ,...)))


(local cheap-distance
    (F_CTOR 
       (+ x y z)))




(macro ENT [s_expr1 ...]
`(fn [x y]
    (local EH _G.EH)
    (local e (_G.Cyan.Entity))
    (do
        ,s_expr1
        ,...)))



(ENT
(set e.k x)
(print e.k))







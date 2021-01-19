


(macro ENT [e x y quads s_expr1 ...]
    `(fn [,x ,y]
        (local ,e (Cyan.Entity))
        (local ,quads (require "libs.assets.atlas").Quads)
        (do
            ,s_expr1
            ,...)
        ,e))


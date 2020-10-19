
# FILENAMES FOR WORLDS DONT MATTER !!
## its only the `id` field that matters.

Structures are used to deliberately input special
terrain inside of generated worlds.
They are effectively transformations encoded as
strings inside of tables.
Spaces are ignored.

# ****
# ****
# TO SEE A GOOD EXAMPLE, SEE struct_default_T1.
# ****
# ****


Individual structures are encoded as tables, of the form:

```lua
--                       ^
--                       |
local _ = {--            |
    {"? ? ? ? ?",--    x -->  y
    "? ? ? ? ?",--
    "? ? ? ? ?",--
    "? ? ? ? ?",-- Match structure rule; the terrain to be matched.
    "? ? ? ? ?"}
    ,
    {"? ? ? ? ?",
    "? # ? # ?",
    "? # c # ?", -- Transform structure rule.
    "? # # # ?", -- The above terrain will be transformed into this,
    "? ? ? ? ?"} -- If the above terrain is found.
}
```

Note that the `?` acts as a wildcard, and represents any
character that is not `#`.

If the above structure is matched, it's transformation
is applied to the terrain.

Note that a structure being able to be matched
is different from a structure being applied
to the terrain; Not all structures than can
be applied will be applied.




-- Higher Tier worlds will have things like Bossfights, artefacts etc.

```
# auto_atlas
lightweight automatic sprite atlas constructor, using leafi's 2d packer.
Thanks speak & AimeJohnson for all the great help!

### Construction:

Can create as many atlases as you want, however 1 atlas is most efficient.
```lua
local new_atlas = require "atlas_path/init.lua"

local atlas = new_atlas(2000, 2000)    
-- Creates new atlas, of size 2000*2000.
--default size is 2048 * 2048
```


### Usage:
```lua
local monkey = atlas:add("sprites/animals/monkey.png")  -- Adds to atlas


function love.draw()
  
  atlas:draw( monkey, 20, 50 )   -- supports all args from lg.draw
  
  -- or, equivalently:
  love.graphics.draw( atlas.image, monkey, 20, 50 )

end
```
And thats it!
That is everything you need to know.




# Optional ease-of-use
Here are some optional tricks that may come in handy:
```lua
local atlas = new_atlas(2000, 2000)    



--  Set default path to get sprites from:
atlas.path = "sprites/animals/"


--   Set default table to add new sprites to:
local quads = {}
atlas.default = quads
--   This will add the quad to the table automatically, with the name as the key.


-- Set default filetype:
atlas.type = "png"


atlas:add("monkey")  -- Gets:   sprites/animals/monkey.png


quads["monkey"] --> Access to monkey sprite! (remember that we used atlas.default)


```

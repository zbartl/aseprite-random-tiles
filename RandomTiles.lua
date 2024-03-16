-- controls the weight of transparent to non-transparent tiles
local transparency_bias = 0.9 

-- guards, setup
local lay = app.activeLayer
if not lay.isTilemap then return app.alert("No active timemap layer") end
local tileset = lay.tileset
local grid = tileset.grid
local size = grid.tileSize

local spr = app.activeSprite
if not spr then return app.alert("No active sprite") end
local template = spr.spec

local cel = app.activeCel
if not cel then return app.alert("No active image") end
local img = cel.image:clone()
if img.colorMode ~= ColorMode.TILEMAP then return app.alert("Active image not in TILEMAP color mode") end

-- use the active sprite's spec and adjust for the grid size of the tileset
local spec = img.spec
spec.width = math.ceil(template.width / size.width)
spec.height = math.ceil(template.height / size.height)
local generated = Image(spec)
generated:drawImage(img)

math.randomseed(os.time())

function randomFloat(lower, greater)
    return lower + math.random() * (greater - lower);
end

-- generate random tiles for the full area of the sprite
for it in generated:pixels() do
  if randomFloat(0.0, 1.0) > transparency_bias then
    local c = math.random(#tileset)-1
    it(c) -- set to random tile
  else
    it(0) -- set to transparent
  end
end

-- this generates one undoable action
cel.image = generated

-- redraw the screen to show the modified pixels
app.refresh()

# AStarHexGrid2D
Custom class implementation of AStar2D for hexagonal grids in the Godot game engine.
Minimum setup and supports both horizontal and vertical offset, different tilemap layers and setting specific tiles as obstacles/solid points.

![AStarHexGrid2D](https://github.com/OmarQurashi868/a-star-hex-grid-2d/assets/96021536/49f3e314-5f54-4e63-a6f0-469ba06043ce)

The way that 2D grids count coordinates for hexagonal grids causes some issues because hexagonal grids have 6 neighbors instead of 4, which means that if you connect the points that a normal grid needs you'd have 2 disconnected points left. But at the same time if you enable all 4 diagonals you'll get 2 extra points that break the pattern. 

The 2 disconnected points that need to be connected to the center hexagonal cell switch directions every row (or column for vertical offset). For even row numbers the 2 missing points are top-left and bottom-left, but for odd row numbers it's top-right and bottom-right. For vertical offset grids it's swapped around, for even column numbers the missing points are top-left and top-right, but for odd it's bottom-left and bottom-right.

I have basically added a function that connects a point to its neighboring 6 points using the logic above that's called for each (non-solid) point.

# Usage

## Setting up the grid & getting paths

1. Download the class .gd file and place anywhere inside your Godot project.
2. Instance the class in a script where you have a reference to your TileMap.
```gdscript
@onready var tile_map: TileMap = $TileMap
var tile_layer: int = 0
var astar_hex: AStarHexGrid2D

func _ready():
	astar_hex = AStarHexGrid2D.new()
```
3. Call the `setup_hex_grid()` function passing the TileMap and layer as a parameters.
```gdscript
astar_hex.setup_hex_grid(tile_map, tile_layer)
```
4. Your grid is set up now, to get the path from one point to another you'll need to get the map coordinates of the points using the function built into TileMap `tile_map.local_to_map(point)`.
```gdscript
var from_point = tile_map.local_to_map(player.position)
var to_point = tile_map.local_to_map(get_global_mouse_position())
```
5. Then you just call the function `get_path()` passing in the map coordinates of the `from` and `to` points which returns a PackedVector2Array containing the path from `from_point` to `to_point` in game (not map) coordinates.
```gdscript
var path = astar_hex.get_path(from_point, to_point)
```

## Setting tiles as obstacles/solid
To set a specific tile in the tile set as solid/obstacle (i.e. the pathfinder can't navigate through it) you need to add a custom data layer bool named "solid" in the tile set and enable it for the solid tiles in the tile set.

![image](https://github.com/OmarQurashi868/a-star-hex-grid-2d/assets/96021536/43c84f83-8f62-4bee-94f2-d2722c9a41b8)
![image](https://github.com/OmarQurashi868/a-star-hex-grid-2d/assets/96021536/aaf30572-c8be-433c-afbc-f7b75dbf465a)

# Docs
## Properties (you shouldn't need to touch any of these)
### _PackedVector2Array_ points_arr
An array containing all the points in the pathfinding grid stored as Vector2's of the map coordinates where the index is the point id in the grid.

### _TileMap_ tile_map
The TileMap assigned for the pathfinding grid.

## Methods
### _void_ setup_hex_grid ( _TileMap_ passed_tile_map, _int_ passed_tile_layer )
Assigns `tile_map` to the `passed_tile_map` and loops over all the used cells in the passed layer in the tile map adding them to the pathfinding grid (if they are not solid) using `add_hex_point()` and connecting it to its neighbors using `connect_hex_point()`.

### _void_ add_hex_point ( _Vector2i_ cell )
Adds the passed cell to the pathfinding grid and appends it to `points_arr`.

### _void_ connect_hex_point ( _Vector2i_ cell )
Connects all 6 neighboring cells to the passed center cell in map coordinates in the pathfinding grid to enable pathfinding between them freely. It uses a simple even/odd logic to decide whether to add the top-left and bottom-left cells or the top-right and bottom-right cells respectively (for horizontal offset, vertical offset uses top-right and top_left vs bottom_right and bottom_left).
This function is called automatically in the class for every non-solid point.

### _int_ coords_to_id ( _Vector2i_ coords )
Returns the point id (also the index in `points_arr`) of the cell with the given map coordinates.

### _PackedVector2Array_ get_path ( _Vector2i_ from_point, _Vector2i_ to_point )
Returns the pathfound path from `from_point` to `to_point` as a PackedVector2Array of game (not map) coordinates where the first element is the first step and the last element is the target at `to_point` (automatically gets the id's for the points).

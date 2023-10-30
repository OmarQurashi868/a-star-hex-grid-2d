# AStarHexGrid2D
Custom class implementation of AStar2D for hexagonal grids in the Godot game engine.
Minimum setup and supports both horizontal and vertical offset.
Currently only supports setting the whole map as walkable but shouldn't be too hard to implement a layer-based system or something similar (right?)

![AStarHexGrid2D](https://github.com/OmarQurashi868/a-star-hex-grid-2d/assets/96021536/49f3e314-5f54-4e63-a6f0-469ba06043ce)
# Usage
1. Download the class .gd file and place anywhere inside your Godot project.
2. Instance the class in a script where you have a reference to your TileMap.
```gdscript
@onready var tile_map: TileMap = $TileMap
var astar_hex: AStarHexGrid2D

func _ready():
	astar_hex = AStarHexGrid2D.new()
```
3. Call the `setup_hex_grid()` function passing the TileMap as a parameter.
```gdscript
astar_hex.setup_hex_grid(tile_map)
```
4. Your grid is set up now, to get the path from one point to another you'll first need to get the id's of the points using the function `coords_to_id` which takes a Vector2i (map coordinates of the cell) and returns the point id for the AStar2D class.
```gdscript
var from = tilemap.local_to_map(player.position)
var to = tilemap.local_to_map(get_global_mouse_position())

var from_id = astar_hex.coords_to_id(from)
var to_id = astar_hex.coords_to_id(to)
```
5. Then you just call the function `get_point_path()` passing in the id's of the `from` and `to` points which returns a PackedVector2Array containing the cell path from the `from` point to the `to` point in map coordinates.
```gdscript
var path = astar_hex.get_point_path(from_id, to_id)
```
# Docs
## Properties
### PackedVector2Array points_dict
An array containing all the points in the pathfinding grid stored as a Vector2i of the map coordinates where the index is the point id in the grid.

### TileMap tile_map
The TileMap assigned for the pathfinding grid.

## Methods
### void setup_hex_grid ( TileMap passed_tile_map )
Assigns `tile_map` to the `passed_tile_map` and loops over all the used cells in the tile map adding them to the pathfinding grid and connecting it to its neighbors using `connect_point()`.

### void connect_point (int x, int y)
Connects all 6 neighboring cells to the center cell at (x, y) in map coordinates in the pathfinding grid to enable pathfinding between them freely. This function is called automatically in the class.

### int coords_to_id (Vector2i coords)
Returns the point id (also the index in `points_dict`) of the cell with the given map coordinates.

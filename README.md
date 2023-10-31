# AStarHexGrid2D
Custom class implementation of AStar2D for hexagonal grids in the Godot game engine.
Minimum setup and supports both horizontal and vertical offset, different tilemap layers and setting specific tiles as obstacles/solid points.

![AStarHexGrid2D](https://github.com/OmarQurashi868/a-star-hex-grid-2d/assets/96021536/49f3e314-5f54-4e63-a6f0-469ba06043ce)

The way that 2D grids count coordinates for hexagonal grids causes some issues because hexagonal grids have 6 neighbors instead of 4, which means that if you connect the points that a normal grid needs you'd have 2 disconnected points left. But at the same time if you enable all 4 diagonals you'll get 2 extra points that break the pattern. 

The 2 disconnected points that need to be connected to the center hexagonal cell switch directions every row (or column for vertical offset). For even row numbers the 2 missing points are top-left and bottom-left, but for odd row numbers it's top-right and bottom-right. For vertical offset grids it's swapped around, for even column numbers the missing points are top-left and top-right, but for odd it's bottom-left and bottom-right.

I have basically added a function that connects a point to its neighboring 6 points using the logic above that's called for each (non-solid) point.

# Usage
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

## Setting tiles as obstacles/solid
To set a specific tile in the tile set as solid/obstacle (i.e. the pathfinder navigate through it) you need to add a custom data layer bool named "solid" and enable it for the solid tiles in the tile set

![image](https://github.com/OmarQurashi868/a-star-hex-grid-2d/assets/96021536/43c84f83-8f62-4bee-94f2-d2722c9a41b8)
![image](https://github.com/OmarQurashi868/a-star-hex-grid-2d/assets/96021536/aaf30572-c8be-433c-afbc-f7b75dbf465a)

# Docs
## Properties (you shouldn't need to touch any of these)
### PackedVector2Array points_dict
An array containing all the points in the pathfinding grid stored as a Vector2i of the map coordinates where the index is the point id in the grid.

### TileMap tile_map
The TileMap assigned for the pathfinding grid.

## Methods
### void setup_hex_grid ( TileMap passed_tile_map, int passed_tile_layer )
Assigns `tile_map` to the `passed_tile_map` and loops over all the used cells in the passed layer in the tile map adding them to the pathfinding grid (if they are not solid) and connecting it to its neighbors using `connect_point()`.

### void connect_point (int x, int y)
Connects all 6 neighboring cells to the center cell at (x, y) in map coordinates in the pathfinding grid to enable pathfinding between them freely. It uses a simple even/odd logic to decide whether to add the top-left and bottom-left cells or the top-right and bottom-right cells respectively (for horizontal offset, vertical offset uses top-right and top_left vs bottom_right and bottom_left).
This function is called automatically in the class for every non-solid point.

### int coords_to_id (Vector2i coords)
Returns the point id (also the index in `points_dict`) of the cell with the given map coordinates.

extends Node2D

@onready var tile_map: TileMap = $TileMap
@onready var player = $Player
var astar_hex: AStarHexGrid2D


# Called when the node enters the scene tree for the first time.
func _ready():
	astar_hex = AStarHexGrid2D.new()
	astar_hex.setup_hex_grid(tile_map)


func get_nav(from: Vector2, to: Vector2) -> PackedVector2Array:
	var from_map = tile_map.local_to_map(from)
	var to_map = tile_map.local_to_map(to)
	
	var from_id = astar_hex.coords_to_id(from_map)
	var to_id = astar_hex.coords_to_id(to_map)
	
	var path = astar_hex.get_point_path(from_id, to_id)
	return path

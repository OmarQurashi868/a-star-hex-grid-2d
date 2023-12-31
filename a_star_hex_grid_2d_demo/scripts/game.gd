extends Node2D

@onready var tile_map: TileMap = $TileMap
@onready var player = $Player
var astar_hex: AStarHexGrid2D


# Called when the node enters the scene tree for the first time.
func _ready():
	astar_hex = AStarHexGrid2D.new()
	astar_hex.setup_hex_grid(tile_map, 0)


func get_nav(from: Vector2, to: Vector2) -> PackedVector2Array:
	var from_point = tile_map.local_to_map(from)
	var to_point = tile_map.local_to_map(to)
	
	var path = astar_hex.get_path(from_point, to_point)
	return path

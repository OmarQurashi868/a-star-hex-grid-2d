extends CharacterBody2D

@onready var game: Node2D = $".."
@onready var tile_map: TileMap = $"../TileMap"
var path: Array = []
var is_moving: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = tile_map.map_to_local(Vector2i.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not path.is_empty():
		path = Array(path)
		set_line2d_points()
		
		is_moving = true
		global_position = global_position.move_toward(path.front(), 5)
		
		if position == path.front():
			is_moving = false
			path.pop_front()
	
	move_and_slide()


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 2 and event.is_pressed():
			var start_pos: Vector2 = global_position
			var target_pos: Vector2 = get_global_mouse_position()
			
			if is_moving:
				start_pos = path.front()
			
			request_nav(start_pos, target_pos)


func request_nav(from: Vector2, to: Vector2) -> void:
	var nav_path = game.get_nav(from, to)
	set_path(nav_path)


func set_path(target_pos: PackedVector2Array) -> void:
	if path.is_empty():
		path = Array(target_pos)
	else:
		path = [path.front()]
		path.append_array(Array(target_pos))


func set_line2d_points() -> void:
	$"../Line2D".clear_points()
	$"../Line2D".add_point(global_position)
	for point in path:
		$"../Line2D".add_point(point)

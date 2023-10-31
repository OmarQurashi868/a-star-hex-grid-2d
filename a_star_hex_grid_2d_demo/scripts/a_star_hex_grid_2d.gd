extends AStar2D
class_name AStarHexGrid2D

var points_dict: PackedVector2Array = []
var tile_map: TileMap


# Setup the tilemap for pathfinding
func setup_hex_grid(passed_tile_map: TileMap, passed_layer: int) -> void:
	tile_map = passed_tile_map
	var used_cells = tile_map.get_used_cells(passed_layer)
	for cell in used_cells:
		var current_id = points_dict.size()
		
		var solid_data_layer = tile_map.tile_set.get_custom_data_layer_by_name("solid")
		var tile_data = tile_map.get_cell_tile_data(passed_layer, cell)
		var is_tile_solid = tile_data.get_custom_data_by_layer_id(solid_data_layer)
		
		if not is_tile_solid:
			add_point(current_id, tile_map.map_to_local(cell))
			points_dict.append(cell)
			connect_point(cell.x, cell.y)


# Connect a point with all 6 neighboring cells
func connect_point(x: int, y:int) -> void:
	var center = points_dict.find(Vector2(x, y))
	
	var top = points_dict.find(Vector2(x, y - 1))
	var right = points_dict.find(Vector2(x + 1, y))
	var bottom = points_dict.find(Vector2(x, y + 1))
	var left = points_dict.find(Vector2(x - 1, y))
	
	var top_right = points_dict.find(Vector2(x + 1, y - 1))
	var top_left = points_dict.find(Vector2(x - 1, y - 1))
	var bottom_right = points_dict.find(Vector2(x + 1, y + 1))
	var bottom_left = points_dict.find(Vector2(x - 1, y + 1))
	
	if has_point(top):
		connect_points(center, top)
	if has_point(right):
		connect_points(center, right)
	if has_point(bottom):
		connect_points(center, bottom)
	if has_point(left):
		connect_points(center, left)
	
	if tile_map.tile_set.tile_offset_axis == tile_map.tile_set.TILE_OFFSET_AXIS_HORIZONTAL:
		if y % 2 == 0:
			if has_point(top_left):
				connect_points(center, top_left)
			if has_point(bottom_left):
				connect_points(center, bottom_left)
		else:
			if has_point(top_right):
				connect_points(center, top_right)
			if has_point(bottom_right):
				connect_points(center, bottom_right)
	else:
		if x % 2 == 0:
			if has_point(top_right):
				connect_points(center, top_right)
			if has_point(top_left):
				connect_points(center, top_left)
		else:
			if has_point(bottom_right):
				connect_points(center, bottom_right)
			if has_point(bottom_left):
				connect_points(center, bottom_left)


# Returns the id of a cell
func coords_to_id(coords: Vector2i) -> int:
	return points_dict.find(coords)

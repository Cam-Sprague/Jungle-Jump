extends Node2D

var _items: TileMapLayer = null
var _world: TileMapLayer = null

var _player: Node2D = null
var _spawn_point: Marker2D = null
var _camera_2d: Camera2D = null

signal score_changed

var item_scene: PackedScene = load("res://item/item.tscn")

var score: int: set = set_score

func _ready():
	get_items().hide()
	get_player().reset(get_spawn_point().position)
	set_camera_limits()
	spawn_items()
	
func get_items() -> TileMapLayer:
	if _items == null:
		if $TML_Items:
			_items = $TML_Items
		else:
			push_error("Node 'TML_Items' not found")
	return _items
	
func get_world() -> TileMapLayer:
	if _world == null:
		if $TML_World:
			_world = $TML_World
		else:
			push_error("Node 'TML_World' not found")
	return _world
	
func get_player() -> Node2D:
	if _player == null:
		if $Player:
			_player = $Player
		else:
			push_error("Node 'Player' not found")
	return _player

func get_spawn_point() -> Marker2D:
	if _spawn_point == null:
		if $SpawnPoint:
			_spawn_point = $SpawnPoint
		else:
			push_error("Node 'SpawnPoint' not found")
			
	return _spawn_point
	
func get_camera_2d() -> Camera2D:
	if _camera_2d == null:
		var player = get_player()
		if player.has_node("Camera2D"):
			_camera_2d = player.get_node("Camera2D") as Camera2D
		else:
			push_error("Node 'Camera2D' not found as a child of 'Player'")
	return _camera_2d
	
func set_camera_limits() -> void:
	var map_size: Rect2 = get_world().get_used_rect()
	var cell_size: Vector2 = get_world().tile_set.tile_size
	
	get_camera_2d().limit_left = int((map_size.position.x-5) * cell_size.x)
	get_camera_2d().limit_right = int((map_size.end.x + 5) * cell_size.x)
	
func spawn_items() -> void:
	var item_cells: Array[Vector2i] = get_items().get_used_cells()
	
	for cell in item_cells:
		var data: TileData = get_items().get_cell_tile_data(cell)
		var type: String = data.get_custom_data("type")
		var item: Node = item_scene.instantiate()
		add_child(item)
		item.init(type, get_items().map_to_local(cell))
		item.picked_up.connect(self._on_item_picked_up)
		
func _on_item_picked_up() -> void:
	score += 1
	
func set_score(value: int) -> void:
	score = value
	score_changed.emit(score)


func _on_player_died() -> void:
	GameState.restart()

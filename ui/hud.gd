extends MarginContainer

var _life_counter: Array[Node] = []
var _score_label: Label = null

func get_life_counter() -> Array[Node]:
	if _life_counter.is_empty():
		var life_counter_node: HBoxContainer = $HBoxContainer/LifeCounter
		_life_counter = life_counter_node.get_children() as Array[Node]
	return _life_counter
	
func get_score_label() -> Label:
	if _score_label == null:
		_score_label = $HBoxContainer/Score as Label
	return _score_label
	
func update_life(value: int) -> void:
	for heart in range(get_life_counter().size()):
		get_life_counter()[heart].visible = value > heart
		
func update_score(value: int) -> void:
	get_score_label().text = str(value)

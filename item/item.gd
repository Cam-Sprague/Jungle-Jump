extends Area2D

signal picked_up

var textures: Dictionary = {
	"cherry": "res://jungle_jump_assets/sprites/cherry.png",
	"gems": "res://jungle_jump_assets/sprites/gem.png"
}

func init(item_type: String, _position:Vector2):
	$Sprite2D.textures = load(textures[item_type]) as Texture
	position = _position
	


func _on_body_entered(body: Node2D):
	picked_up.emit()
	queue_free()

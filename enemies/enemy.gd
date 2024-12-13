extends CharacterBody2D

@export var speed: float = 50
@export var gravity: float = 900

var facing: int = 1

var _sprite: Sprite2D = null
var _animation_player: AnimationPlayer = null
var _collision_shape: CollisionShape2D = null
	
func get_animation_player() -> AnimationPlayer:
	if _animation_player == null:
		_animation_player = $AnimationPlayer
	return _animation_player

func get_collision_shape() -> CollisionShape2D:
	if _collision_shape == null:
		_collision_shape = $CollisionShape2D
	return _collision_shape
	
func get_sprite() -> Sprite2D:
	if _sprite == null:
		_sprite = $Sprite2D
	return _sprite
	
func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.x = facing * speed
	get_sprite().flip_h = velocity.x > 0
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider: Node = collision.get_collider() as Node
		
		if collider.name == "Player":
			collider.hurt()
			
		if collision.get_normal().x != 0:
			facing = sign(collision.get_normal().x)
			velocity.y = -100
			
	if position.y > 10000:
		queue_free()
		
func take_damage() -> void:
	get_animation_player().play("death")
	$HitSound.play()
	get_collision_shape().set_deferred("disabled", true)
	set_physics_process(false)
	
func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "death":
		queue_free()

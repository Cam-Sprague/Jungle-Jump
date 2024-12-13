extends CharacterBody2D

signal life_changed(life: int)
signal died

@export var life: int = 3:
	set(value):
		life = value
		life_changed.emit(life)
		if life <= 0:
			change_state(DEAD)

@export var gravity: float = 750
@export var run_speed: float = 150
@export var jump_speed: float = -300

enum {IDLE, RUN, JUMP, HURT, DEAD}
var state: int = IDLE

func _ready():
	change_state(IDLE)
	
func change_state(new_state: int):
	state = new_state
	match state:
		IDLE:
			$AnimationPlayer.play("idle")
		RUN:
			$AnimationPlayer.play("run")
		HURT:
			$AnimationPlayer.play("hurt")
			velocity.y = -200
			velocity.x = -100 * sign(velocity.x)
			
			await get_tree().create_timer(0.5).timeout
			
			life -= 1
			if life > 0:
				change_state(IDLE)
			else:
				change_state(DEAD)
		JUMP:
			$AnimationPlayer.play("jump_up")
		DEAD:
			died.emit()
			hide()


func get_input():
	var right: bool = Input.is_action_pressed("right")
	var left: bool = Input.is_action_pressed("left")
	if state == HURT:
		return
	var jump: bool = Input.is_action_just_pressed("jump")
	
	velocity.x = 0
	if right:
		velocity.x += run_speed
		$Sprite2D.flip_h = false
	if left:
		velocity.x -= run_speed
		$Sprite2D.flip_h = true
	if jump and is_on_floor():
		change_state(JUMP)
		velocity.y = jump_speed
		
	if state == IDLE and velocity.x !=0:
		change_state(RUN)
		
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
		
	if state in [IDLE, RUN] and !is_on_floor():
		change_state(JUMP)
		
func _physics_process(delta: float):
	velocity.y += gravity * delta
	#Process user input
	get_input()
	#Update the player
	move_and_slide()
	
	if state == HURT:
		return
		
	for i in range(get_slide_collision_count()):
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider: Object = collision.get_collider()
		if collider.is_in_group("danger"):
			hurt()
		
		if collider.is_in_group("enemies"):
			if position.y < collider.position.y:
				collider.take_damage()
				velocity.y = -200
			else:
				hurt()
	
	if state == JUMP and is_on_floor():
		change_state(IDLE)
		
	if state == JUMP and velocity.y > 0:
		$AnimationPlayer.play("jump_down")
		
func reset(_position: Vector2):
	position = _position
	show()
	change_state(IDLE)
	life = 3
	
func hurt():
	if state != HURT:
		change_state(HURT)
		

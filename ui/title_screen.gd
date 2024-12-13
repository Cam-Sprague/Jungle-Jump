extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		$IntroMusic.stop()
		GameState.next_level()

func _ready() -> void:
	$IntroMusic.play()

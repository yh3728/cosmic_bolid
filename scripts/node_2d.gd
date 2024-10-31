extends Node2D
var scores = 0
var screen_size
const DumpShipPath = preload("res://scenes/dumb_ship.tscn")

func  _ready():
	screen_size = get_viewport_rect().size

func chose_random_place():
	var x = randi_range(900, 1180)
	var y = randi_range(48, 680)
	return Vector2(x, y)

func chose_random_spawn_place():
	var x = 1340
	var y = randi_range(48, 680)
	return Vector2(x, y)

func from_start():
	$UI.init_lives($main_character.hp)
	if $main_character.hp != 3:
		$damage.play()
	$main_character.is_dead = false
	$main_character.show()
	$main_character.start($StartPosition.global_position)
	$StartTimer.start(1)
	$SpawnTimer.start(1)

func restart():
	scores = 0
	$UI.update_score(scores)
	$game_over.stop()
	$start_button.play()
	$bg_music.play()
	$main_character.can_shoot = true
	$main_character.is_dead = false
	$main_character.hp = 3
	from_start()

func game_over():
	$bg_music.stop()
	$game_over.play()
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	$SpawnTimer.stop()
	$UI/GameOverLabel.show()
	$UI/ExitButton.show()
	$UI/StartButton.show()
	
func _on_start_timer_timeout():
	$main_character.make_vulnerable()
	$StartTimer.stop()

func enemy_dead(score):
	$kill.play()
	scores += score
	$UI.update_score(scores)

func _on_spawn_timer_timeout():
	if get_tree().get_nodes_in_group("enemies").size() < 10:
		var enemy = DumpShipPath.instantiate()
		add_child(enemy)
		var location = chose_random_spawn_place()
		enemy.position = location
		var rand_pos = chose_random_place()
		enemy.move_to(rand_pos)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

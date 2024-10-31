extends CanvasLayer
signal start_game

var lifePath = preload("res://scenes/life.tscn")

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed():
	$StartButton.hide()
	$ExitButton.hide()
	$GameOverLabel.hide()
	$StartLabel.hide()
	start_game.emit()

func init_lives(amount):
	for life in $HBoxContainer.get_children():
		life.queue_free()
	for i in amount:
		var life = lifePath.instantiate()
		$HBoxContainer.add_child(life)


func _on_exit_button_pressed():
	get_parent().get_tree().quit()

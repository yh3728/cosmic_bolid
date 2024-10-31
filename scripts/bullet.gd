extends Area2D
class_name bullet
const SPEED = 600
var power = 5
var is_players = false

func _physics_process(delta):
	if is_players:
		position.x += delta*SPEED
	else:
		position.x -= delta*SPEED

func _on_area_entered(area):
	if area is Player:
		$Sprite2D.visible = false
		queue_free()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

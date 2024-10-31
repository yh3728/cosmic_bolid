extends CharacterBody2D
class_name Enemy

var speed
var health
var score
var shoot_delay
const bulletPath = preload("res://scenes/bullet.tscn")
signal enemy_dead
var pos
var is_moving = true

func chose_random_place():
	var x = randi_range(900, 1180)
	var y = randi_range(0, 720)
	return Vector2(x, y)

func _physics_process(delta):
	position = position.move_toward(pos, delta*speed)
	if pos == position:
		pos = chose_random_place()
	move_and_slide()
	
func take_damage(area):
	if area is bullet and area.is_players == true:
		health -= area.power
		if health <= 0:
			$AnimatedSprite2D.visible = false
			enemy_dead.emit(score)
			queue_free()

func shoot():
	var bullet = bulletPath.instantiate()
	get_parent().add_child(bullet)
	bullet.position = $Marker2D.global_position

func move_to(posit):
	pos = posit

extends CharacterBody2D
class_name Player

@export var speed = 800
var health = 10
var hp = 3
var screen_size
var shoot_delay = 0.1
var can_shoot = false
const bulletPath = preload("res://scenes/bullet.tscn")
signal dead
signal hp_ended
var is_dead = false

func start(pos):
	position = pos
	show()
	$AnimatedSprite2D.play("ship_invulnerability")

func get_axis():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")	
	velocity = input_direction.normalized() * speed

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(_delta):
	if Input.is_action_pressed("ui_accept") and can_shoot:
		shoot()
	get_axis()
	move_and_slide()
	position = position.clamp(Vector2.ZERO + Vector2(50, 50), screen_size - Vector2(50, 50))

func shoot():
	if not is_dead:
		var bullet = bulletPath.instantiate()
		bullet.is_players = true
		get_parent().add_child(bullet)
		bullet.position = $Marker2D.global_position
	can_shoot = false
	$ShootTimer.start(shoot_delay)

func _on_ShootTimer_timeout():
	can_shoot = true
	$ShootTimer.stop()
	
func die():
	can_shoot = false
	is_dead = true
	$Area2D/CollisionPolygon2D.set_deferred(&"disabled", true)
	hide()
	hp -= 1
	if hp<0:
		hp_ended.emit()
	else:
		dead.emit()
	
func _on_area_2d_area_entered(area):
	if area is bullet and area.is_players == false:
		health -= area.power
		if health<=0:
			die()

func _on_area_2d_body_entered(body):
	if body is Enemy:
		die()

func make_vulnerable():
	health = 10
	can_shoot = true
	$Area2D/CollisionPolygon2D.set_deferred(&"disabled", false)
	$AnimatedSprite2D.play("ship")

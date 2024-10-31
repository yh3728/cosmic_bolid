extends Enemy

var can_shoot

func _ready():
	health = 5
	shoot_delay = 0.4
	can_shoot = true
	score = 10
	speed = 300
	enemy_dead.connect(get_parent().enemy_dead)
	
func _process(_delta):
	if can_shoot:
		super.shoot()
		can_shoot = false
		$ShootTimer.start(shoot_delay)
		
func _on_area_2d_area_entered(area):
	super.take_damage(area)

func _on_shoot_timer_timeout():
	can_shoot = true

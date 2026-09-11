extends CharacterBody2D
var health = 50
var speed = 15
var player_chase = false
var player = null
var initial_position = Vector2()
var min_distance = 50  # минимальное расстояние до игрока
var player_inattack_zone = false
#Как же меня уже это задолбало...

func _ready():
	initial_position = position

func _physics_process(_delta):
	
	deal_with_damage()
	
	$AnimatedSprite2D.play("Fly")
	if player_chase:
		var distance = player.position.distance_to(position)
		if distance > min_distance:
			position += (player.position - position)/speed
			if (player.position.x - position.x) < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
			
	else:
		position += (initial_position - position)/speed

func _on_detection_area_body_entered(body):
	if body.name == "Player":
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body.name == "Player":
		player = null
		player_chase = false
	
func enemy():
	pass



func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true

func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone and Global.player_current_attack == true:
		health = health - 20
		print(health)
		if health <= 0:
			self.queue_free()
 

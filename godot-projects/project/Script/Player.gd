extends CharacterBody2D
var movement_animation
var attack_ip = false
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var speed = 400 # Скорость игрока (пиксели/сек).
var health = 100 # Здоровье игрока.
var is_dead = false
var screen_size # Размер игрового окна.
var wait
var idle = true
var walk = false
var run = false
func _ready():
	$AudioStreamPlayer2D.play()
	screen_size = get_viewport_rect().size

func _process(_delta):
	var velocity = Vector2.ZERO # Вектор движения игрока.
	var current_speed = speed
	var is_running = false
	attack()
	enemy_attack()

	if health > 0:
		if Input.is_action_pressed("Attack"):
			idle = false
			$AnimatedSprite2D.play("Attack")
		if Input.is_action_pressed("Shift"):
			is_running = true
			current_speed *= 2
		if Input.is_action_pressed("Right"):
			velocity.x += 1
			$AnimatedSprite2D.flip_h = false
		if Input.is_action_pressed("Left"):
			velocity.x -= 1
			$AnimatedSprite2D.flip_h = true
		if Input.is_action_pressed("Down"):
			velocity.y += 1
		if Input.is_action_pressed("Up"):
			velocity.y -= 1

		if velocity.length() > 0:
			velocity = velocity.normalized() * current_speed
			if is_running:
				run = true
				player_run()
			else:
				walk = true
				player_walk()
		else:
			player_idle()
	elif health <= 0:
		health = 0
		if not is_dead:
			$AnimatedSprite2D.play("Death2")
			is_dead = true
			velocity = Vector2.ZERO
			self.queue_free()

	move_and_slide()
	position += velocity * _delta
	
func play_music():
	$Music.play()

func player():
	pass
func player_idle():
	if idle == true:
		$AnimatedSprite2D.play("Idle")
func player_walk():
	if walk == true:
		$AnimatedSprite2D.play("Walk")
func player_run():
	if run == true:
		$AnimatedSprite2D.play("Run")

func _on_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	if Input.is_action_just_pressed("Attack"):
		walk = false
		run = false
		print("wat")
		Global.player_current_attack = true
		if Global.player_current_attack == true:
			print("attack going")
		attack_ip = true
		$deal_attack_timer.start()
		
		

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	if Global.player_current_attack == false:
		print("attack not going")
	attack_ip = false


func _on_animated_sprite_2d_animation_finished():
	idle = true
	

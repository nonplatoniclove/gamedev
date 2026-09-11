extends Node
var player_current_attack = false

var current_scene = "Corridor"
var transition_scene = false

var player_exit_cliffside_posx = 0
var player_exit_cliffside_posy = 0
var player_start_posx = 0
var player_start_posy = 0

func _process(delta):
	change_scene()
func _on_transition_point_body_entered(body):
	if body.has_method("player"):
		transition_scene = true
		print("oof")
		

func _on_transition_point_body_exited(body):
	if body.has_method("player"):
		transition_scene = false
		print("nooo")
func finish_changescenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "Corridor":
			current_scene = "World"
func change_scene():
	if transition_scene == true:
		if current_scene == "Corridor":
			get_tree().change_scene_to_file("res://World/World.tscn")
			finish_changescenes()

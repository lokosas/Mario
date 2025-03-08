extends Control


@export var ScenePath = ""



func _on_play_button_down():
	get_tree().change_scene_to_file(ScenePath)




func _on_quit_button_down():
	get_tree().quit()

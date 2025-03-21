extends Node2D


func _process(delta):
	$Camera2D.position.x = $Marsian_Player.position.x
	$GPUParticles2D.position.x = $Marsian_Player.position.x

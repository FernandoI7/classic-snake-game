extends Node2D

signal eaten

func _ready():
	randomize_position()

func randomize_position():
	var grid_size = 64
	var offset = 32

	# Obter o tamanho real da janela
	var screen_size = get_viewport().get_visible_rect().size
	print("Screen Size: ", screen_size)  # Depuração para verificar o tamanho da tela

	var max_x = int((screen_size.x - offset) / grid_size)
	var max_y = int((screen_size.y - offset) / grid_size)
	print("Max X: ", max_x, " Max Y: ", max_y)  # Depuração para os limites máximos

	var snake_head = get_parent().get_node("SnakeHead")

	var valid_position = false
	var new_pos = Vector2()  # Declara new_pos fora do loop

	while not valid_position:
		var random_x = randi() % max_x
		var random_y = randi() % max_y
		new_pos = Vector2(random_x * grid_size + offset, random_y * grid_size + offset)
		print("Tentativa de nova posição: ", new_pos)  # Depuração para nova posição
		
		valid_position = true
		if new_pos == snake_head.position:
			valid_position = false
		for segment in snake_head.body_segments:
			if new_pos == segment.position:
				valid_position = false
				break
		
	position = new_pos
	print("Posição final da comida: ", position)  # Depuração para posição final

func _on_area_2d_body_entered(body):
	if body.name == "SnakeHead":
		emit_signal("eaten")
		randomize_position()

extends CharacterBody2D

var direction = Vector2.RIGHT
var next_direction = Vector2.RIGHT 
var move_interval = 0.2
var body_segments = []
var segment_scene = preload("res://body_segment.tscn")
var positions = []

func _ready():
	var food_node = get_parent().get_node("Food")
	food_node.connect("eaten", Callable(self, "grow"))
	
	var timer = Timer.new()
	timer.wait_time = move_interval
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	add_child(timer)
	timer.start()

	set_process_input(true)

func _input(event):
	if event.is_action_pressed("move_right") and direction != Vector2.LEFT:
		next_direction = Vector2.RIGHT
	elif event.is_action_pressed("move_left") and direction != Vector2.RIGHT:
		next_direction = Vector2.LEFT
	elif event.is_action_pressed("move_up") and direction != Vector2.DOWN:
		next_direction = Vector2.UP
	elif event.is_action_pressed("move_down") and direction != Vector2.UP:
		next_direction = Vector2.DOWN

func _on_Timer_timeout():
	# Salva a posição atual da cabeça
	positions.insert(0, position)

	# Limita o tamanho do array de posições
	if positions.size() > body_segments.size() + 1:
		positions.pop_back()

	var previous_position = position
	direction = next_direction
	position += direction * 64 

	# Verifica se a cobra saiu da tela e ajusta a posição
	if position.x < 0:
		position.x = get_viewport_rect().size.x - 32
	elif position.x > get_viewport_rect().size.x:
		position.x = 32
	elif position.y < 0:
		position.y = get_viewport_rect().size.y - 32
	elif position.y > get_viewport_rect().size.y:
		position.y = 32
	
	# Verifica colisão com segmentos do corpo
	for segment in body_segments:
		if position == segment.position:
			end_game()
			return

	# Atualiza as posições dos segmentos do corpo
	if body_segments.size() > 0:
		body_segments[0].position = previous_position
		for i in range(1, body_segments.size()):
			body_segments[i].position = positions[i]

func grow():
	var new_segment = segment_scene.instantiate()
	get_parent().add_child(new_segment)  # Adiciona o novo segmento ao nó pai da cabeça da cobra

	if body_segments.size() > 0:
		new_segment.position = body_segments[-1].position
	else:
		new_segment.position = position
	
	body_segments.append(new_segment)
	print("body segments", body_segments)
	print("position", position)

func end_game():
	get_tree().change_scene_to_file("res://game_over.tscn")

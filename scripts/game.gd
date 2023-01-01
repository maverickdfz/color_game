extends Control

var well_done = preload("res://scenes/well_done.tscn")
var answer: String
@onready var audioStreamPlayer: AudioStreamPlayer = $AudioStreamPlayer
var guess_finished: Callable
var play_finished: Callable
var well_done_finished: Callable

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_answer()

func disable_buttons():
	#print("disable_buttons")
	$TextureButton.disabled = true
	var children = $HBoxContainer.get_children()
	for child in children:
		child.disabled = true

func enable_buttons():
	#print("enable_buttons")
	$TextureButton.disabled = false
	var children = $HBoxContainer.get_children()
	for child in children:
		child.disabled = false

func disconnect_finished():
	#print("disconnect_finished")
	if audioStreamPlayer.finished.is_connected(guess_finished):
		#print("disconnect guess_finished")
		audioStreamPlayer.finished.disconnect(guess_finished)
	if audioStreamPlayer.finished.is_connected(play_finished):
		#print("disconnect play_finished")
		audioStreamPlayer.finished.disconnect(play_finished)

func guess(guessed_color):
	# disable guessing
	disable_buttons()
	var sound = load("res://sounds/"+guessed_color+".wav")
	audioStreamPlayer.stream = sound
	guess_finished = func():
		#print("guess finished")
		disconnect_finished()
		if guessed_color.to_lower() == answer:
			# play fanfare sound
			sound = load("res://sounds/fanfare.ogg")
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play(0.0)
			# play well done animation
			var well_done_instance = well_done.instantiate()
			add_child(well_done_instance)
			# start timer to generate next word
			well_done_finished = func ():
				#print("well_done finished")
				if $Timer.timeout.is_connected(well_done_finished):
						$Timer.timeout.disconnect(well_done_finished)
				remove_child(well_done_instance)
				generate_answer()
				enable_buttons()
			$Timer.timeout.connect(well_done_finished)
			$Timer.start()
		else:
			enable_buttons()
	audioStreamPlayer.finished.connect(guess_finished)
	audioStreamPlayer.play(0.0)

func generate_answer():
	#print("generate_answer")
	var answers = [
		"white",
		"black",
		"red",
		"orange",
		"yellow",
		"green",
		"blue",
		"purple",
		"pink",
	]
	answer = answers[randi() % answers.size()]
	#print(answer)
	#var sound = load("res://sounds/testing.ogg")
	var sound = load("res://sounds/"+answer+".wav")
	audioStreamPlayer.stream = sound
	audioStreamPlayer.play(0.0)

func _on_texture_button_pressed():
	disable_buttons()
	var sound = load("res://sounds/"+answer+".wav")
	audioStreamPlayer.stream = sound
	play_finished = func():
		#print("play finished")
		disconnect_finished()
		enable_buttons()
	audioStreamPlayer.finished.connect(play_finished)
	audioStreamPlayer.play(0.0)

func _on_texture_button_white_pressed():
	guess("white")

func _on_texture_button_black_pressed():
	guess("black")

func _on_texture_button_red_pressed():
	guess("red")

func _on_texture_button_orange_pressed():
	guess("orange")

func _on_texture_button_yellow_pressed():
	guess("yellow")

func _on_texture_button_green_pressed():
	guess("green")

func _on_texture_button_blue_pressed():
	guess("blue")

func _on_texture_button_purple_pressed():
	guess("purple")

func _on_texture_button_pink_pressed():
	guess("pink")

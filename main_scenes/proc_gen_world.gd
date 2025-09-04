extends Node2D

@onready var tile_map: TileMap = $TileMap
var cliff_altlas = Vector2i(12,14)

@export var obstacle_noise_text : NoiseTexture2D
var obstacle_noise : Noise

@export var path_noise_text : NoiseTexture2D
var path_noise : Noise




var width : int = 300
var height : int = 300

func _ready() -> void:
	obstacle_noise = obstacle_noise_text.noise
	
	path_noise = path_noise_text.noise
	generate_world()
	
	
func generate_world():
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var noise_val = obstacle_noise.get_noise_2d(x,y)
			if noise_val >= 0.45:
				tile_map.set_cell(1, Vector2(x,y), 0, cliff_altlas)
			elif noise_val < 0.0:
				pass
				
			var path_noise_val = path_noise.get_noise_2d(x,y)
			if noise_val >= 0.0:
				tile_map.set_cell(1, Vector2(x,y), 0, cliff_altlas)
			elif noise_val < 0.0:
				pass

	
				

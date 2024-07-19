extends TileMap

@export var player : Node2D
var width : int = 30
var height : int = 30
var randomness : float = 0.0
var flower_noise := FastNoiseLite.new()
var stone_noise := FastNoiseLite.new()

func _ready():
	flower_noise.seed = randi()
	flower_noise.fractal_type = FastNoiseLite.FRACTAL_RIDGED
	flower_noise.fractal_lacunarity = 8
	flower_noise.frequency = 0.04
	stone_noise.seed = randi()
	stone_noise.fractal_type = FastNoiseLite.FRACTAL_PING_PONG
	stone_noise.fractal_lacunarity = 3
	stone_noise.frequency = 0.03
	update_chunk()

func update_chunk():
	var chunk_position = local_to_map(to_local(player.global_position))
	for x in range(width):
		for y in range(height):
			var tile_position := Vector2i(chunk_position.x - width / 2 + x, chunk_position.y - height / 2 + y)
			if (get_cell_tile_data(0, tile_position)):
				continue
			var flower_noise_value := flower_noise.get_noise_2dv(tile_position) + randf_range(-randomness, randomness)
			var stone_noise_value := stone_noise.get_noise_2dv(tile_position) + randf_range(-randomness, randomness)
			var source_id : int = 0
			if flower_noise_value < -0.1:
				source_id = 1
			if stone_noise_value < -0.3:
				source_id = 2
			var tiles_count := tile_set.get_source(source_id).get_tiles_count()
			var random_atlas_position := tile_set.get_source(source_id).get_tile_id(randi_range(0, tiles_count - 1))
			set_cell(0, tile_position, source_id, random_atlas_position)

func _on_chunk_update_timer_timeout():
	update_chunk()

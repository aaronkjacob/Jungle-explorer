extends TileMap

@export var debug = false
@export var sideTilesNavigationStack = true

var hdr = 1.2

func _ready():
	if $walls.enabled:
		remove_navigation_tiles_on_overlap($navigation_layer,$walls)
	self.modulate = Color(hdr,hdr,hdr)


func remove_navigation_tiles_on_overlap(nav_layer: TileMapLayer, obstacle_layer: TileMapLayer):
	for cell in nav_layer.get_used_cells():
		var obstacle_tile := obstacle_layer.get_cell_source_id(cell)

		if obstacle_tile != -1:
			# Remove the navigation tile at the overlapping cell
			nav_layer.set_cell(cell, -1)
			if debug:
				print("Removed navigation tile at:", cell)

			# Define adjacent cell offsets using Vector2i
			var adjacent_offsets = [
				Vector2i(-1, 0), Vector2i(1, 0),   # Left, Right
				Vector2i(0, -1), Vector2i(0, 1),   # Up, Down
				#Vector2i(-1, -1), Vector2i(1, -1), # Top-left, Top-right
				#Vector2i(-1, 1), Vector2i(1, 1)    # Bottom-left, Bottom-right
			]
			
				
			
			if !sideTilesNavigationStack:
				adjacent_offsets.clear()

			# Remove adjacent navigation tiles
			for offset in adjacent_offsets:
				var adjacent_cell = cell + offset
				if nav_layer.get_cell_source_id(adjacent_cell) != -1:
					nav_layer.set_cell(adjacent_cell, -1)
					if debug:
						print("Removed adjacent navigation tile at:", adjacent_cell)

extends Node3D

@export var chunk_size: float = 200.0
@export var resolution: int = 50
@export var height_scale: float = 25.0
@export var how_much: float = 10

var noise: FastNoiseLite
var mesh_instance: MeshInstance3D
var static_body: StaticBody3D
var collision_shape: CollisionShape3D
var spawn_transform: Transform3D

func _ready() -> void:
	noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = how_much
	
	mesh_instance = MeshInstance3D.new()
	add_child(mesh_instance)
	
	static_body = StaticBody3D.new()
	mesh_instance.add_child(static_body)
	
	collision_shape = CollisionShape3D.new()
	static_body.add_child(collision_shape)
	
	spawn_transform = global_transform
	
	_generate_terrain()
	
func _generate_terrain() -> void:
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for z in range(resolution + 1):
		for x in range(resolution + 1):
			var percent_x = float(x) / resolution
			var percent_z = float(z) / resolution
			
			var pos_x = (percent_x - 0.5) * chunk_size
			var pos_z = (percent_z - 0.5) * chunk_size
			
			var height = noise.get_noise_2d(pos_x, pos_z)
			
			if height < 0.0:
				height = 0.0
				
			var pos_y = height * height_scale
			
			surface_tool.set_uv(Vector2(percent_x, percent_z))
			surface_tool.add_vertex(Vector3(pos_x, pos_y, pos_z))
	for z in range(resolution):
		for x in range(resolution):
			#var vertex_index = x + z * (resolution + 1)
			var w = resolution + 1
			var a = x + z * w
			var b = (x + 1) + z * w
			var c = x + (z + 1) * w
			var d = (x + 1) + (z + 1) * w

			surface_tool.add_index(a)
			surface_tool.add_index(b)
			surface_tool.add_index(c)

			surface_tool.add_index(b)
			surface_tool.add_index(d)
			surface_tool.add_index(c)
			
	surface_tool.generate_normals()
	var array_mesh = surface_tool.commit()
	
	mesh_instance.mesh = array_mesh
	collision_shape.shape = array_mesh.create_trimesh_shape()

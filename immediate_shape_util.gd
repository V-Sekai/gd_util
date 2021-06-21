@tool

const camera_matrix_util_const = preload("camera_matrix_util.gd")

static func create_icon_material(p_texture: Texture, p_albedo: Color) -> StandardMaterial3D:
	var color: Color = p_albedo

	var icon: StandardMaterial3D = StandardMaterial3D.new()
	icon.set_flag(StandardMaterial3D.FLAG_UNSHADED, true)
	icon.set_cull_mode(StandardMaterial3D.CULL_DISABLED)
	icon.set_depth_draw_mode(StandardMaterial3D.DEPTH_DRAW_DISABLED)
	icon.set_feature(StandardMaterial3D.FEATURE_TRANSPARENT, true)
	icon.set_albedo(color)
	icon.set_texture(StandardMaterial3D.TEXTURE_ALBEDO, p_texture)
	icon.set_flag(StandardMaterial3D.FLAG_FIXED_SIZE, true)
	icon.set_billboard_mode(StandardMaterial3D.BILLBOARD_ENABLED)

	return icon

static func create_debug_material(p_color: Color) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()

	material.params_depth_draw_mode = StandardMaterial3D.DEPTH_DRAW_ALWAYS

	material.flags_unshaded = true
	material.flags_transparent = true
	material.set_flag(StandardMaterial3D.FLAG_SRGB_VERTEX_COLOR, true)
	material.set_flag(StandardMaterial3D.FLAG_ALBEDO_FROM_VERTEX_COLOR, true)
	material.set_albedo(p_color)

	#material.flags_no_depth_test = true

	return material

static func create_debug_immediate() -> ImmediateGeometry3D:
	var immediate_geometry: ImmediateGeometry3D = ImmediateGeometry3D.new()
	immediate_geometry.set_cast_shadows_setting(GeometryInstance3D.SHADOW_CASTING_SETTING_OFF)
	immediate_geometry.set_flag(GeometryInstance3D.FLAG_RECEIVE_SHADOWS, false)

	var material: Material = create_debug_material(Color(1.0, 1.0, 1.0))

	immediate_geometry.set_material_override(material)
	return immediate_geometry

static func immediate_cube(p_aabb: AABB, p_immediate_geometry: ImmediateGeometry3D) -> void:
	p_immediate_geometry.begin(Mesh.PRIMITIVE_LINES)

	var aabb_min: Vector3 = p_aabb.position
	var aabb_max: Vector3 = p_aabb.end

	p_immediate_geometry.add_vertex(Vector3(aabb_min.x, aabb_min.y, aabb_min.z))
	p_immediate_geometry.add_vertex(Vector3(aabb_min.x, aabb_max.y, aabb_min.z))

	p_immediate_geometry.add_vertex(Vector3(aabb_min.x, aabb_min.y, aabb_min.z))
	p_immediate_geometry.add_vertex(Vector3(aabb_max.x, aabb_min.y, aabb_min.z))

	p_immediate_geometry.add_vertex(Vector3(aabb_min.x, aabb_max.y, aabb_min.z))
	p_immediate_geometry.add_vertex(Vector3(aabb_max.x, aabb_max.y, aabb_min.z))

	p_immediate_geometry.add_vertex(Vector3(aabb_max.x, aabb_min.y, aabb_min.z))
	p_immediate_geometry.add_vertex(Vector3(aabb_max.x, aabb_max.y, aabb_min.z))

	p_immediate_geometry.add_vertex(Vector3(aabb_max.x, aabb_min.y, aabb_min.z))
	p_immediate_geometry.add_vertex(Vector3(aabb_max.x, aabb_min.y, aabb_max.z))

	p_immediate_geometry.add_vertex(Vector3(aabb_max.x, aabb_max.y, aabb_min.z))
	p_immediate_geometry.add_vertex(Vector3(aabb_max.x, aabb_max.y, aabb_max.z))

	p_immediate_geometry.add_vertex(Vector3(aabb_max.x, aabb_min.y, aabb_max.z))
	p_immediate_geometry.add_vertex(Vector3(aabb_max.x, aabb_max.y, aabb_max.z))

	p_immediate_geometry.add_vertex(Vector3(aabb_max.x, aabb_min.y, aabb_max.z))
	p_immediate_geometry.add_vertex(Vector3(aabb_min.x, aabb_min.y, aabb_max.z))

	p_immediate_geometry.add_vertex(Vector3(aabb_max.x, aabb_max.y, aabb_max.z))
	p_immediate_geometry.add_vertex(Vector3(aabb_min.x, aabb_max.y, aabb_max.z))

	p_immediate_geometry.add_vertex(Vector3(aabb_min.x, aabb_min.y, aabb_max.z))
	p_immediate_geometry.add_vertex(Vector3(aabb_min.x, aabb_max.y, aabb_max.z))

	p_immediate_geometry.add_vertex(Vector3(aabb_min.x, aabb_min.y, aabb_max.z))
	p_immediate_geometry.add_vertex(Vector3(aabb_min.x, aabb_min.y, aabb_min.z))

	p_immediate_geometry.add_vertex(Vector3(aabb_min.x, aabb_max.y, aabb_max.z))
	p_immediate_geometry.add_vertex(Vector3(aabb_min.x, aabb_max.y, aabb_min.z))

	p_immediate_geometry.end()

static func immediate_camera_frustum(
	p_camera_matrix: RefCounted, p_immediate_geometry: ImmediateGeometry3D
) -> void:
	var end_points: PackedVector3Array = p_camera_matrix.get_endpoints()

	p_immediate_geometry.begin(Mesh.PRIMITIVE_LINES)

	# Near
	p_immediate_geometry.add_vertex(end_points[0])
	p_immediate_geometry.add_vertex(end_points[2])

	p_immediate_geometry.add_vertex(end_points[2])
	p_immediate_geometry.add_vertex(end_points[3])

	p_immediate_geometry.add_vertex(end_points[3])
	p_immediate_geometry.add_vertex(end_points[1])

	p_immediate_geometry.add_vertex(end_points[1])
	p_immediate_geometry.add_vertex(end_points[0])

	#Far
	p_immediate_geometry.add_vertex(end_points[4])
	p_immediate_geometry.add_vertex(end_points[6])

	p_immediate_geometry.add_vertex(end_points[6])
	p_immediate_geometry.add_vertex(end_points[7])

	p_immediate_geometry.add_vertex(end_points[7])
	p_immediate_geometry.add_vertex(end_points[5])

	p_immediate_geometry.add_vertex(end_points[5])
	p_immediate_geometry.add_vertex(end_points[4])

	# Connection
	p_immediate_geometry.add_vertex(end_points[0])
	p_immediate_geometry.add_vertex(end_points[4])

	p_immediate_geometry.add_vertex(end_points[1])
	p_immediate_geometry.add_vertex(end_points[5])

	p_immediate_geometry.add_vertex(end_points[2])
	p_immediate_geometry.add_vertex(end_points[6])

	p_immediate_geometry.add_vertex(end_points[3])
	p_immediate_geometry.add_vertex(end_points[7])

	p_immediate_geometry.end()

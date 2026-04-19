@tool
class_name PathTools extends Path3D

@export_tool_button("Simplify") var simplify: Callable = on_click_simplify
@export_tool_button("Reverse") var reverse: Callable = on_click_reverse
@export_tool_button("Curve Corners") var curve_corners: Callable = on_click_curve_corners


func on_click_simplify() -> void:
	if not curve:
		return
	
	var count := curve.get_point_count()
	if count < 3:
		return

	var new_points: Array[Vector3] = []
	new_points.append(curve.get_point_position(0))

	const EPSILON := 0.0001

	for i in range(1, count - 1):
		var a: Vector3 = curve.get_point_position(i - 1)
		var b: Vector3 = curve.get_point_position(i)
		var c: Vector3 = curve.get_point_position(i + 1)

		var ab: Vector3 = (b - a).normalized()
		var bc: Vector3 = (c - b).normalized()

		# If direction barely changes, it's colinear
		if ab.dot(bc) < 1.0 - EPSILON:
			new_points.append(b)
		# else: skip point B

	new_points.append(curve.get_point_position(count - 1))

	# Rebuild curve
	curve.clear_points()
	for p in new_points:
		curve.add_point(p)

	print("Simplified from %d → %d points" % [count, new_points.size()])



func on_click_reverse() -> void:
	if not curve:
		return

	var count := curve.get_point_count()
	if count < 2:
		return

	var positions: Array[Vector3] = []
	var ins: Array[Vector3] = []
	var outs: Array[Vector3] = []

	for i in range(count):
		positions.append(curve.get_point_position(i))
		ins.append(curve.get_point_in(i))
		outs.append(curve.get_point_out(i))

	curve.clear_points()

	for i in range(count - 1, -1, -1):
		# Swap in/out when reversing
		curve.add_point(
			positions[i],
			outs[i], # becomes "in"
			ins[i]   # becomes "out"
		)

	print("Reversed path")



func on_click_curve_corners() -> void:
	var curve: Curve3D = get_curve()
	var point_count: int = curve.point_count
	
	if point_count < 3:
		return
	
	var new_points: PackedVector3Array = []
	
	# Start with the very first point of the original curve
	new_points.append(curve.get_point_position(0))
	
	for i in range(1, point_count - 1):
		var a: Vector3 = curve.get_point_position(i - 1)
		var b: Vector3 = curve.get_point_position(i)
		var c: Vector3 = curve.get_point_position(i + 1)
		
		# generate_corner returns the arc points that bridge the gap
		var replacement: PackedVector3Array = generate_corner(a, b, c)
		
		# If the corner is too sharp/straight, it returns [b], 
		# otherwise it returns the arc.
		for p in replacement:
			# Avoid adding the same point twice if start of arc == end of previous
			if new_points.size() > 0 and new_points[-1].is_equal_approx(p):
				continue
			new_points.append(p)
	
	# Finish with the very last point of the original curve
	var last_p = curve.get_point_position(point_count - 1)
	if not new_points[-1].is_equal_approx(last_p):
		new_points.append(last_p)
	
	# Create the new curve
	var new_curve := Curve3D.new()
	# Set bake_interval to a higher value if you want it to stay "blocky"
	# or low if you want Godot to smooth these new segments further.
	new_curve.bake_interval = 0.2 
	
	for p in new_points:
		new_curve.add_point(p)
	
	_apply_to_curved_path(new_curve)



func _apply_to_curved_path(new_curve: Curve3D) -> void:
	var curved_path: Path3D = get_node_or_null("Curved")
	
	if curved_path == null:
		curved_path = Path3D.new()
		curved_path.name = "Lane"
		add_child(curved_path)
		curved_path.owner = self.owner
		
	
	curved_path.curve = new_curve


func generate_corner(a: Vector3, b: Vector3, c: Vector3, radius: float = 0.5, segments: int = 8) -> PackedVector3Array:
	var v1 = (a - b).normalized()
	var v2 = (c - b).normalized()
	var angle = v1.angle_to(v2)
	
	if angle >= PI - 0.01 or angle <= 0.01:
		return PackedVector3Array([b])

	var tangent_dist = radius / tan(angle / 2.0)
	var bisector = (v1 + v2).normalized()
	var center = b + bisector * (radius / sin(angle / 2.0))
	
	var start_vec = (b + v1 * tangent_dist) - center
	var axis = v1.cross(v2).normalized()
	var sweep_angle = PI - angle
	
	var points = PackedVector3Array()
	for i in range(segments + 1):
		var t = float(i) / segments
		# We rotate the start vector around the center to create the arc
		points.append(center + start_vec.rotated(axis, -sweep_angle * t))
	
	return points

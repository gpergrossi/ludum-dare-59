class_name TowerBase extends Tile

@onready var highlight: MeshInstance3D = %Highlight
@onready var wirebox: Wirebox = %Wirebox

func _ready() -> void:
	wirebox.hover_changed.connect(update_highlight_hover)
	wirebox.select_changed.connect(update_highlight_select)

func update_highlight() -> void:
	highlight.visible = wirebox.selected or wirebox.hovered
	var matr := highlight.material_override as StandardMaterial3D
	matr.albedo_color = Color.WHITE if wirebox.selected else Color.DIM_GRAY

func update_highlight_hover(_hover: bool) -> void:
	update_highlight()

func update_highlight_select(_select: bool) -> void:
	update_highlight()

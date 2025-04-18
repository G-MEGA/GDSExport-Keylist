@tool
extends EditorProperty

var _bottom_editor_button:Button
var _bottom_editor:VBoxContainer
var _bottom_editor_elements:Array[HBoxContainer]
var _bottom_editor_add_button:Button
var _updating = false

var _keys:PackedStringArray
var _left_keys:PackedStringArray

func _init(key_path:String):
	_bottom_editor_button = Button.new()
	add_child(_bottom_editor_button)
	add_focusable(_bottom_editor_button)
	_bottom_editor_button.pressed.connect(_on_button_pressed)
	
	var key_path_split := key_path.rsplit("/", false, 1)
	
	if not key_path_split.size() == 2:
		_bottom_editor_button.text = "Path Error"
		return
	
	var res_path := key_path_split[0].strip_edges()
	var res_property_path := key_path_split[1].strip_edges()
	
	if not ResourceLoader.exists(res_path):
		_bottom_editor_button.text = "No Resource on path"
		return
	
	var res_containing_keys := ResourceLoader.load(res_path)
	var key_property_value = res_containing_keys.get_indexed(res_property_path)
	
	if key_property_value is Dictionary:
		_keys = PackedStringArray(key_property_value.keys())
	elif key_property_value is Array:
		_keys = PackedStringArray(key_property_value)
	else:
		_bottom_editor_button.text = "Need Dictionary or Array"
		return
	
	
	_bottom_editor = VBoxContainer.new()
	_bottom_editor.visible = false
	add_child(_bottom_editor)
	set_bottom_editor(_bottom_editor)
	
	_bottom_editor_add_button = Button.new()
	_bottom_editor_add_button.text = "Add Element"
	_bottom_editor_add_button.pressed.connect(_on_add_button_pressed)
	_bottom_editor.add_child(_bottom_editor_add_button)

func _on_button_pressed():
	if not _bottom_editor:
		return
	
	_bottom_editor.visible = not _bottom_editor.visible
		
		
		
	## Ignore the signal if the property is currently being updated.
	#if (_updating):
		#return
#
	## Generate a new random integer between 0 and 99.
	#_current_value = randi() % 100
	#refresh_control_text()
	#emit_changed(get_edited_property(), _current_value)

func _on_add_button_pressed():
	var value:PackedStringArray = get_edited_object()[get_edited_property()]
	value.append("")
	emit_changed(get_edited_property(), value)

func _update_property():
	var value:PackedStringArray = get_edited_object()[get_edited_property()]
	
	_bottom_editor_button.text = "Key List (size %d)" % value.size()
	
	for i in range(_bottom_editor_elements.size(), value.size()):
		_bottom_editor_elements.append(_create_element())
		
		_bottom_editor_elements[i].get_child(0).about_to_popup.connect(_on_element_menu_popup.bind(i))
		_bottom_editor_elements[i].get_child(0).get_popup().index_pressed.connect(_on_element_menu_popup_pressed.bind(i))
		_bottom_editor_elements[i].get_child(1).pressed.connect(_on_element_move_up_pressed.bind(i))
		_bottom_editor_elements[i].get_child(2).pressed.connect(_on_element_move_down_pressed.bind(i))
		_bottom_editor_elements[i].get_child(3).pressed.connect(_on_element_remove_pressed.bind(i))
		
		_bottom_editor.add_child(_bottom_editor_elements[i])
		_bottom_editor.move_child(_bottom_editor_elements[i], i)
	
	for i in range(0, value.size()):
		_bottom_editor_elements[i].visible = true
		if value[i] in _keys:
			_bottom_editor_elements[i].get_child(0).text = value[i]
		else:
			_bottom_editor_elements[i].get_child(0).text = "(Missing) " + value[i]
			
	for i in range(value.size(), _bottom_editor_elements.size()):
		_bottom_editor_elements[i].visible = false

func _create_element() -> HBoxContainer:
	var e := HBoxContainer.new()
	
	var menu := MenuButton.new()
	var button_move_up := Button.new()
	var button_move_down := Button.new()
	var button_remove := Button.new()
	menu.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	menu.flat = false
	button_move_up.text = "↑"
	button_move_down.text = "↓"
	button_remove.text = "X"
	e.add_child(menu)
	e.add_child(button_move_up)
	e.add_child(button_move_down)
	e.add_child(button_remove)
	
	return e
func _on_element_menu_popup(idx:int):
	var value:PackedStringArray = get_edited_object()[get_edited_property()]
	
	_left_keys = _keys.duplicate()
	
	for k in value:
		var does_key_exist_in_list := _left_keys.find(k)
		if does_key_exist_in_list >= 0:
			_left_keys.remove_at(does_key_exist_in_list)
	
	var menu := _bottom_editor_elements[idx].get_child(0).get_popup() as PopupMenu
	menu.clear()
	
	for i in range(_left_keys.size()):
		menu.add_item(_left_keys[i], i)
	pass
	
func _on_element_menu_popup_pressed(key_idx:int, idx:int):
	var value:PackedStringArray = get_edited_object()[get_edited_property()]
	
	value[idx] = _left_keys[key_idx]
	
	emit_changed(get_edited_property(), value)
func _on_element_move_up_pressed(idx:int):
	var value:PackedStringArray = get_edited_object()[get_edited_property()]
	
	if idx <= 0:
		return
	
	var temp := value[idx]
	value[idx] = value[idx-1]
	value[idx-1] = temp
	
	emit_changed(get_edited_property(), value)
func _on_element_move_down_pressed(idx:int):
	var value:PackedStringArray = get_edited_object()[get_edited_property()]
	
	if idx >= value.size() - 1:
		return
	
	var temp := value[idx]
	value[idx] = value[idx+1]
	value[idx+1] = temp
	
	emit_changed(get_edited_property(), value)
func _on_element_remove_pressed(idx:int):
	var value:PackedStringArray = get_edited_object()[get_edited_property()]
	value.remove_at(idx)
	emit_changed(get_edited_property(), value)

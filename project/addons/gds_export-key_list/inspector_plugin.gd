@tool
extends EditorInspectorPlugin

const KEY_LIST_HINT_STRING_PREFIX = "KeyList:"

var KeyList = preload("res://addons/gds_export-key_list/key_list.gd")

func _can_handle(object):
	return true

func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	if (type == TYPE_PACKED_STRING_ARRAY and hint_type == PROPERTY_HINT_MAX 
	and hint_string.begins_with(KEY_LIST_HINT_STRING_PREFIX)):
		add_property_editor(name, KeyList.new(hint_string.substr(KEY_LIST_HINT_STRING_PREFIX.length())))
		return true
	else:
		return false

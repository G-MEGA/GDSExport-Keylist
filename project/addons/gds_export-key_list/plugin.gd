@tool
extends EditorPlugin

var plugin


func _enter_tree():
	plugin = preload("res://addons/gds_export-key_list/inspector_plugin.gd").new()
	add_inspector_plugin(plugin)


func _exit_tree():
	remove_inspector_plugin(plugin)

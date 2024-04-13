extends Node

func _on_button_pressed():
	var str = "%X"
	$Label.text = str % $TextEdit.text.unicode_at(0)

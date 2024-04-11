extends Node

var fontNames = []

func getUnicode(str):
	return "%X" % str.unicode_at(0)

func dir_contents(path):
	var dir = DirAccess.open(path)
	var contents = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			elif file_name.ends_with(".import"):
				file_name = dir.get_next()
				continue
			else:
				contents.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return contents

func _ready():
	fontNames = dir_contents("res://Fonts")
	getRandChar()

func getRandChar():
	var randFontEng = RandomNumberGenerator.new()
	var randCharEng = RandomNumberGenerator.new()
	var slctdFont = load("res://Fonts/"+fontNames[randFontEng.randi_range(0,fontNames.size())])
	var slctdChar = slctdFont.get_supported_chars()[randCharEng.randi_range(0,len(slctdFont.get_supported_chars()))]
	print(slctdFont)
	print(slctdChar)
	print(getUnicode(slctdChar))

func _on_button_pressed():
	var str = "%X"
	$Label.text = str % $TextEdit.text.unicode_at(0)

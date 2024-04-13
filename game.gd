extends Node2D

var running = true

var inputChars = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F']
var guessNum := 0
var curGuessNode
var charClrRects := []
var charLbls := []
var charPntr := 0
var userGuess := ''
var targetChar := ''
var targetUnc := ''
var fontNames := []

#var grayedLtrs := []


func getNodeGroup(Str):
	var nodes := []
	for node in get_tree().get_nodes_in_group(Str):
		nodes.append(node)
	return nodes

func getUnicode(Str):
	return "%X" % Str.unicode_at(0)

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

func getRandChar():
	var randFontEng = RandomNumberGenerator.new()
	var randCharEng = RandomNumberGenerator.new()
	var slctdFont = load("res://Fonts/"+fontNames[randFontEng.randi_range(0,fontNames.size())])
	var slctdChar = slctdFont.get_supported_chars()[randCharEng.randi_range(0,len(slctdFont.get_supported_chars()))]
	return slctdChar

func nextGuess():
	print('nextGuess')
	guessNum += 1
	userGuess = ''
	charClrRects.clear()
	charLbls.clear()
	
	if guessNum > 6:
		gameOver()
	
	for node in getNodeGroup('GuessCons'):
		if node.name.contains(str(guessNum)):
			curGuessNode = node
			print(curGuessNode)
			break
	for node in curGuessNode.get_children():
		if node.name.contains('Char'):
			charClrRects.append(node.get_child(0))
			charLbls.append(node.get_child(2).get_child(0))
	charPntr = 0

func gameOver():
	running = false
	$PanelContainer.show()

func checkGuess():
	if userGuess == targetUnc:
		print('correct')
		running = false
		for clrRect in charClrRects:
			clrRect.color = Color(0,255,0)
	else:
		for i in len(userGuess):
			if userGuess[i] == targetUnc[i]:
				charClrRects[i].color = Color(0,255,0)
			elif targetUnc.contains(userGuess[i]):
				charClrRects[i].color = Color(255,0,0)
		nextGuess()

func _ready():
	for node in getNodeGroup('Chars'):
		node.text = ''
	nextGuess()
	fontNames = dir_contents("res://Fonts")
	targetChar = getRandChar()
	targetUnc = getUnicode(targetChar)
	while len(targetUnc) < 5:
		targetUnc = '0'+targetUnc
	$Display/MarginContainer/CharLabel.text = targetChar


func userInput(val):
	if running:
		if val in inputChars:
			print("userInput character: \""+val+"\"")
			if charPntr < 5:
				charLbls[charPntr].text = val
				charPntr += 1
		elif val == 'BckSpc':
			print('userInput backspace')
			if charPntr > 0:
				charPntr -= 1
				charLbls[charPntr].text = ''
		elif val == "Rtrn":
			print("userInput return")
			if charPntr == 5:
				for Char in charLbls:
					userGuess = userGuess+Char.text
				print(userGuess)
				if userGuess == '':
					userGuess = '0'
				checkGuess()
					
		elif val == 'Clear':
			print("userInput clear")
			for node in charLbls:
				node.text = ''
			charPntr = 0
		else:
			print("userInput INVALID ARGS")

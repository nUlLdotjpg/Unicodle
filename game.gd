extends Node2D

var inputChars = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F']

func userInput(val):
	if val in inputChars:
		print("userInput character: \""+val+"\"")
	elif val == 'BckSpc':
		print("userInput backspace")
	elif val == "Rtrn":
		print("userInput return")


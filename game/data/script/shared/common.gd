extends Node

func banUnallowedChar(unAllowedChar : Array[String], string : String):
	var newString : String = ""
	for i in string:
		if i not in unAllowedChar:
			newString += i
	return newString

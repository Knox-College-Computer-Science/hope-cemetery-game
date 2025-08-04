extends Node

var people_arr = [] #Add all people to this array
var known_people = []

func move_to_known(person: String):
	if(people_arr.has(person) and !known_people.has(person)):
		print("moving person to known people")
		people_arr.erase(person)
		known_people.append(person)
	elif(known_people.has(person)):
		print("person is already known")
	else:
		print("this is not a person")

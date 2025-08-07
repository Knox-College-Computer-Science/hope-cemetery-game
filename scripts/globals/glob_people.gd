extends Node

var people_map = { #Add all people to this map example: "person1": {"description": "this is person 1's description", "picture": "picture reference", "known": false}
	"Person1": {"description": "this is person 1's description", "picture": "picture reference", "known": true},
	"Alex": {"description": "The messiest roommate ever! But loves mischief and is always willing to help you out.", "picture": "picture reference", "known": true}
}

func move_to_known(person: String):
	if people_map.has(person):
		if people_map[person]["known"] == false:
			people_map[person]["known"] = true
		print("this person is already known")
	print("this is not a person")

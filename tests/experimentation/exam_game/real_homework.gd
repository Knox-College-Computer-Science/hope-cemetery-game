extends CanvasLayer

const CARD_AMOUNT = 20
const NUMBER_OF_WORDS = 19

var cards = []
var selected_cards = []
var possible_words = ["Tree", "Art", "Rock", "Yeast", "Plant", "River", "Woods",
"Park", "Window", "Math", "Science", "Wolf", "Lion", "Happiness", "Lent",
"Possibility", "Touch", "Frugality", "Silence", "Influenza", "Computer", "Photography",
"Mall", "Brain", "Table", "Dollar", "Filter", "Magazine", "Password", "Probability",
"Language", "Prophecy", "Luggage", "Bottle", "Temper", "War"]
var words = []
var percent_scale = [0, 20, 40, 60, 80, 90]
var words_in_common = []
var total_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	possible_words.shuffle()
	for i in range(NUMBER_OF_WORDS):
		words.append(possible_words.pop_back())
	
	for i in range(CARD_AMOUNT):
		var new_card : QuestionCard = load("res://tests/experimentation/exam_game/question_card.tscn").instantiate()
		new_card.selected.connect(add_selected_card.bind(new_card))
		new_card.deselected.connect(removed_selected_card.bind(new_card))
		new_card.tree_exited.connect(add_new_card)
		new_card.card_discarded.connect(update_grade)
		
		# Add words to card
		var card_words = words.duplicate()
		card_words.shuffle()
		for j in range(5):
			new_card.words.append(card_words.pop_back())
		cards.append(new_card)
	
	for i in range(15):
		add_new_card()
		

func add_new_card():
	if(!cards.is_empty()):
		$GridContainer.add_child(cards.pop_front())


func _process(delta):
	$TimeLeft.text = str(int($Timer.time_left)/60)+":%02d" % (int($Timer.time_left)%60)


func add_selected_card(card):
	selected_cards.append(card)
	update_words_in_common()

func removed_selected_card(card):
	selected_cards.erase(card)
	update_words_in_common()

func update_words_in_common():
	words_in_common = words.duplicate()
	var temp = []
	for card in selected_cards:
		if(is_instance_valid(card)):
			for word in card.words:
				if(word in words_in_common):
					temp.append(word)
			words_in_common = temp
			temp = []
	#print(words_in_common)


func _on_remember_button_down():
	#print(selected_cards)
	var card_amount = selected_cards.size()
	var word_amount = words_in_common.size()
	var words_in_common_copy = words_in_common.duplicate()
	var added_percent = percent_scale[min(card_amount, percent_scale.size())-1]*word_amount
	for card in selected_cards.duplicate():
		#print(added_percent)
		if(card_amount > 1):
			card.add_percent(added_percent)
			for word in words_in_common_copy:
				card.remove_word(word)
		card.deselect()
	selected_cards = []
	update_words_in_common()

func update_grade(percent):
	total_score += percent
	$Grade.text = str(int((total_score/float(CARD_AMOUNT*100))*100))+"%"


func _on_timer_timeout():
	$GridContainer.hide()
	$TimeUp.show()


func _on_deselect_button_down():
	var selected_cards_copy = selected_cards.duplicate()
	for card in selected_cards_copy:
		card.deselect()

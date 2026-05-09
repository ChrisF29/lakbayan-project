extends CanvasLayer

@onready var label =$Panel/QuestLabel

func _ready():

    QuestManager.quest_updated.connect(
        update_quest
    )

    update_quest()

func update_quest():

    label.text = \
    "Quest:\n" + \
    QuestManager.current_quest
extends Node


const ICON_PATH = "res://Textures/Items/Upgrades/"
const WEAPON_PATH = "res://Textures/Items/Weapons/"
const UPGRADES = {
	"fireball1": {
		"icon": WEAPON_PATH + "fire_ball.png",
		"displayname": "Fire ball",
		"details": "Shoot a fireball at the nearest enemy",
		"level": "Level: 1",
		"prereq": [],
		"type": "weapon"
	},
	"fireball2": {
		"icon": WEAPON_PATH + "fire_ball.png",
		"displayname": "Fire ball",
		"details": "Add a additional Fire ball",
		"level": "Level: 2",
		"prereq": ["fireball1"],
		"type": "weapon"
	},
	"food": {
		"icon": ICON_PATH + "chunk.png",
		"displayname": "Food",
		"details": "Heals you for 20 health",
		"level": "N/A",
		"prereq": [],
		"type": "item"
	},
	"firecore1": {
		"icon": WEAPON_PATH + "fire_core.png",
		"displayname": "Fire core",
		"details": "A fire core is created and randomly fire somewhere in the players direction",
		"level": "Level: 1",
		"prereq": [],
		"type": "weapon"
	},
	"firecore2": {
		"icon": WEAPON_PATH + "fire_core.png",
		"displayname": "Fire core",
		"details": "An additional fire core is created",
		"level": "Level: 2",
		"prereq": ["fire core1"],
		"type": "weapon"
	},
	"firecore3": {
		"icon": WEAPON_PATH + "fire_core.png",
		"displayname": "Fire core",
		"details": "The fire core cooldown is reduced by 0.5 seconds",
		"level": "Level: 3",
		"prereq": ["fire core2"],
		"type": "weapon"
	},
	"firecore4": {
		"icon": WEAPON_PATH + "fire_core.png",
		"displayname": "Fire core",
		"details": "An additional fire core is created and the knockback is increased by 25%",
		"level": "Level: 4",
		"prereq": ["fire core3"],
		"type": "weapon"
	},
	"armor1": {
		"icon": ICON_PATH + "armor_01e.png",
		"displayname": "Armor",
		"details": "Reduces Damage By 1 point",
		"level": "Level: 1",
		"prereq": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": ICON_PATH + "armor_01e.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 2",
		"prereq": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": ICON_PATH + "armor_01e.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 3",
		"prereq": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": ICON_PATH + "armor_01e.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 4",
		"prereq": ["armor3"],
		"type": "upgrade"
	},
	"speed1": {
		"icon": ICON_PATH + "boots_01d.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by 50% of base speed",
		"level": "Level: 1",
		"prereq": [],
		"type": "upgrade"
	},
	"speed2": {
		"icon": ICON_PATH + "boots_01d.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 2",
		"prereq": ["speed1"],
		"type": "upgrade"
	},
	"speed3": {
		"icon": ICON_PATH + "boots_01d.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 3",
		"prereq": ["speed2"],
		"type": "upgrade"
	},
	"speed4": {
		"icon": ICON_PATH + "boots_01d.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased an additional 50% of base speed",
		"level": "Level: 4",
		"prereq": ["speed3"],
		"type": "upgrade"
	},
	"tome1": {
		"icon": ICON_PATH + "book_01d.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 1",
		"prereq": [],
		"type": "upgrade"
	},
	"tome2": {
		"icon": ICON_PATH + "book_01d.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 2",
		"prereq": ["tome1"],
		"type": "upgrade"
	},
	"tome3": {
		"icon": ICON_PATH + "book_01d.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 3",
		"prereq": ["tome2"],
		"type": "upgrade"
	},
	"tome4": {
		"icon": ICON_PATH + "book_01d.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 4",
		"prereq": ["tome3"],
		"type": "upgrade"
	},
	"scroll1": {
		"icon": ICON_PATH + "scroll_01b.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 1",
		"prereq": [],
		"type": "upgrade"
	},
	"scroll2": {
		"icon": ICON_PATH + "scroll_01b.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 2",
		"prereq": ["scroll1"],
		"type": "upgrade"
	},
	"scroll3": {
		"icon": ICON_PATH + "scroll_01b.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 3",
		"prereq": ["scroll2"],
		"type": "upgrade"
	},
	"scroll4": {
		"icon": ICON_PATH + "scroll_01b.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 4",
		"prereq": ["scroll3"],
		"type": "upgrade"
	},
	"ring1": {
		"icon": ICON_PATH + "ring_03c.png",
		"displayname": "Ring",
		"details": "Your spells now spawn 1 more additional attack",
		"level": "Level: 1",
		"prereq": [],
		"type": "upgrade"
	},
	"ring2": {
		"icon": ICON_PATH + "ring_03c.png",
		"displayname": "Ring",
		"details": "Your spells now spawn an additional attack",
		"level": "Level: 2",
		"prereq": ["ring1"],
		"type": "upgrade"
	},
}

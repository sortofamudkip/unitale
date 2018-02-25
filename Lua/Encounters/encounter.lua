-- A basic encounter script skeleton you can copy and modify for your own creations.

music = "shine_on_you_crazy_diamond" --Always OGG. Extension is added automatically. Remove the first two lines for custom music.
encountertext = "Poseur strikes a pose!" --Modify as necessary. It will only be read out in the action select screen.
nextwaves = {"elfire"} --default attack.
wavetimer = 6.0
arenasize = {155, 130}

enemies = {
	"poseur"
}

enemypositions = {
	{0, 0}
}

-- A custom list with attacks to choose from. Actual selection happens in EnemyDialogueEnding(). Put here in case you want to use it.
all_attacks = {"elfire", "oscillate"} -- copy this over later
possible_attacks = {"oscillate"}

function EncounterStarting()
    Audio["hurtsound"] = "dogsecret"
    -- If you want to change the game state immediately, this is the place.
end


-- the following functions get reloaded every time.

-- what the enemy does after you perform an action.
-- by default it will do the current dialogue.
function EnemyDialogueStarting()
    -- Good location for setting monster dialogue depending on how the battle is going.
    --enemies[1].SetVar('currentdialogue', {"It's\nworking."})
end

-- what the enemy does after they're done talking.
function EnemyDialogueEnding()
    -- Good location to fill the 'nextwaves' table with the attacks you want to have simultaneously.
    -- This example line below takes a random attack from 'possible_attacks'.
    nextwaves = { possible_attacks[math.random(#possible_attacks)] }
end


function DefenseEnding() --This built-in function fires after the defense round ends.
    encountertext = RandomEncounterText() --This built-in function gets a random encounter text from a random enemy.
    Audio["RESETDICTIONARY"] = "dogsecret"
end

--[[[
	the three states:
	ACTIONSELECT: when you get to choose ATK, ACT, etc.
	ENEMYDIALOGUE: when the enemy is talking.
	         ->EnemyDialogueStarting() runs here
	         ->EnemyDialogueEnding() runs here
	DEFENDING: when the enemy is attacking.
			 ->DefenseEnding() runs here.
			 ->encountertext is displayed here.
	
]]
function HandleSpare()
     State("ENEMYDIALOGUE") -- jump to enemy talking.
end

function HandleItem(ItemID)
    BattleDialog({"Selected item " .. ItemID .. "."})
end

function EnteringState(new, old) 
	if new == "ATTACKING" then
		State("ACTIONSELECT")
		BattleDialog({"You refused to fight him."})
	end
end
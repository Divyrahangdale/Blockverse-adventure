# Blockverse-adventure
I've created your Blockverse Adventure Solidity project! Here's what's included:
Project Structure:
blockverse-adventure/
├── BlockverseAdventure.sol
└── README.md
Smart Contract Features:
Core Functions:

createCharacter(string _name) - Players create their game character with a custom name and starting stats
completeQuest(uint256 _questId) - Complete quests to earn experience points and level up
createQuest(...) - Owner function to add new quests to the game

Additional Features:

Automatic level-up system when experience thresholds are met
Character stats tracking (level, experience, health, strength)
Quest completion tracking per player
View functions to retrieve character and quest data
Events for all major actions

Pre-loaded Quests:

"The First Steps" (Level 1, 100 XP)
"Dungeon Exploration" (Level 3, 250 XP)
"Dragon Slayer" (Level 5, 500 XP)

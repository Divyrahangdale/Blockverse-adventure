/ SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Blockverse Adventure
 * @dev A blockchain-based adventure game where players can create characters, 
 * embark on quests, and earn rewards
 */
contract BlockverseAdventure {
    
    // Struct to represent a player's character
    struct Character {
        string name;
        uint256 level;
        uint256 experience;
        uint256 health;
        uint256 strength;
        bool isActive;
    }
    
    // Struct to represent a quest
    struct Quest {
        string name;
        uint256 requiredLevel;
        uint256 experienceReward;
        uint256 completionCount;
        bool isActive;
    }
    
    // Mappings
    mapping(address => Character) public characters;
    mapping(uint256 => Quest) public quests;
    mapping(address => mapping(uint256 => bool)) public completedQuests;
    
    // State variables
    uint256 public questCount;
    address public owner;
    
    // Events
    event CharacterCreated(address indexed player, string name);
    event QuestCompleted(address indexed player, uint256 questId, uint256 expGained);
    event LevelUp(address indexed player, uint256 newLevel);
    event QuestCreated(uint256 questId, string name);
    
    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier hasCharacter() {
        require(characters[msg.sender].isActive, "You must create a character first");
        _;
    }
    
    constructor() {
        owner = msg.sender;
        questCount = 0;
        
        // Initialize some default quests
        createQuest("The First Steps", 1, 100);
        createQuest("Dungeon Exploration", 3, 250);
        createQuest("Dragon Slayer", 5, 500);
    }
    
    /**
     * @dev Create a new character for the player
     * @param _name The name of the character
     */
    function createCharacter(string memory _name) public {
        require(!characters[msg.sender].isActive, "Character already exists");
        require(bytes(_name).length > 0, "Name cannot be empty");
        
        characters[msg.sender] = Character({
            name: _name,
            level: 1,
            experience: 0,
            health: 100,
            strength: 10,
            isActive: true
        });
        
        emit CharacterCreated(msg.sender, _name);
    }
    
    /**
     * @dev Complete a quest and earn experience
     * @param _questId The ID of the quest to complete
     */
    function completeQuest(uint256 _questId) public hasCharacter {
        require(_questId < questCount, "Quest does not exist");
        require(quests[_questId].isActive, "Quest is not active");
        require(!completedQuests[msg.sender][_questId], "Quest already completed");
        
        Character storage character = characters[msg.sender];
        Quest storage quest = quests[_questId];
        
        require(character.level >= quest.requiredLevel, "Level too low for this quest");
        
        // Mark quest as completed
        completedQuests[msg.sender][_questId] = true;
        quest.completionCount++;
        
        // Award experience
        character.experience += quest.experienceReward;
        
        emit QuestCompleted(msg.sender, _questId, quest.experienceReward);
        
        // Check for level up
        checkLevelUp();
    }
    
    /**
     * @dev Level up the character if they have enough experience
     */
    function checkLevelUp() internal {
        Character storage character = characters[msg.sender];
        uint256 experienceNeeded = character.level * 100;
        
        while (character.experience >= experienceNeeded) {
            character.level++;
            character.health += 20;
            character.strength += 5;
            experienceNeeded = character.level * 100;
            
            emit LevelUp(msg.sender, character.level);
        }
    }
    
    /**
     * @dev Create a new quest (only owner)
     * @param _name The name of the quest
     * @param _requiredLevel The minimum level required
     * @param _experienceReward The experience reward for completion
     */
    function createQuest(
        string memory _name,
        uint256 _requiredLevel,
        uint256 _experienceReward
    ) public onlyOwner {
        quests[questCount] = Quest({
            name: _name,
            requiredLevel: _requiredLevel,
            experienceReward: _experienceReward,
            completionCount: 0,
            isActive: true
        });
        
        emit QuestCreated(questCount, _name);
        questCount++;
    }
    
    /**
     * @dev Get character details for a player
     * @param _player The address of the player
     */
    function getCharacter(address _player) public view returns (
        string memory name,
        uint256 level,
        uint256 experience,
        uint256 health,
        uint256 strength
    ) {
        Character memory character = characters[_player];
        return (
            character.name,
            character.level,
            character.experience,
            character.health,
            character.strength
        );
    }
    
    /**
     * @dev Get quest details
     * @param _questId The ID of the quest
     */
    function getQuest(uint256 _questId) public view returns (
        string memory name,
        uint256 requiredLevel,
        uint256 experienceReward,
        uint256 completionCount
    ) {
        require(_questId < questCount, "Quest does not exist");
        Quest memory quest = quests[_questId];
        return (
            quest.name,
            quest.requiredLevel,
            quest.experienceReward,
            quest.completionCount
        );
    }
}

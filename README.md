This is first release of TBC version ported from Vanilla one. There is possibility that something won't be functional as intended. Feel free to report the issue.

# WhisperFilter
If you are annoyed by whispers of gold sellers and beggers this is right choice for you.
  
- Easy to use. 
- Default level limit is set to 5.
- You can change it by command **/wf level <number>**
- You can bypass limit by adding that character to friend list.
  
## Commands
- /wf show <whitelist | blacklist | error | phrase | highlight | autoinv>
- /wf clean/reset/wipe <whitelist | blacklist | error | phrase | highlight | autoinv>
  
- /wf wim (Allows you to fix WIM empty Who list problem)
- /wf ignore (Enable/Disable extended ignore list)
- /wf ignore all (Enable/Disable extended ignore for ALL channels like raid, party, say...)
- /wf debug (For science purposes :))
  
- /i <player>
- /ignore <player>
  
- /wf clink - Enable/Disable feature
- /wf copychat - Enable/Disable feature **(Disabled by default)**
- /wf error - Enable/Disable feature
- /wf highlight - Enable/Disable feature **(Disabled by default)**
- /wf mute - Enable/Disable addon sounds
- /wf autoinv|autoinvite - Enable/Disable feature **(Disabled by default)**
- /wf guildblock - Enable/Disable. Blocks all guild invites **(Disabled by default)**
 
- /wf error <text> - Adds error messages to blacklist
- /wf phrase <text> - Adds phrase to blacklist
- /wf autoinv|autoinvite <text> - Invites players that whisper you defined phrase (can be only one each time)
- /wf highlight <text>- Adds text that should be highlighted to list
- /wf highlight <CHANNEL SHORT NAME> - Highlights all messages from channel
- Example: /wf highlight [G] - Highlights all messages from guild channel
  
- /wf copychat limit <number> - Allows you to change number of history lines. If you experience any low FPS issues while opening History box then lower the value. Default: 1000
- /wf copychat set "MSG_TYPE" <pattern> - Allows you to change how channel name shows in Copybox

- /reload
- /reloadui

- /wf sticky - Changes chat behaviour to keep any channel type of previous sent message | Enable/Disable feature **(Disabled by default)** 
- /wf loot - Modifies how roll and loot info is displayed in chat | Enable/Disable feature **(Disabled by default)** 

## Channel Shortnames
- Guild - [g]
- Raid - [r] 
- Raid leader - [rl]
- Raid warning - [rw]
- Yell - [y]
- Say - [s] 
- Whisp to - [w to]
- Whisp from - [w from]
- Officer - [o]
- Battleground - [bg]
- BL leader - [bl]

## List of MSG_TYPE
- SYSTEM
- SAY
- PARTY
- RAID
- GUILD
- OFFICER
- YELL
- WHISPER
- WHISPER_FOREIGN
- WHISPER_INFORM
- EMOTE
- TEXT_EMOTE
- MONSTER_SAY
- MONSTER_PARTY
- MONSTER_YELL
- MONSTER_WHISPER
- MONSTER_EMOTE
- CHANNEL
- CHANNEL_JOIN
- CHANNEL_LEAVE
- CHANNEL_LIST
- CHANNEL_NOTICE
- CHANNEL_NOTICE_USER
- AFK
- DND
- IGNORED
- SKILL
- LOOT
- MONEY
- OPENING
- TRADESKILLS
- PET_INFO
- COMBAT_MISC_INFO
- COMBAT_XP_GAIN
- COMBAT_HONOR_GAIN
- COMBAT_FACTION_CHANGE
- BG_SYSTEM_NEUTRAL
- BG_SYSTEM_ALLIANCE
- BG_SYSTEM_HORDE
- RAID_LEADER
- RAID_WARNING
- RAID_BOSS_EMOTE
- RAID_BOSS_WHISPER
- FILTERED
- BATTLEGROUND
- BATTLEGROUND_LEADER
- RESTRICTED
- BATTLENET
- ACHIEVEMENT
- GUILD_ACHIEVEMENT
- ARENA_POINTS
- PARTY_LEADER
- TARGETICONS
- BN_WHISPER
- BN_WHISPER_INFORM
- BN_CONVERSATION
- BN_CONVERSATION_NOTICE
- BN_CONVERSATION_LIST
- BN_INLINE_TOAST_ALERT
- BN_INLINE_TOAST_BROADCAST
- BN_INLINE_TOAST_BROADCAST_INFORM
- BN_INLINE_TOAST_CONVERSATION
- COMBAT_GUILD_XP_GAIN
- CHANNEL1
- CHANNEL2
- CHANNEL3
- CHANNEL4
- CHANNEL5
- CHANNEL6
- CHANNEL7
- CHANNEL8
- CHANNEL9
- CHANNEL10
## Future Features

- **Spam Mail Blocking**
- **Optional Spam Verification Prompt** (If someone within the filtered levels whispers you it will ask them to confirm they are not a bot before sending another message)
## Credits
- Created by Psychi

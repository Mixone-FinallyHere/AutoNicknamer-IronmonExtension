local function AutoNicknamerExtension()
	local self = {}

	-- Define descriptive attributes of the custom extension that are displayed on the Tracker settings
	self.name = "Auto Nicknamer"
	self.author = "Mixone"
	self.description = "This extension allows you to set nicknames to be auto-assigned from a list of them in nicknames.txt"
	self.version = "1.0"
	self.url = "https://github.com/Mixone-FinallyHere/AutoNicknamer-IronmonExtension" -- Remove or set to nil if no host website available for this extension

	self.nicknames = {}
	self.needsNickname = false

	function table_invert(t)
		local s={}
		for k,v in pairs(t) do
		  s[v]=k
		end
		return s
	 end

	-- Executed when the user clicks the "Check for Updates" button while viewing the extension details within the Tracker's UI
	-- Returns [true, downloadUrl] if an update is available (downloadUrl auto opens in browser for user); otherwise returns [false, downloadUrl]
	-- Remove this function if you choose not to implement a version update check for your extension
	function self.checkForUpdates()
		local versionCheckUrl = "https://api.github.com/repos/Mixone-FinallyHere/AutoNicknamer-IronmonExtension/releases/latest"
		local versionResponsePattern = '"tag_name":%s+"%w+(%d+%.%d+)"' -- matches "1.0" in "tag_name": "v1.0"
		local downloadUrl = "https://github.com/Mixone-FinallyHere/AutoNicknamer-IronmonExtension/releases/latest"

		local isUpdateAvailable = Utils.checkForVersionUpdate(versionCheckUrl, self.version, versionResponsePattern, nil)
		return isUpdateAvailable, downloadUrl
	end


	-- Give the new capture a random nickname
	function self.giveRandName()
		if self.countPokemonAndEggs() == 6 then return nil end		
		local addressOffset = 0 + 100*(self.countPokemonAndEggs() - 1)
		local startAddress = GameSettings.pstats + addressOffset
		local personality = Memory.readdword(GameSettings.pstats + addressOffset)
		local otid = Memory.readdword(startAddress + 4)
		local magicword = Utils.bit_xor(personality, otid) -- The XOR encryption key for viewing the Pokemon data
		local aux          = personality % 24
		local growthoffset = (MiscData.TableData.growth[aux + 1] - 1) * 12
		local growth1 = Utils.bit_xor(Memory.readdword(startAddress + 32 + growthoffset), magicword)
		local species = Utils.getbits(growth1, 0, 16) -- Pokemon's Pokedex ID
		local nickname = ""
		for i=0, 9, 1 do
			local charByte = Memory.readbyte(startAddress + 8 + i)
			if charByte == 0xFF then break end -- end of sequence
			nickname = nickname .. (GameSettings.GameCharMap[charByte] or Constants.HIDDEN_INFO)
		end
		nickname = Utils.formatSpecialCharacters(nickname)
		print(nickname)
		print(DataHelper.buildPokemonInfoDisplay(species).p.name:upper())
		if DataHelper.buildPokemonInfoDisplay(species).p.name:upper() == nickname then
			local newNickname = self.randomNickname()
			for i=1, #newNickname do
				Memory.writebyte(startAddress + 8 + i - 1, newNickname[i])
			end
		end
	end

	-- Get a random nickname
	function self.randomNickname()
		return self.nicknames[math.random(#self.nicknames)]
	end
	
	-- Count Pokemon including eggs
	function self.countPokemonAndEggs()
		local count = 0
		for i=1, 6, 1 do
			if Tracker.Data.ownTeam[i] ~= 0 then count = count + 1 end
		end
		return count
	end

	-- Count Pokemon ignoring eggs
	function self.countPokemon()
		local count = 0
		for i=1, 6, 1 do
			if Tracker.Data.ownTeam[i] ~= 0 and Tracker.Data.ownPokemon[Tracker.Data.ownTeam[i]].isEgg ~= 1 then count = count + 1 end
		end
		return count
	end

	-- Generates the nicknames in byte format
	function self.initializeNicknames()
		self.ReverseCharMap = table_invert(GameSettings.GameCharMap)
		local file = io.open(FileManager.getCustomFolderPath() .. "nicknames.txt", "r");		
		for line in file:lines() do
			if #line > 1 and #line < 11 then
				local byteLine = {}
				for i = 1, #line do
					local c = line:sub(i,i)
					table.insert(byteLine, self.ReverseCharMap[c])
				end
				if #line < 10 then table.insert(byteLine, 0xFF) end
				table.insert(self.nicknames, byteLine);
			end
		end
		file:close()
	end

	-- Executed only once: When the extension is enabled by the user, and/or when the Tracker first starts up, after it loads all other required files and code
	function self.startup()
		self.initializeNicknames()
	end

	-- Executed only once: When the extension is disabled by the user, necessary to undo any customizations, if able
	function self.unload()
		self.nicknames = {}
		self.ReverseCharMap = {}
	end

	-- Executed once every 30 frames, after most data from game memory is read in
	function self.afterProgramDataUpdate()
		if self.needsNickname == true then
			self.giveRandName()
			self.needsNickname = false
		end
	end

	-- Executed after a battle ends, and only once per battle
	function self.afterBattleEnds()
		local lastBattleStatus = Memory.readbyte(GameSettings.gBattleOutcome)
		if lastBattleStatus == 7 then
			self.needsNickname = true
		end
	end

	return self
end
return AutoNicknamerExtension
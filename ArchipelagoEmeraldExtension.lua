local function ArchipelagoEmerald()
    -- Define descriptive attributes of the custom extension that are displayed on the Tracker settings
	local self = {}
	self.version = "1.0"
	self.name = "Archipelago Emerald"
	self.author = "WollyTD"
	self.description = "Extension that allows for compatibility with the randomized Emerald ROM hack for Archipelago runs."
	self.github = "MyUsername/ExtensionRepo" -- Replace "MyUsername" and "ExtensionRepo" to match your GitHub repo url, if any
	self.url = string.format("https://github.com/%s", self.github or "") -- Remove this attribute if no host website available for this extension

	self.jsonpath = "Archipelago Emerald.json"
    local DEBUG_MESSAGES_ON = false

	--------------------------------------
	-- INTERNAL TRACKER FUNCTIONS BELOW
	-- Add any number of these below functions to your extension that you want to use.
	-- If you don't need a function, don't add it at all; leave ommitted for faster code execution.
	--------------------------------------

	-- Executed when the user clicks the "Check for Updates" button while viewing the extension details within the Tracker's UI
	-- Returns [true, downloadUrl] if an update is available (downloadUrl auto opens in browser for user); otherwise returns [false, downloadUrl]
	-- Remove this function if you choose not to implement a version update check for your extension
	function self.checkForUpdates()
		-- Update the pattern below to match your version. You can check what this looks like by visiting the latest release url on your repo
		local versionResponsePattern = '"tag_name":%s+"%w+(%d+%.%d+)"' -- matches "1.0" in "tag_name": "v1.0"
		local versionCheckUrl = string.format("https://api.github.com/repos/%s/releases/latest", self.github or "")
		local downloadUrl = string.format("%s/releases/latest", self.url or "")
		local compareFunc = function(a, b) return a ~= b and not Utils.isNewerVersion(a, b) end -- if current version is *older* than online version
		local isUpdateAvailable = Utils.checkForVersionUpdate(versionCheckUrl, self.version, versionResponsePattern, compareFunc)
		return isUpdateAvailable, downloadUrl
	end

	-- Executed only once: When the extension is enabled by the user, and/or when the Tracker first starts up, after it loads all other required files and code
	function self.startup()
		if DEBUG_MESSAGES_ON then
			Utils.printDebug("Loading Archipelago Emerald Extension...")
			Utils.printDebug("Importing new addresses from JSON")
			-- Utils.printDebug("Testing Address gameStatsOffset: %x", GameSettings.gameStatsOffset or 0)
			Utils.printDebug("Testing Address pStats: %x", GameSettings.pstats or 0)
		end
		local filepath = FileManager.Folders.Custom .. FileManager.slash .. self.jsonpath
		local success = TrackerAPI.loadGameSettingsFromJson(filepath)
		if DEBUG_MESSAGES_ON then
			Utils.printDebug("Import complete, success: %s.", tostring(success))
			-- Utils.printDebug("Testing Address gameStatsOffset: %x", GameSettings.gameStatsOffset or 0)
			Utils.printDebug("Testing Address pStats: %x", GameSettings.pstats or 0)
		end
		
		-- Rebuild the Tracker's data objects
		PokemonData.buildData(true)
		MoveData.buildData(true)
		AbilityData.buildData(true)

		-- update resources for Tracker's data objects
		PokemonData.updateResources()
		MoveData.updateResources()
		AbilityData.updateResources()
		MiscData.updateResources()

		Utils.printDebug("Emerald Extension is active!")
	end

	-- Executed only once: When the extension is disabled by the user, necessary to undo any customizations, if able
	function self.unload()
		if DEBUG_MESSAGES_ON then
			Utils.printDebug("Unloading Archipelago Emerald Extension...")
			Utils.printDebug("Importing default addresses from JSON")
			Utils.printDebug("Testing Address gameStatsOffset: %x", GameSettings.gameStatsOffset or 0)
		end
		-- this is the way GameSettings uses to load the default addresses
		local success = GameSettings.importAddressesFromJson()
		if DEBUG_MESSAGES_ON then
			Utils.printDebug("Import complete, success: %s.", tostring(success))
			Utils.printDebug("Testing Address gameStatsOffset: %x", GameSettings.gameStatsOffset or 0)
		end

		-- Rebuild the Tracker's data objects
		PokemonData.buildData(true)
		MoveData.buildData(true)
		AbilityData.buildData(true)

		-- update resources for Tracker's data objects
		PokemonData.updateResources()
		MoveData.updateResources()
		AbilityData.updateResources()
		MiscData.updateResources()

		Utils.printDebug("Emerald Extension is not active anymore!")
	end

end
return ArchipelagoEmerald
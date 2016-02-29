User = require './User'

API = (apiKey) ->
	return @

API.prototype = 
	getMe: (cb)->
		request.get 'http://api.obsidianportal.com/v1/users/me.json', (req,body, userJson) ->

User = (userJson) ->
	@id = ""
	@username = ""
	@avatar = ""
	@profile = ""
	@campaigns = []
	@pro = false
	@lastSeen = 0
	@utc = "00:00"
	@locale = "US"
	@created = 0
	@updated = 0
	if userJson
		@processJson userJson
	return @

User.prototype = 
	processJson: (json) ->
		@id = ifExists(@id, json.id)
		@username = ifExists(@username, json.username)
		@avatar = ifExists(@avatar, json.avatar_image_url)
		@profile = ifExists(@profile, json.profile_url)
		@created = ifExists(@created, json.created_at)
		@updated = ifExists(@updated, json.updated_at)
		@lastSeen = ifExists(@lastSeen, json.last_seen_at)
		@utc = ifExists(@utc, json.utc_offset)
		@locale = ifExists(@locale, json.locale)
		@pro = ifExists(@pro, json.is_ascendant)
		for campaign in json.campaigns 
			temp = new Campaign(campaign)
			if json.roll == "Game_Master"
				temp.GM = @
			else
				temp.players.push @
			

Campaign = (campaignJson) ->
	@id = ""
	@name = ""
	@slug = ""
	@url = ""
	@visibility = 'public'
	@GM = ""
	@players = []
	@banner = ""
	@status = ""
	@fans = []
	@looking = false
	@location = {}

Campaign.prototype =
	processJson: (json) ->
		@id = ifExists(@id, json.id)
		@name = ifExists(@name, json.name)
		@url = ifExists(@url, json.campaign_url)
		@visibility = ifExists(@visibility, json.visibility)
		@GM = ifExists(@GM, json.game_master)
		@created = ifExists(@created, json.created_at)
		@updated = ifExists(@updated, json.updated_at)
	
ifExists = (old, replacement) ->
	if replacement ~= null or replacement ~= undefined
		return replacement
	else
		return old

module.exports = API

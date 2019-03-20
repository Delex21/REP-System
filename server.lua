-- REP Systeem by Delex

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			name = identity['name'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height'],
			job = identity['job'],
			group = identity['group'],
			rppunten = identity['rppunten']
		}
	else
		return nil
	end
end

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerClientEvent("pNotify:SetQueueMax", -1, reppunten, 5)

-- Functie om te geven voor Admin --

TriggerEvent('es:aDelexGroupCommand', 'rep', 'admin', function(source, args, user)
	if args[1] then
		if(GetPlayerName(tonumber(args[1])))then
			local spelernaam = GetPlayerName(args[1])
			local reden = table.concat(args, " ",3)
			local identifier = GetPlayerIdentifiers(source)[1]
			local theplayer = getIdentity(source)
			local aantalreps = tonumber(args[2])
			if (aantalreps) then
				if (aantalreps > 0) then
					TriggerEvent("es:getPlayerFromId", source, function(player)
						local huidigepunten = tonumber(theplayer.rppunten)
						local nieuwepunten = huidigepunten + tonumber(args[2])
						MySQL.Sync.execute('UPDATE users SET rppunten=@nieuwepunten WHERE identifier = @username', {['@username'] = identifier, ['@nieuwepunten'] = nieuwepunten})
						
							TriggerClientEvent("pNotify:SendNotification", args[1], {
								text = "<center><b style='color:#5997f9'>DenDam REP Systeem</b> <br/><b style='color:white'> </br> Je hebt " ..tonumber(args[2]).. " RP punt(en) ontvangen van " ..GetPlayerName(source).. " <br/> <br/> " ..GetPlayerName(source).. ": <i>" ..reden.. "</i></b><br /></center>",
								type = "alert",
								queue = "reppunten",
								timeout = 10000,
								layout = "centerLeft",
								theme = "gta",
							})
	
							TriggerClientEvent("pNotify:SendNotification", -1, {
								text = "<center><b style='color:#5997f9'>DenDam REP Systeem</b> <br/><b style='color:white'> </br> " ..spelernaam.. " heeft " ..tonumber(args[2]).. " REP punt(en) ontvangen van " ..GetPlayerName(source).. "! <br/> <br/>  " ..GetPlayerName(source).. ": <i>"  ..reden.. "</i></b><br /></center>",
								type = "alert",
								queue = "reppunten",
								timeout = 10000,
								layout = "centerLeft",
								theme = "gta",
							})

						end)
				elseif (aantalreps < 0 ) then
					TriggerEvent("es:getPlayerFromId", source, function(player)
						local huidigepunten = tonumber(theplayer.rppunten)
						local nieuwepunten = huidigepunten + tonumber(args[2])
						MySQL.Sync.execute('UPDATE users SET rppunten=@nieuwepunten WHERE identifier = @username', {['@username'] = identifier, ['@nieuwepunten'] = nieuwepunten})
						
							TriggerClientEvent("pNotify:SendNotification", args[1], {
								text = "<center><b style='color:#5997f9'>DenDam REP Systeem</b> <br/><b style='color:white'> </br> Je hebt " ..tonumber(args[2]).. " RP punt(en) verloren <br/> <br/> Reden: <i>" ..reden.. "</i></b><br /></center>",
								type = "alert",
								queue = "reppunten",
								timeout = 10000,
								layout = "centerLeft",
								theme = "gta",
							})
	
							TriggerClientEvent("pNotify:SendNotification", -1, {
								text = "<center><b style='color:#5997f9'>DenDam REP Systeem</b> <br/><b style='color:white'> </br> " ..spelernaam.. " heeft " ..tonumber(args[2]).. " REP punt(en) verloren! <br/> <br/>  Reden: <i>"  ..reden.. "</i></b><br /></center>",
								type = "alert",
								queue = "reppunten",
								timeout = 10000,
								layout = "centerLeft",
								theme = "gta",
							})
							
					
						end)
				end

			else
				TriggerClientEvent('chatMessage', source, "[Delex Staff systeem]", { 150, 0, 0 }," Onjuiste waarde voor REP punten!")
			end		
		else
			TriggerClientEvent('chatMessage', source, "[Delex Staff systeem]", { 150, 0, 0 }," Speler niet gevonden")
		end
	else
		TriggerClientEvent('chatMessage', source, "[Delex Staff systeem]", { 150, 0, 0 }," Onjuist ID ingevoerd ")
	end
end, {help = "Geef of neem REPs", params = {{name = "ID", help = "SpelerID"}, {name = "REP punten", help = "De REPS"}, {name = "Reden", help = "De reden voor de REP"}}})



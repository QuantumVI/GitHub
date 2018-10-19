--------------
--  CONFIG  --
--------------
local ownerEmail = ''             -- Owner Email (Required) - No account needed (Used Incase of Issues)
local kickThreshold = 0.99        -- Anything equal to or higher than this value will be kicked. (0.99 Recommended as Lowest)
local kickReason = 'We\'ve detected that you\'re using a VPN or Proxy. If you belive this is a mistake please contact the administration team.'
local printFailed = true
local maxPlayers = 32


------- DO NOT EDIT BELOW THIS LINE -------
function splitString(inputstr, sep)
	local t= {}; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
	if GetNumPlayerIndices() < maxPlayers then
		deferrals.defer()
		deferrals.update("Checking Player Information. Please Wait.")
		playerIP = GetPlayerEP(source)
		if string.match(playerIP, ":") then
			playerIP = splitString(playerIP, ":")[1]
		end
		if IsPlayerAceAllowed(source, "blockVPN.bypass") then
			deferrals.done()
		else 
			PerformHttpRequest('http://check.getipintel.net/check.php?ip=' .. playerIP .. '&contact=' .. ownerEmail, function(statusCode, response, headers)
				if response then
					if tonumber(response) >= kickThreshold then
						deferrals.done(kickReason)
						if printFailed then
							print('[BlockVPN][BLOCKED] ' .. playerName .. ' has been blocked from joining with a value of ' .. tonumber(response))
						end
					else 
						deferrals.done()
					end
				end
			end)
		end
	end
end)

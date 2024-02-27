wwwwwESX = nil
local playersHealing = {}
local doctorCount = 0
local Doctors = {}
DeathStatus = {}
TriggerEvent('esx:GetCyberZoneObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:revive', target)
		if DeathStatus[target] ~= nil then
			DeathStatus[target] = nil
		end
	else
		print(('esx_ambulancejob: %s attempted to revive!'):format(xPlayer.identifier))
	end
end)

RegisterNetEvent('hospital:server:AddDoctor', function(job)
	if job == 'ambulance' then
		local src = source
		doctorCount = doctorCount + 1
		TriggerClientEvent("hospital:client:SetDoctorCount", -1, doctorCount)
		Doctors[src] = true
	end
end)

AddEventHandler('onResourceStart', function(resourceName)
	if resourceName == 'esx_ambulancejob' then
		Wait(250)
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'ambulance' then
				Doctors[xPlayer.source] = true
				doctorCount = doctorCount + 1
				TriggerClientEvent("hospital:client:SetDoctorCount", -1, doctorCount)
			end
		end
	end
end)  

RegisterNetEvent('hospital:server:RemoveDoctor', function(job)
	if job == 'ambulance' then
		local src = source
		doctorCount = doctorCount - 1
		TriggerClientEvent("hospital:client:SetDoctorCount", -1, doctorCount)
		Doctors[src] = nil
	end
end)

AddEventHandler("playerDropped", function()
	local src = source
	if Doctors[src] then
		doctorCount = doctorCount - 1
		TriggerClientEvent("hospital:client:SetDoctorCount", -1, doctorCount)
		Doctors[src] = nil
	end
end)

RegisterServerEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:heal', target, type)
	else
		print(('esx_ambulancejob: %s attempted to heal!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		-- if exports['Eye-AC']:CheckPlayers(source, target, 8.0) ~= false then return end
		TriggerClientEvent('esx_ambulancejob:putInVehicle', target)
	else
		print(('esx_ambulancejob: %s attempted to put in vehicle!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_ambulancejob:message')
AddEventHandler('esx_ambulancejob:message', function(target, msg)
	-- if exports['Eye-AC']:CheckPlayers(source, target, 25.0) ~= false then return end
	TriggerClientEvent('esx:showNotification', target, msg)
end)

TriggerEvent('esx_phone:registerNumber', 'ambulance', _U('alert_ambulance'), true, true)

TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

exports.ox_inventory:RegisterStash("society_ambulance", 'Ambulance', 50, 1000000000, nil, {['ambulance'] = 0})

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	-- if Config.RemoveCashAfterRPDeath then
	-- 	if xPlayer.getAccount('money').money > 0 then
	-- 		xPlayer.removeAccountMoney('money', xPlayer.xPlayer.getAccount('money').money)
	-- 	end
	-- end

	local itemsToExclude = {"laptop", "phone", "id_card", "driver_license", "firearms_license"}
    for i=1, #xPlayer.inventory, 1 do
        if type(xPlayer.inventory[i]) == "table" and type(xPlayer.inventory[i].count) == "number" and xPlayer.inventory[i].count > 0 then
            local itemName = xPlayer.inventory[i].name
            if itemName ~= nil and not IsItemExcluded(itemName, itemsToExclude) then
                xPlayer.setInventoryItem(itemName, 0)
            end
        end
    end
	
	local playerLoadout = {}
	if Config.RemoveWeaponsAfterRPDeath then
		if type(xPlayer.loadout) == "table" then
			for i=1, #xPlayer.loadout, 1 do
				if type(xPlayer.loadout[i]) == "table" and xPlayer.loadout[i].name ~= nil then
					xPlayer.removeWeapon(xPlayer.loadout[i].name)
				end
			end
		end
	else -- save weapons & restore em' since spawnmanager removes them
		if type(xPlayer.loadout) == "table" then
			for i=1, #xPlayer.loadout, 1 do
				if xPlayer.loadout[i] ~= nil then
					table.insert(playerLoadout, xPlayer.loadout[i])
				end
			end
		end

		-- give back wepaons after a couple of seconds
		CreateThread(function()
			Wait(5000)
			for i=1, #playerLoadout, 1 do
				if type(playerLoadout[i]) == "table" and playerLoadout[i].label ~= nil and type(playerLoadout[i].ammo) == "number" and playerLoadout[i].name ~= nil then
					xPlayer.addWeapon(playerLoadout[i].name, playerLoadout[i].ammo)
				end
			end
		end)
	end

	cb()
end)

function IsItemExcluded(itemName, excludedItems)
    for _, excludedItem in ipairs(excludedItems) do
        if itemName == excludedItem then
            return true
        end
    end
    return false
end

ESX.RegisterServerCallback('esx_ambulancejob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory2', 'society_ambulance', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_ambulancejob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)


RegisterServerEvent('esx_ambulancejob:putStockItems')
AddEventHandler('esx_ambulancejob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = exports.ox_inventory:GetItem(source, itemName, nil, false)

	TriggerEvent('esx_addoninventory:getSharedInventory2', 'society_ambulance', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, inventoryItem.label))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

RegisterServerEvent('esx_ambulancejob:getStockItem')
AddEventHandler('esx_ambulancejob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = exports.ox_inventory:GetItem(source, itemName, nil, false)

	TriggerEvent('esx_addoninventory:getSharedInventory2', 'society_ambulance', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if exports.ox_inventory:CanCarryItem(source, itemName, sourceItem.count + count) then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_ambulancejob:checkBalance', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bankBalance = xPlayer.getAccount('bank').money

	cb(bankBalance >= Config.EarlyRespawnFineAmount)
end)

RegisterServerEvent('esx_ambulancejob:payFine')
AddEventHandler('esx_ambulancejob:payFine', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local fineAmount = Config.EarlyRespawnFineAmount

	TriggerClientEvent('esx:showNotification', xPlayer.source, _U('respawn_bleedout_fine_msg', ESX.Math.GroupDigits(fineAmount)))
	xPlayer.removeAccountMoney('bank', fineAmount)
end)

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = exports.ox_inventory:GetItem(source, item, nil, false).count

	cb(quantity)
end)

ESX.RegisterServerCallback('esx_ambulancejob:buyJobVehicle', function(source, cb, vehicleProps, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = getPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

	-- vehicle model not found
	if price == 0 then
		print(('esx_ambulancejob: %s attempted to exploit the shop! (invalid vehicle model)'):format(xPlayer.identifier))
		cb(false)
	else
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)
	
			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (@owner, @vehicle, @plate, @type, @job, @stored)', {
				['@owner'] = xPlayer.identifier,
				['@vehicle'] = json.encode(vehicleProps),
				['@plate'] = vehicleProps.plate,
				['@type'] = type,
				['@job'] = xPlayer.job.name,
				['@stored'] = true
			}, function (rowsChanged)
				cb(true)
			end)
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundPlate, foundNum

	for k,v in ipairs(nearbyVehicles) do
		local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = v.plate,
			['@job'] = xPlayer.job.name
		})

		if result[1] then
			foundPlate, foundNum = result[1].plate, k
			break
		end
	end

	if not foundPlate then
		cb(false)
	else
		MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = foundPlate,
			['@job'] = xPlayer.job.name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				print(('esx_ambulancejob: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end

end)

function getPriceFromHash(hashKey, jobGrade, type)
	if type == 'helicopter' then
		local vehicles = Config.AuthorizedHelicopters[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	elseif type == 'car' then
		local vehicles = Config.AuthorizedVehicles[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	end

	return 0
end

RegisterServerEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(item, 1)

	if item == 'bandage' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_bandage'))
	elseif item == 'medikit' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_medikit'))
	end
end)

RegisterServerEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'ambulance' then
		print(('esx_ambulancejob: %s attempted to spawn in an item!'):format(xPlayer.identifier))
		return
	elseif (itemName ~= 'medikit' and itemName ~= 'bandage' and itemName ~= 'oxygenmask' and itemName ~= 'bread' and itemName ~= 'water') then
		print(('esx_ambulancejob: %s attempted to spawn in an item!'):format(xPlayer.identifier))
		return
	end

	if exports.ox_inventory:CanCarryItem(source, itemName, 1) then
		xPlayer.addInventoryItem(itemName, 1)
	else
		TriggerClientEvent('esx:showNotification', source, _U('max_item'))
	end
end)

TriggerEvent('es:addAdminCommand', 'revive', 5, function(source, args, user)
	if args[1] ~= nil then
		if GetPlayerName(tonumber(args[1])) ~= nil then
			print(('esx_ambulancejob: %s used admin revive'):format(GetPlayerIdentifiers(source)[1]))
			TriggerClientEvent('esx_ambulancejob:revive', tonumber(args[1]))
		end
	else
		TriggerClientEvent('esx_ambulancejob:revive', source)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '[ System ] : ', 'Shoma Dastresi Kafi Nadarid.' } })
end, { help = _U('revive_help'), params = {{ name = 'id' }} })

ESX.RegisterUsableItem('medikit', function(source)
	if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('medikit', 1)
	
		playersHealing[source] = true
		TriggerClientEvent('esx_ambulancejob:useItem', source, 'medikit')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.scalar('SELECT is_dead FROM users WHERE identifier = ?', {xPlayer.identifier}, function(isDead)
		cb(isDead)
	end)
end)

RegisterNetEvent('hospital:server:LeaveBed', function(id)
    TriggerClientEvent('hospital:client:SetBed', -1, id, false)
end)

RegisterNetEvent('hospital:server:SendToBed', function(bedId, isRevive)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	TriggerClientEvent('hospital:client:SendToBed', src, bedId, Config.Locations["beds"][bedId], isRevive)
	TriggerClientEvent('hospital:client:SetBed', -1, bedId, true)
     local datetime = os.date('%Y-%m-%d %H:%M:%S')
     local sql = 'INSERT INTO bills (bill_date, amount, sender_account, sender_name, sender_citizenid, recipient_name, recipient_citizenid, status, status_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)'
     MySQL.insert(sql, {
         datetime,
         Config.BillCost,
         'ambulance',
         'Medic Department',
         0,
         Player.name,
         Player.identifier,
         'Unpaid',
         datetime
     }, function(result)
         if result > 0 then
             TriggerEvent('A-Dev_billing:server:notifyBillStatusChange', Player.source, 'Bill received - Amount: $'..Config.BillCost..' - From: Medic Department  ambulance', 'success', 'Bill Received', 'Bill received Amount: $'..Config.BillCost..' From: Medic Department  ambulance Access bill via /billing')
         else
             TriggerClientEvent('cyberhud:Notify', src, 'Error sending bill', 'error')
         end
     end)
end)

RegisterServerEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
	local identifier = ESX.GetPlayerFromId(source).identifier

	if type(isDead) ~= 'boolean' then
		print(('esx_ambulancejob: %s attempted to parse something else than a boolean to setDeathStatus!'):format(identifier))
		return
	end

	MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@isDead'] = isDead
	})
end)


RegisterNetEvent('sendDeathStatus')
AddEventHandler('sendDeathStatus', function(type, player, killer, DeathReason, Weapon, MahaleAsib)
if type == 1 then
	DeathStatus[player] = {
	killtime = os.date('%Y-%m-%d %H:%M'),
	pl = player,
	kill = player,
	dreason = 'Marg Tabie',
	_weapon = Weapon,
	mahal   = MahaleAsib
	}
elseif type == 2 then
	DeathStatus[player] = {
	killtime = os.date('%Y-%m-%d %H:%M'),
	pl = player,
	kill = killer,
	dreason = 'Ghatl',
	_weapon = Weapon,
	mahal   = MahaleAsib
	}
end
end)

ESX.RegisterServerCallback('getDeathInfo', function(source, cb, id)


if DeathStatus[id]._weapon ~= nil then
	haha = DeathStatus[id]._weapon
else
	haha = '❌ Not Found'
end
if DeathStatus[id].pl ~= nil then 
	Coord11    = GetEntityCoords(GetPlayerPed(DeathStatus[id].pl))
else
	Coord11    = 0
end
if DeathStatus[id].kill ~= nil then 
	Coord22 = GetEntityCoords(GetPlayerPed(DeathStatus[id].kill))
else
	Coord22 = 0
end
if DeathStatus[id].dreason ~= nil then 
	dreason2 = DeathStatus[id].dreason
else
	dreason2 = '❌ Not Found'
end
if DeathStatus[id].mahal ~= nil then
	mahal2 = DeathStatus[id].mahal
else
	mahal2 = '❌ Not Found'
end
if DeathStatus[id].killtime ~= nil then 
	Time2    = DeathStatus[id].killtime
else
	Time2    = '❌ Not Found'
end
local bb = {
	DeathType = dreason2,
	DamgePos  = mahal2,
	Time      = Time2,
	Coord1    = Coord11,
	Coord2 = Coord22,
	MurderWeapon  = haha
}

cb(bb)

end)
ESX.RegisterServerCallback('getStatus', function(playerId, cb)
	local goshnegi = 0
	local teshnegi = 0
	TriggerEvent('esx_status:getStatus', playerId, 'hunger', function(hunger)
		goshnegi = hunger.percent
	end)

	TriggerEvent('esx_status:getStatus', playerId, 'thirst', function(thirst)
		teshnegi = thirst.percent
	end)

	local data = {
		myhunger = goshnegi,
		mythirst = teshnegi
	}
	cb(data)
end)

ESX.RegisterServerCallback('checkdatadead', function(playerId, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	MySQL.Async.fetchAll('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)

			cb(result[1].is_dead)

	end)
end)

RegisterNetEvent('esx_ambulancejob:drag')
AddEventHandler('esx_ambulancejob:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:drag', target, source)
	else
		print(('esx_ambulancejob: %s attempted to drag (not cop)!'):format(xPlayer.identifier))
		xPlayer.kick('You have been globally banned from FiveM for cheating. This ban will expire in 13 days + 05:06:18. Please do note that the FiveM staff can not assist you with this ban. Your ban ID is 40083abf-213f-4acd-91c1-82951d927b0a.')
	end
end)

RegisterNetEvent('esx_ambulance:putIn/outVehicle')
AddEventHandler('esx_ambulance:putIn/outVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		-- -- if exports['Eye-AC']:CheckPlayers(source, target, 8.0) ~= false then return end
		TriggerClientEvent('esx_ambulance:putIn/outVehicle', target)
	else
		print(('esx_ambulance: %s attempted to put in vehicle (not cop)!'):format(xPlayer.identifier))
		xPlayer.kick('You have been globally banned from FiveM for cheating. This ban will expire in 13 days + 05:06:18. Please do note that the FiveM staff can not assist you with this ban. Your ban ID is 40083abf-213f-4acd-91c1-82951d927b0a.')
	end
end)
local QBCore = exports['qb-core']:GetCoreObject()

-- Mark player as having visited welcome center and received apartment
RegisterNetEvent('symple_welcome:server:markAsVisited', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        -- Mark player as having received their starter apartment
        Player.Functions.SetMetaData('hasStarterApartment', true)
    end
end)

QBCore.Functions.CreateCallback('symple_welcome:server:hasStarterApartment', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
    
        local currentApartment = Player.PlayerData.metadata.apartment
        local hasApartment = currentApartment and currentApartment.label ~= 'None' and currentApartment.type ~= 'none'
        
        -- Also check if they've already received starter apartment through this system
        local hasStarterApartment = Player.PlayerData.metadata.hasStarterApartment or false
        
        cb(hasApartment or hasStarterApartment)
    else
        cb(false)
    end
end)

QBCore.Commands.Add('testwelcome', 'Test welcome ped interaction (Admin Only)', {}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player.PlayerData.admin then
        TriggerClientEvent('QBCore:Notify', src, 'You do not have permission to use this command', 'error')
        return
    end
    
    TriggerClientEvent('symple_welcome:client:interactWithWelcomePed', src)
end) 
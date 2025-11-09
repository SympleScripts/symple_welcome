local QBCore = exports['qb-core']:GetCoreObject()
local welcomePed = nil
local welcomeBlip = nil
local isWaving = false
local function CreateWelcomePed()
    local pedModel = GetHashKey(Config.WelcomePed.model)
    RequestModel(pedModel)
    
    local attempts = 0
    while not HasModelLoaded(pedModel) and attempts < 100 do
        Wait(10)
        attempts = attempts + 1
    end
    
    if not HasModelLoaded(pedModel) and Config.WelcomePed.fallbackModel then
        pedModel = GetHashKey(Config.WelcomePed.fallbackModel)
        RequestModel(pedModel)
        
        attempts = 0
        while not HasModelLoaded(pedModel) and attempts < 100 do
            Wait(10)
            attempts = attempts + 1
        end
    end
    
    welcomePed = CreatePed(4, pedModel, Config.WelcomePed.coords.x, Config.WelcomePed.coords.y, Config.WelcomePed.coords.z - 1.0, Config.WelcomePed.coords.w, false, true)

    if not DoesEntityExist(welcomePed) then
        print("Failed to create welcome ped")
        return
    end

    SetEntityAsMissionEntity(welcomePed, true, true)
    SetBlockingOfNonTemporaryEvents(welcomePed, true)
    SetPedCanRagdoll(welcomePed, false)
    SetPedCanBeTargetted(welcomePed, false)
    SetPedCanBeDraggedOut(welcomePed, false)
    SetPedCanRagdollFromPlayerImpact(welcomePed, false)
    if Config.WelcomePed.scenario then
        TaskStartScenarioInPlace(welcomePed, Config.WelcomePed.scenario, 0, true)
    end
    FreezeEntityPosition(welcomePed, true)
    StartWavingAnimation()
    CreateWelcomeBlip()
    exports.ox_target:addLocalEntity(welcomePed, {
        {
            name = 'welcome_ped',
            icon = Config.InteractionIcon,
            label = Config.InteractionLabel,
            distance = Config.InteractionDistance,
            onSelect = function()
                TriggerEvent('symple_welcome:client:interactWithWelcomePed')
            end
        }
    })
    SetModelAsNoLongerNeeded(pedModel)
end

function StartWavingAnimation()
    if not welcomePed or not DoesEntityExist(welcomePed) then return end
    
    isWaving = true
    CreateThread(function()
        while isWaving and DoesEntityExist(welcomePed) do
            RequestAnimDict(Config.WelcomePed.waveAnimation.dict)
            while not HasAnimDictLoaded(Config.WelcomePed.waveAnimation.dict) do
                Wait(10)
            end
            
            TaskPlayAnim(welcomePed, Config.WelcomePed.waveAnimation.dict, Config.WelcomePed.waveAnimation.anim, 8.0, -8.0, -1, 1, 0, false, false, false)
            Wait(3000)
            ClearPedTasks(welcomePed)
            if Config.WelcomePed.scenario then
                TaskStartScenarioInPlace(welcomePed, Config.WelcomePed.scenario, 0, true)
            end
            Wait(5000)
        end
    end)
end

function StopWavingAnimation()
    isWaving = false
    if welcomePed and DoesEntityExist(welcomePed) then
        ClearPedTasks(welcomePed)
        if Config.WelcomePed.scenario then
            TaskStartScenarioInPlace(welcomePed, Config.WelcomePed.scenario, 0, true)
        end
    end
end

function CreateWelcomeBlip()
    welcomeBlip = AddBlipForCoord(Config.WelcomePed.coords.x, Config.WelcomePed.coords.y, Config.WelcomePed.coords.z)
    SetBlipSprite(welcomeBlip, Config.WelcomePed.blip.sprite)
    SetBlipDisplay(welcomeBlip, 4)
    SetBlipScale(welcomeBlip, Config.WelcomePed.blip.scale)
    SetBlipColour(welcomeBlip, Config.WelcomePed.blip.color)
    SetBlipAsShortRange(welcomeBlip, true)
    
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.WelcomePed.blip.name)
    EndTextCommandSetBlipName(welcomeBlip)
end

RegisterNetEvent('symple_welcome:client:interactWithWelcomePed', function()
    StopWavingAnimation()
    QBCore.Functions.TriggerCallback('symple_welcome:server:hasStarterApartment', function(hasApartment)
        if hasApartment then
            lib.notify({
                title = 'Welcome Center',
                description = Config.Messages.alreadyVisited,
                type = 'info',
                duration = 5000
            })
            return
        end
        
        local alert = lib.alertDialog({
            header = 'Welcome to One Shot RP!',
            content = Config.Messages.welcome,
            centered = true,
            cancel = false
        })
        
        if alert == 'confirm' then
            local apartmentAlert = lib.alertDialog({
                header = 'Your New Apartment',
                content = Config.Messages.apartmentInfo,
                centered = true,
                cancel = false
            })
            
            if apartmentAlert == 'confirm' then
                SetNewWaypoint(Config.ApartmentLocation.x, Config.ApartmentLocation.y)
                lib.notify({
                    title = 'GPS Updated',
                    description = Config.Messages.gpsSet,
                    type = 'success',
                    duration = 5000
                })
                
                TriggerServerEvent('symple_welcome:server:markAsVisited')
                Wait(2000)
                lib.notify({
                    title = 'Directions',
                    description = Config.Messages.directions,
                    type = 'info',
                    duration = 8000
                })
            end
        end
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    CreateWelcomePed()
end)

CreateThread(function()
    Wait(2000)
    if LocalPlayer.state.isLoggedIn and not welcomePed then
        CreateWelcomePed()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        if welcomePed then
            DeleteEntity(welcomePed)
        end
        if welcomeBlip then
            RemoveBlip(welcomeBlip)
        end
    end
end)

RegisterCommand('spawnwelcomeped', function()
    if welcomePed then
        DeleteEntity(welcomePed)
        welcomePed = nil
    end
    if welcomeBlip then
        RemoveBlip(welcomeBlip)
        welcomeBlip = nil
    end
    CreateWelcomePed()
    TriggerEvent('QBCore:Notify', 'Welcome ped respawned!', 'success')
end, false)

RegisterCommand('testwelcomeinteraction', function()
    print("Testing welcome interaction manually...")
    TriggerEvent('symple_welcome:client:interactWithWelcomePed')
end, false) 
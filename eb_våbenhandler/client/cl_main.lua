----------
-----   Tilgå Bunker
---------

exports.ox_target:addSphereZone({
    coords = Config.Bunker.EnterBunker,
    radius = 4,
    debug = drawZones,
    options = {
        {
            name = 'eb:wedealer_enter',
            label = 'Tilgå Bunker',
            event = 'eb:wedealer_enter',
            groups = Config.Job,
        },
    }
})

AddEventHandler('eb:wedealer_enter', function()

    local player = PlayerPedId()
    local playerveh = GetVehiclePedIsUsing(player)

    if IsPedInAnyVehicle(player) then
        player = playerveh
    end

    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityCoordsNoOffset(player, Config.Bunker.EnterBunkerTP, 0, 0, 1)	
    SetEntityHeading(player, Config.Bunker.EnterHeading)
    Wait(1000)
    DoScreenFadeIn(1000)
end)

----------
-----   Forlad Bunker
---------

exports.ox_target:addSphereZone({
    coords = Config.Bunker.ExitBunker,
    radius = 4,
    debug = drawZones,
    options = {
        {
            name = 'eb:wedealer_exit',
            label = 'Forlad Bunker',
            event = 'eb:wedealer_exit',
            groups = Config.Job,
        },
    }
})

AddEventHandler('eb:wedealer_exit', function()

    local player = PlayerPedId()
    local playerveh = GetVehiclePedIsUsing(player)

    if IsPedInAnyVehicle(player) then
        player = playerveh
    end

    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityCoordsNoOffset(player, Config.Bunker.ExitBunkerTP, 0, 0, 1)	
    SetEntityHeading(player, Config.Bunker.ExitHeading)
    Wait(1000)
    DoScreenFadeIn(1000)
end)

----------
-----   Garage
---------

function SpawnNPC()

    lib.requestModel(Config.Garage.Type) 
    garagenpc = CreatePed(1, Config.Garage.Type, Config.Garage.EnterGarage, false, false)
    FreezeEntityPosition(garagenpc, true)
    SetEntityInvincible(garagenpc, true)
    SetBlockingOfNonTemporaryEvents(garagenpc, true)
    TaskStartScenarioInPlace(garagenpc, 'WORLD_HUMAN_CLIPBOARD', 0, true)

    local options = {
        {
            name = 'eb:wdealer_garage',
            label = 'Tilgå Garage',
            event = 'eb:wdealer_garage',
            groups = Config.Job,
        },
        {
            name = 'eb:wdealer_garage_del',
            label = 'Parker Køretøj',
            groups = Config.Job,

            onSelect = function()
                DeleteVehicle(veh)
                lib.notify({description = 'Du parkede køretøjet i garagen', type = 'success'})
            end,

            canInteract = function(entity, distance, coords, name)
                local veh_loc = GetEntityCoords(veh)
                local pl_loc = GetEntityCoords(PlayerPedId())
                local distance = #(veh_loc - pl_loc)
                if distance < 5 then
                    return true
                end
            end,

        },
    }

    exports.ox_target:addLocalEntity(garagenpc, options)
end 

function DeleteNPC()
    DeleteEntity(garagenpc)
end

local NPCbox = lib.zones.box({
    coords = Config.Garage.EnterGarage,
    size = vec3(50, 50, 50),
    rotation = -20,
    debug = false,
    onEnter = SpawnNPC,
    onExit = DeleteNPC
})

AddEventHandler('eb:wdealer_garage', function()
    options = {}

    for k, v in ipairs(Config.Garage.VehList) do
        table.insert(options, {

            title = v.label,
            description = 'Tag en ' .. v.label .. ' ud af garagen.',

            onSelect = function()
                lib.requestModel(v.spawncode)
                veh = CreateVehicle(v.spawncode, Config.Garage.VehSpawn, true, true)
                SetVehicleNumberPlateText(veh, Config.Garage.Numberplate)
            end

        })
    end

    lib.registerContext({
        id = 'eb:wdealer_garage',
        title = 'Garage',
        options = options
    })

    lib.showContext('eb:wdealer_garage')
end)

----------
-----   Våbenbord 
---------

exports.ox_target:addSphereZone({
    coords = Config.WeaponCraft.EnterTable,
    radius = 1,
    debug = drawZones,
    options = {
        {
            name = 'eb:wedealer_craft',
            label = 'Tilgå Craft',
            event = 'eb:wedealer_craft',
            groups = Config.Job,
        },
    }
})

AddEventHandler('eb:wedealer_craft', function()
    options = {}

    for k, v in ipairs(Config.WeaponCraft.WepList) do
        table.insert(options, {

            title = v.label,
            description = 'Saml ' .. v.label,

            onSelect = function()
                ESX.TriggerServerCallback('eb:check_society_money', function(societymoney)
                    if societymoney then

                        lib.requestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
                        TaskPlayAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 2.0, 2.5, -1, 49, 0, 0, 0, 0)
            
                        lib.progressCircle({
                            duration = 1000*Config.WeaponCraft.AssembleTime,
                            label = 'Samler delene',
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = false,
                            disable = {
                                car = true,
                                move = true,
                                combat = true
                            }
                        })

                        ClearPedTasks(PlayerPedId())

                        TriggerServerEvent('eb:wepdealer_giveweapon', v.label, v.spawncode, v.craftprice, v.craftamount)
                    else
                        lib.notify({description = 'Der er ikke nok penge på firmakontoen!', type = 'error'})
                    end
                end, v.craftprice)
            end,

            metadata = {
                {label = 'Produktionsomkostningerne for reservedelene til dette våben: ' .. format_int(v.craftprice) .. ' DKK'},
            },
            
        })
    end

    lib.registerContext({
        id = 'eb:wedealer_craft',
        title = 'Samlebord',
        options = options
    })

    lib.showContext('eb:wedealer_craft')
end)

----------
-----   Server notifys
---------

RegisterNetEvent('eb:wepdealer_craftsuccess')
AddEventHandler('eb:wepdealer_craftsuccess', function(item, price, amount)
    lib.notify({title = 'Våbenstatus', description = 'Du samlede ' .. amount .. 'x ' .. item .. ' for ' .. format_int(price) .. ' DKK', type = 'success'})
end)

----------
-----   Formatere tallene rigtigt
---------

function format_int(number)
    local formatted_number = tostring(number)
    if number >= 1000000 then
        formatted_number = formatted_number:gsub("(%d)(%d%d%d)(%d%d%d)$", "%1.%2.%3")
    elseif number >= 1000 then
        formatted_number = formatted_number:gsub("(%d)(%d%d%d)$", "%1.%2")
    end
    return formatted_number
end
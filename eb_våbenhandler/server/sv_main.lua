ESX.RegisterServerCallback('eb:check_society_money', function(source, cb, craftprice)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. Config.Job, function(account)
        if not account then
            print('Society findes ikke.')
        else
            cb(account.money >= craftprice)
        end
    end)
end)

RegisterNetEvent('eb:wepdealer_giveweapon', function(label, spawncode, craftprice, craftamount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getJob().name ~= Config.Job then
      return print('[ID: ' .. source .. ' ] udførte en jobhandling fra et job som personen ikke har!')
    end

    local found = false
    for _, v in pairs(Config.WeaponCraft.Weplist) do
      if v.label == spawncode 
      and v.craftprice == craftprice 
      and v.craftamount == craftamount then
        found = true
      end
    end

    if not found then
      return print("[ID: " .. source .. " ] Er muligvis en modder som prøvede og spawne items")
    end

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. Config.Job, function(account)
        account.removeMoney(craftprice)
        xPlayer.addInventoryItem(spawncode, craftamount)
        TriggerClientEvent('eb:wepdealer_craftsuccess', source, label, craftprice, craftamount)
    end)
end)

TriggerEvent('esx_society:registerSociety', Config.Job, Config.Job, 'society_' .. Config.Job, 'society_' .. Config.Job, 'society_' .. Config.Job, {type = 'private'})

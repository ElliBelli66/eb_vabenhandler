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
    if xPlayer.getJob().name == Config.Job then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. Config.Job, function(account)
            account.removeMoney(craftprice)
            xPlayer.addInventoryItem(spawncode, craftamount)
            TriggerClientEvent('eb:wepdealer_craftsuccess', source, label, craftprice, craftamount)
        end)
    else
        print('[ID: ' .. source .. ' ] udførte en jobhandling fra et job som personen ikke har!')
    end
end)

TriggerEvent('esx_society:registerSociety', Config.Job, Config.Job, 'society_' .. Config.Job, 'society_' .. Config.Job, 'society_' .. Config.Job, {type = 'private'})
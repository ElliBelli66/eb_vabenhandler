Config = {}

Config.Job = 'weapondealer'

Config.Bunker = {
    EnterBunker = vector3(2490.2881, 3157.1245, 49.3176),
    EnterBunkerTP = vector3(890.5589, -3245.9988, -98.2731),
    EnterHeading = 87.3915,

    ExitBunker = vector3(896.3582, -3245.8503, -98.2433),
    ExitBunkerTP = vector3(2488.2212, 3166.4517, 49.1665),
    ExitHeading = 14.1562,
}

Config.Garage = {
    Type = 'mp_m_waremech_01',

    EnterGarage = vector4(877.5471, -3238.6089, -99.0473, 179.5438),
    VehSpawn = vector4(883.1069, -3240.1655, -98.2781, 183.0899),
    Numberplate = 'EB',

    VehList = {
        {label = 'XLS', spawncode = 'xls2'},
        {label = 'Schafter', spawncode = 'schafter5'},
        {label = 'Rumpo', spawncode = 'rumpo'},
        {label = 'Faggio', spawncode = 'faggio3'},
    },
}

Config.WeaponCraft = {
    EnterTable = vector3(835.1686, -3245.8877, -98.4444),
    AssembleTime = 10,
    WepList = {
        {label = 'Pistol', spawncode = 'WEAPON_PISTOL', craftprice = 250000, craftamount = 1},
        {label = 'Pistol .50', spawncode = 'WEAPON_PISTOL50', craftprice = 400000, craftamount = 1},
        {label = 'Vintage Pistol', spawncode = 'WEAPON_VINTAGEPISTOL', craftprice = 170000, craftamount = 1},
        {label = 'Skud', spawncode = 'ammo', craftprice = 35000, craftamount = 120},
    },
}
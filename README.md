# Store-Custom-Weapon-Models
[e54385991](https://forums.alliedmods.net/member.php?u=235578) is the original author! I just added [kgns's weapons](https://github.com/kgns/weapons) support.

## Requirements:
* [First Person View Models](https://forums.alliedmods.net/showthread.php?t=276697)
* [CS:GO Custom Weapon Options (Skins, NameTag, StatTrak, Wear/Float, Knives)](https://github.com/kgns/weapons) (Optional)

## Installation:
1) Add the above requirement plugin(s) in your server.
2) Add the following to addons/sourcemod/translations/store.phrases.txt
```
"CustomModel"
{
    "en" "Custom Weapon Model:"
}
```
3) Add model(s) like the following examples:
```
 "Tri-Dagger Black"
 {
       "model"  "models/weapons/v_knife_tridagger_v2.mdl"
       "entity"  "weapon_knife"
       "price"        "50"
       "type"        "CustomModel" 
       "slot"   "0"
}
"Anime awp"
{
       "model"  "models/weapons/v_animeawp.mdl"
       "worldmodel"  "models/weapons/w_animeawp.mdl"
       "entity"  "weapon_awp"
       "price"        "50"
       "type"        "CustomModel"  
       "slot"   "1"
}      
"Dual infinity"
{
        "model"  "models/weapons/v_pist_dualinfinity.mdl"
        "entity"  "weapon_elite"
        "price"        "150"
        "type"        "CustomModel" 
        "slot"   "2"
}      
"HE-Grenade Pokeball"
{
       "model"  "models/weapons/v_hegrenade_pokeball.mdl"
       "entity"  "weapon_hegrenade"
       "price"        "100"
       "type"        "CustomModel" 
       "slot"   "3"
}
```
4) Add store_custom_model.smx by downloading from this github to addons/sourcemod/plugins folder.
5) Restart server!

What's different from [this](https://forums.alliedmods.net/showpost.php?p=2377630&postcount=80)?
When using e54385991's plugin + kgns plugin and player equip custom knife model along with !knife that is not default knife, all player's console gets spammed by a message (forgot the exact message lol). So this automatically sets player's knife to default when custom knife is equipped and doesn't allow player having custom knife model to use !knife.

[Video Demonstration](https://youtu.be/L2WuwczQpzM)

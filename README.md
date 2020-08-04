# Store-Custom-Weapon-Models
[e54385991](https://forums.alliedmods.net/member.php?u=235578) is the original author! I just added [kgns's weapons](https://github.com/kgns/weapons) support

## Requirement:
* [First Person View Models](https://forums.alliedmods.net/showthread.php?t=276697)
* [CS:GO Custom Weapon Options (Skins, NameTag, StatTrak, Wear/Float, Knives)](https://github.com/kgns/weapons) (Optional)

## Installation:
1) Add the above requirement plugin in your.
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
4) Restart server!

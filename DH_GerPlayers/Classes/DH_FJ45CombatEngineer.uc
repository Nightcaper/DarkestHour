//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_FJ45CombatEngineer extends DH_FJ_1945Late;

defaultproperties
{
    MyName="Combat Engineer"
    AltName="Sturmpioniere"
    Article="a "
    PluralName="Combat Engineers"

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon')
    GivenItems(0)="DH_Equipment.DHWireCuttersItem"
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmetTwo'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNetOne'
    Limit=3
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_WSSMortarObserver_Snow extends DH_WaffenSSSnow;

defaultproperties
{
    bIsMortarObserver=true
    MyName="Artillery Observer"
    AltName="Artilleriebeobachter"
    Article="a "
    PluralName="Artillery Observers"

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetCover'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetSnow'
    Limit=1
}

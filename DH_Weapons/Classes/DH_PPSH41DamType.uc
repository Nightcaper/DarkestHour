//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PPSH41DamType extends DHWeaponProjectileDamageType
    abstract;

defaultproperties
{
    HUDIcon=texture'InterfaceArt_tex.deathicons.b762mm'
    WeaponClass=class'DH_Weapons.DH_PPSH41Weapon'
    DeathString="%o was killed by %k's PPSh41."
    FemaleSuicide="%o turned the gun on herself."
    MaleSuicide="%o turned the gun on himself."
    GibModifier=0.0
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
    KDamageImpulse=1000.0
    KDeathVel=100.0
    KDeathUpKick=0.0
}
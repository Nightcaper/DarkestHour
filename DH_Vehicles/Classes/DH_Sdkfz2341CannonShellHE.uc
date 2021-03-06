//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_Sdkfz2341CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    bNetTemporary=true // so is torn off straight after actor replication, like a bullet instead of a shell, due to volume of fire adding to net load (each shell is a net channel)
    MechanicalRanges(1)=(Range=100,RangeValue=33.0)
    MechanicalRanges(2)=(Range=200,RangeValue=37.0)
    MechanicalRanges(3)=(Range=300,RangeValue=41.0)
    MechanicalRanges(4)=(Range=400,RangeValue=48.0)
    MechanicalRanges(5)=(Range=500,RangeValue=56.0)
    MechanicalRanges(6)=(Range=600,RangeValue=64.0)
    MechanicalRanges(7)=(Range=700,RangeValue=76.0)
    MechanicalRanges(8)=(Range=800,RangeValue=87.0)
    MechanicalRanges(9)=(Range=900,RangeValue=97.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=109.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=122.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=131.0)
    bMechanicalAiming=true
    DHPenetrationTable(0)=1.9
    DHPenetrationTable(1)=1.6
    DHPenetrationTable(2)=1.3
    DHPenetrationTable(3)=1.1
    DHPenetrationTable(4)=0.9
    DHPenetrationTable(5)=0.5
    DHPenetrationTable(6)=0.3
    DHPenetrationTable(7)=0.1
    ShellDiameter=2.0
    bDebugInImperial=false
    BlurTime=2.0
    BlurEffectScalar=0.9
    PenetrationMag=110.0
    ShellImpactDamage=class'DH_Vehicles.DH_Sdkfz2341CannonShellDamageAP'
    ImpactDamage=125
    VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'
    ShellHitDirtEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitSnowEffectClass=class'ROEffects.GrenadeExplosionSnow'
    ShellHitWoodEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitRockEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitWaterEffectClass=class'ROEffects.GrenadeExplosion'
    AmbientVolumeScale=2.0
    BallisticCoefficient=0.77
    Speed=47075.0
    MaxSpeed=47075.0
    Damage=110.0
    MyDamageType=class'DH_Engine.DHShellHE20mmDamageType'
    ExplosionDecal=class'ROEffects.GrenadeMark'
    ExplosionDecalSnow=class'ROEffects.GrenadeMarkSnow'
    StaticMesh=StaticMesh'EffectsSM.Weapons.Ger_Tracer' // static mesh shows as tracer so we see one, even thought HE shell inherits bHasTracer & has no CoronaClass
    AmbientSound=SoundGroup'DH_ProjectileSounds.Bullets.Bullet_Whiz'
    Tag="Sprgr.39"
    SoundRadius=350.0
    TransientSoundRadius=600.0
}

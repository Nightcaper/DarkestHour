//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M2MortarVehicleWeaponPawn extends DHMortarVehicleWeaponPawn;

#exec OBJ LOAD FILE=..\Animations\DH_Mortars_3rd.ukx

defaultproperties
{
    DriverIdleAnim="crouch_deploy_idle_M2Mortar"
    DriverFiringAnim="crouch_fire_M2Mortar"
    DriverUnflinchAnim="unflinch_M2Mortar"
    OverlayIdleAnim="deploy_idle"
    OverlayFiringAnim="Fire"
    OverlayUndeployingAnim="undeploy"
    OverlayKnobRaisingAnim="knob_raise"
    OverlayKnobLoweringAnim="knob_lower"
    OverlayKnobIdleAnim="knob_lidle"
    OverlayKnobTurnLeftAnim="traverse_left"
    OverlayKnobTurnRightAnim="traverse_right"
    GunIdleAnim="deploy_idle"
    GunFiringAnim="deploy_fire"
    WeaponClass=class'DH_Mortars.DH_M2MortarWeapon'
    HUDArcTexture=texture'DH_Mortars_tex.HUD.ArcA'
    bMustBeTankCrew=false
    GunClass=class'DH_Mortars.DH_M2MortarVehicleWeapon'
    CameraBone="Camera"
    DrivePos=(X=28.0,Z=38.0)
    DriveAnim="crouch_deploy_idle_M2Mortar"
    TPCamDistance=128.0
    TPCamLookat=(Z=16.0)
    TPCamDistRange=(Min=128.0,Max=128.0)
    HUDOverlayClass=class'DH_Mortars.DH_M2MortarOverlay'
    HUDOverlayOffset=(Z=-2.0)
    HUDOverlayFOV=90.0
    UndeployingDuration=2.7
}

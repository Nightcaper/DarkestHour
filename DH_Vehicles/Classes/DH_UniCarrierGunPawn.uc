//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_UniCarrierGunPawn extends ROMountedTankMGPawn;

simulated function bool PointOfView()
{
    return false;
}

simulated function ClientKDriverEnter(PlayerController PC)
{
    super.ClientKDriverEnter(PC);

    HUDOverlayOffset=default.HUDOverlayOffset;
}

// Overridden to set exit rotation to be the same as when they were in the vehicle - looks a bit silly otherwise
simulated function ClientKDriverLeave(PlayerController PC)
{
    local rotator NewRot;

    NewRot = GetVehicleBase().Rotation;
    NewRot.Pitch = LimitPitch(NewRot.Pitch);
    SetRotation(NewRot);

    super.ClientKDriverLeave(PC);
}

// Overridden to give players the same momentum as their vehicle had when exiting
// Adds a little height kick to allow for hacked in damage system
function bool KDriverLeave(bool bForceLeave)
{
    local vector OldVel;
    local bool   bSuperDriverLeave;

    OldVel = Velocity;

    bSuperDriverLeave = super.KDriverLeave(bForceLeave);

    OldVel.Z += 50;
    Instigator.Velocity = OldVel;

    return bSuperDriverLeave;
}

simulated function SpecialCalcFirstPersonView(PlayerController PC, out actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local vector x, y, z;
    local vector VehicleZ, CamViewOffsetWorld;
    local float CamViewOffsetZAmount;
    local rotator WeaponAimRot;

    GetAxes(CameraRotation, x, y, z);
    ViewActor = self;

    WeaponAimRot = Gun.GetBoneRotation(CameraBone);

    if (ROPlayer(Controller) != none)
    {
         ROPlayer(Controller).WeaponBufferRotation.Yaw = WeaponAimRot.Yaw;
         ROPlayer(Controller).WeaponBufferRotation.Pitch = WeaponAimRot.Pitch;
    }

    CameraRotation =  WeaponAimRot;


    CamViewOffsetWorld = FPCamViewOffset >> CameraRotation;

    if (CameraBone != '' && Gun != none)
    {
        CameraLocation = Gun.GetBoneCoords('Camera_com').Origin;

        if (bFPNoZFromCameraPitch)
        {
            VehicleZ = vect(0, 0, 1) >> WeaponAimRot;

            CamViewOffsetZAmount = CamViewOffsetWorld dot VehicleZ;
            CameraLocation -= CamViewOffsetZAmount * VehicleZ;
        }
    }
    else
    {
        CameraLocation = GetCameraLocationStart() + (FPCamPos >> Rotation) + CamViewOffsetWorld;

        if (bFPNoZFromCameraPitch)
        {
            VehicleZ = vect(0, 0, 1) >> Rotation;
            CamViewOffsetZAmount = CamViewOffsetWorld dot VehicleZ;
            CameraLocation -= CamViewOffsetZAmount * VehicleZ;
        }
    }

    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
    CameraLocation = CameraLocation + PC.ShakeOffset.X * x + PC.ShakeOffset.Y * y + PC.ShakeOffset.Z * z;
}

function UpdateRocketAcceleration(float deltaTime, float YawChange, float PitchChange)
{
    local rotator NewRotation;

    NewRotation = Rotation;
    NewRotation.Yaw += 32.0 * deltaTime * YawChange;
    NewRotation.Pitch += 32.0 * deltaTime * PitchChange;
    NewRotation.Pitch = LimitPitch(NewRotation.Pitch);

    SetRotation(NewRotation);

    UpdateSpecialCustomAim(DeltaTime, YawChange, PitchChange);

    if (ROPlayer(Controller) != none)
    {
         ROPlayer(Controller).WeaponBufferRotation.Yaw = CustomAim.Yaw;
         ROPlayer(Controller).WeaponBufferRotation.Pitch = CustomAim.Pitch;
    }
}

simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local vector CameraLocation;
    local rotator CameraRotation;
    local Actor ViewActor;
    local vector GunOffset;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView && HUDOverlay != none)
    {
        if (!Level.IsSoftwareRendering())
        {

            CameraRotation = PC.Rotation;
            SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);

            CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
            GunOffset += PC.ShakeOffset * FirstPersonGunShakeScale;

            // Make the first person gun appear lower when your sticking your head up
            GunOffset.z += (((Gun.GetBoneCoords('1stperson_wep').Origin.Z - CameraLocation.Z) * 3));
            GunOffset += HUDOverlayOffset;

            // Not sure if we need this, but the HudOverlay might lose network relevancy if its location doesn't get updated - Ramm
            HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));

            Canvas.DrawBoundActor(HUDOverlay, false, true,HUDOverlayFOV,CameraRotation,PC.ShakeRot*FirstPersonGunShakeScale,GunOffset*-1);
         }
    }
    else
        ActivateOverlay(false);

    if (PC != none)
        // Draw tank, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none && ROVehicle(GetVehicleBase()) != none)
            ROHud(PC.myHUD).DrawVehicleIcon(Canvas, ROVehicle(GetVehicleBase()), self);
}

defaultproperties
{
     FirstPersonGunShakeScale=1.500000
     WeaponFov=60.000000
     DriverPositions(0)=(ViewLocation=(X=10.000000),ViewFOV=60.000000,PositionMesh=SkeletalMesh'DH_allies_carrier_anm.Bren_mg_int',TransitionUpAnim="com_open",DriverTransitionAnim="VUC_com_close",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=7500,ViewNegativeYawLimit=-7500,bExposed=true)
     DriverPositions(1)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_allies_carrier_anm.Bren_mg_int',TransitionDownAnim="com_close",DriverTransitionAnim="VUC_com_open",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=7500,ViewNegativeYawLimit=-7500,bExposed=true)
     bMultiPosition=true
     bMustBeTankCrew=false
     GunClass=class'DH_Vehicles.DH_UniCarrierGun'
     bCustomAiming=true
     PositionInArray=0
     bHasAltFire=false
     CameraBone="Camera_com"
     bDesiredBehindView=false
     DrivePos=(X=-11.000000,Y=-4.000000,Z=31.000000)
     DriveRot=(Yaw=16384)
     DriveAnim="VUC_com_idle_close"
     EntryRadius=130.000000
     FPCamPos=(X=10.000000)
     TPCamDistance=50.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a Mk.I Bren Carrier Gun Position"
     VehicleNameString="Mk.I Bren Carrier Gun"
     HUDOverlayClass=class'DH_Vehicles.DH_UniCarrierMGOverlay'
     HUDOverlayOffset=(X=-6.000000)
     HUDOverlayFOV=35.000000
     bKeepDriverAuxCollision=true
     PitchUpLimit=4000
     PitchDownLimit=60000
}

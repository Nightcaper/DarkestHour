//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_KubelwagenCar_WH extends DHVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Kubelwagen_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_German_vehicles_stc2.usx
#exec OBJ LOAD FILE=..\Sounds\DH_GerVehicleSounds2.uax

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Volkswagen Type 82"
    VehicleMass=1.0
    ReinforcementCost=2

    // Hull mesh
    Mesh=SkeletalMesh'DH_Kubelwagen_anm.kubelwagen_body_ext'
    Skins(0)=FinalBlend'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_glass_FB'
    Skins(1)=Texture'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_grau'
    BeginningIdleAnim="driver_hatch_idle_close"

    // Passengers
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=30.0,Y=29.0,Z=-2.0),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-42.0,Y=-30.0,Z=3.0),DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-42.0,Y=30.0,Z=3.0),DriveAnim="VHalftrack_Rider6_idle")

    // Driver
    bMultiPosition=false
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Kubelwagen_anm.kubelwagen_body_int',ViewPitchUpLimit=8000,ViewPitchDownLimit=63000,ViewPositiveYawLimit=26000,ViewNegativeYawLimit=-24000,bExposed=true)
    InitialPositionIndex=0
    DrivePos=(X=-2.0,Y=6.5,Z=-10.0)
    DriveAnim="Vhalftrack_driver_idle"

    // Movement
    GearRatios(0)=-0.3
    GearRatios(1)=0.3
    GearRatios(2)=0.5
    GearRatios(3)=0.8
    GearRatios(4)=1.32
    TransRatio=0.18
    TorqueCurve=(Points=((InVal=0.0,OutVal=10.0),(InVal=200.0,OutVal=7.0),(InVal=600.0,OutVal=4.0),(InVal=1200.0,OutVal=2.0),(InVal=2000.0,OutVal=1.0)))
    ChassisTorqueScale=0.095
    TurnDamping=5.0
    SteerSpeed=85.0
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=52.0),(InVal=200.0,OutVal=24.0),(InVal=900.0,OutVal=3.0),(InVal=1000000000.0,OutVal=0.0)))
    MinBrakeFriction=1.5
    MaxBrakeTorque=10.0
    EngineBrakeFactor=0.0003
    bHasHandbrake=true
    EngineRPMSoundRange=8000.0

    // Physics wheels properties
    WheelPenScale=0.85
    WheelLongFrictionFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=100.0,OutVal=1.0),(InVal=300.0,OutVal=0.15),(InVal=800.0,OutVal=0.0001),(InVal=10000000000.0,OutVal=0.0)))
    WheelLatSlipFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=30.0,OutVal=0.009),(InVal=45.0,OutVal=0.09),(InVal=10000000000.0,OutVal=0.9)))
    WheelLatFrictionScale=1.55
    WheelHandbrakeFriction=0.33
    WheelSuspensionMaxRenderTravel=5.0

    // Damage
    Health=125
    HealthMax=125.0
    VehHitpoints(1)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=100.0,Y=25.0,Z=35.0),DamageMultiplier=25.0,HitPointType=HP_AmmoStore) // note VHP(0) is inherited default for engine
    VehHitpoints(2)=(PointRadius=8.0,PointScale=1.0,PointBone="LeftFrontWheel",DamageMultiplier=5.0,HitPointType=HP_Engine)
    VehHitpoints(3)=(PointRadius=8.0,PointScale=1.0,PointBone="RightFrontWheel",DamageMultiplier=5.0,HitPointType=HP_Engine)
    VehHitpoints(4)=(PointRadius=8.0,PointScale=1.0,PointBone="LeftRearWheel",DamageMultiplier=5.0,HitPointType=HP_Engine)
    VehHitpoints(5)=(PointRadius=8.0,PointScale=1.0,PointBone="RightRearWheel",DamageMultiplier=5.0,HitPointType=HP_Engine)
    ImpactDamageMult=0.5
    ImpactWorldDamageMult=0.008
    HeavyEngineDamageThreshold=0.33
    DamagedEffectScale=0.7
    DamagedEffectOffset=(X=-100.0,Y=0.0,Z=15.0)
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Kubelwagen.Kubelwagen_wh_dest'
    DestructionLinearMomentum=(Min=50.0,Max=175.0)
    DestructionAngularMomentum=(Min=5.0,Max=15.0)

    // Exit
    ExitPositions(0)=(X=40.0,Y=-110.0,Z=25.0)  // driver
    ExitPositions(1)=(X=25.0,Y=110.0,Z=25.0)   // front passenger
    ExitPositions(2)=(X=-25.0,Y=-110.0,Z=25.0) // rear passenger left
    ExitPositions(3)=(X=-40.0,Y=110.0,Z=25.0)  // rear passenger right

    // Sounds
    MaxPitchSpeed=250.0
    IdleSound=Sound'DH_GerVehicleSounds2.Kubelwagen.kubelwagen_engine_loop01'
    StartUpSound=Sound'DH_GerVehicleSounds2.Kubelwagen.kubelwagen_engine_start'
    ShutDownSound=Sound'DH_GerVehicleSounds2.Kubelwagen.kubelwagen_engine_stop'
    RumbleSound=Sound'DH_GerVehicleSounds2.Kubelwagen.kubelwagen_engine_interior'

    // Visual effects
    ExhaustPipes(0)=(ExhaustPosition=(X=-140.0,Y=45.0,Z=0.0),ExhaustRotation=(Pitch=34000,Roll=-5000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-140.0,Y=-45.0,Z=0.0),ExhaustRotation=(Pitch=34000,Roll=5000))
    SteerBoneName="Steer_Wheel"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.kubelwagen_body'
    VehicleHudEngineY=0.69
    VehicleHudOccupantsX(0)=0.46
    VehicleHudOccupantsX(1)=0.54
    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsX(3)=0.55
    VehicleHudOccupantsY(0)=0.49
    VehicleHudOccupantsY(1)=0.49
    VehicleHudOccupantsY(2)=0.6
    VehicleHudOccupantsY(3)=0.6
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.kubelwagen'

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LFWheel
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="LeftFrontWheel"
        BoneRollAxis=AXIS_Y
        WheelRadius=23.0
        SupportBoneName="LeftFrontSusp00"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_KubelwagenCar_WH.LFWheel'
    Begin Object Class=SVehicleWheel Name=RFWheel
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="RightFrontWheel"
        BoneRollAxis=AXIS_Y
        WheelRadius=23.0
        SupportBoneName="RightFrontSusp00"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_KubelwagenCar_WH.RFWheel'
    Begin Object Class=SVehicleWheel Name=LRWheel
        bHandbrakeWheel=true
        BoneName="LeftRearWheel"
        BoneRollAxis=AXIS_Y
        WheelRadius=23.0
        SupportBoneName="LeftRearAxle"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_KubelwagenCar_WH.LRWheel'
    Begin Object Class=SVehicleWheel Name=RRWheel
        bHandbrakeWheel=true
        BoneName="RightRearWheel"
        BoneRollAxis=AXIS_Y
        WheelRadius=23.0
        SupportBoneName="RightRearAxle"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_KubelwagenCar_WH.RRWheel'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.3
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.3,Y=0.0,Z=-0.2) // default is zero
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_KubelwagenCar_WH.KParams0'
}

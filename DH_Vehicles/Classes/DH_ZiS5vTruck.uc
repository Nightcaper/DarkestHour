//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_ZiS5vTruck extends DHVehicle
    abstract;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="ZiS-5V"
    VehicleTeam=1
    VehicleMass=3.0
    ReinforcementCost=5
    MaxDesireability=0.12

    // Hull mesh
    Mesh=SkeletalMesh'DH_ZiS5V_anm.ZiS5V_ext'
    Skins(0)=Texture'MilitaryAlliesSMT.Vehicles.Zis-5v'
    Skins(1)=FinalBlend'DH_VehiclesSOV_tex.ext_vehicles.ZiS5V_ForGlass_FB' // cab window glass
    Skins(2)=Texture'MilitaryAlliesSMT.Vehicles.Zis-5v' // rear bench seats (separate material slot so can be hidden in support truck to make room for supplies)
    BeginningIdleAnim="" // override unwanted inherited value as has no animations

    // Passengers (others are added in subclasses)
    PassengerPawns(0)=(AttachBone="Passenger_front",DriveAnim="VHalftrack_Rider1_idle")

    // Driver
    DriverPositions(0)=(ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    InitialPositionIndex=0
    DriveAnim="VUC_driver_idle_close"

    // Movement
    GearRatios(0)=-0.3
    GearRatios(4)=0.98
    TransRatio=0.198
    TorqueCurve=(Points=((InVal=0.0,OutVal=15.0),(InVal=200.0,OutVal=10.0),(InVal=600.0,OutVal=8.0),(InVal=1200.0,OutVal=3.0),(InVal=2000.0,OutVal=0.5)))
    ChangeUpPoint=1990.0
    TurnDamping=25.0
    SteerSpeed=70.0
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=45.0),(InVal=200.0,OutVal=35.0),(InVal=800.0,OutVal=6.0),(InVal=1000000000.0,OutVal=0.0)))
    MinBrakeFriction=3.0
    MaxBrakeTorque=10.0
    bHasHandbrake=true
    HandbrakeThresh=100.0

    // Physics wheels properties
    WheelLongFrictionFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.2),(InVal=400.0,OutVal=0.001),(InVal=10000000000.0,OutVal=0.0)))
    WheelLatSlipFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=30.0,OutVal=0.009),(InVal=45.0,OutVal=0.09),(InVal=10000000000.0,OutVal=0.9)))
    WheelLatFrictionScale=1.35
    WheelHandbrakeSlip=1.5
    WheelSuspensionMaxRenderTravel=5.0

    // Damage
    Health=150
    HealthMax=150.0
    EngineHealth=35
    DisintegrationEffectClass=class'ROEffects.ROVehicleObliteratedEmitter'
    DisintegrationEffectLowClass=class'ROEffects.ROVehicleObliteratedEmitter_simple'
    VehHitpoints(0)=(PointBone="Body",PointOffset=(X=100.0,Y=0.0,Z=11.0)) // engine
    ImpactWorldDamageMult=1.0
    HeavyEngineDamageThreshold=0.33
    DamagedEffectScale=0.7
    DamagedEffectOffset=(X=105.0,Y=0.0,Z=20.0)
    DestroyedVehicleMesh=StaticMesh'DH_Soviet_vehicles_stc.ZiS5.ZiS5V_destroyed'

    // Exit
    ExitPositions(0)=(X=40.0,Y=-100.0,Z=25.0) // driver
    ExitPositions(1)=(X=40.0,Y=100.0,Z=25.0)  // front passenger

    // Sounds
    IdleSound=SoundGroup'Vehicle_Engines.BA64.ba64_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.BA64.BA64_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.BA64.BA64_engine_stop'

    // Visual effects
    ExhaustPipes(0)=(ExhaustPosition=(X=0.0,Y=40.0,Z=-20.0),ExhaustRotation=(Pitch=-2000,Yaw=25000))
    SteerBoneName="Steering_wheel"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.ZiS5V_body'
    VehicleHudEngineY=0.19
    VehicleHudOccupantsX(0)=0.44
    VehicleHudOccupantsY(0)=0.35
    VehicleHudOccupantsX(1)=0.55
    VehicleHudOccupantsY(1)=0.35
//  SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.zis5v' // TODO: get this icon made

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=Wheel_FrontL
        SteerType=VST_Steered
        BoneName="Wheel_FL"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-6.4)
        WheelRadius=23.5
        SupportBoneName="Axle_FR" // means left side vertices are rotated around right axle bone - just makes axle move correctly with wheels, purely a visual thing
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_ZiS5vTruck.Wheel_FrontL'
    Begin Object Class=SVehicleWheel Name=Wheel_FrontR
        SteerType=VST_Steered
        BoneName="Wheel_FR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=6.4)
        WheelRadius=23.5
        SupportBoneName="Axle_FL"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_ZiS5vTruck.Wheel_FrontR'
    Begin Object Class=SVehicleWheel Name=Wheel_BackL
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="Wheel_BL"
        BoneRollAxis=AXIS_Y
        WheelRadius=23.5
        SupportBoneName="Axle_BR"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_ZiS5vTruck.Wheel_BackL'
    Begin Object Class=SVehicleWheel Name=Wheel_BackR
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="Wheel_BR"
        BoneRollAxis=AXIS_Y
        WheelRadius=23.5
        SupportBoneName="Axle_BL"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_ZiS5vTruck.Wheel_BackR'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.3
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.45,Y=0.0,Z=-0.9) // default is zero
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_ZiS5vTruck.KParams0'
}

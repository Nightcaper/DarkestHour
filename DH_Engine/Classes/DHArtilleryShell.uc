//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHArtilleryShell extends Projectile;

// All variables from deprecated ROArtilleryShell:

var     vector              ImpactLocation;             // renamed from FinalHitLocation
var     float               FlightTimeToTarget;         // replaces DistanceToTarget, as that was only used to calculate flight time, so this is more direct
var     bool                bAlreadyDroppedProjectile;  // renamed from bDroppedProjectileFirst
var     bool                bAlreadyPlayedCloseSound;   // renamed from bAlreadyPlayedFarSound (was incorrect name)
var     byte                CloseSoundIndex;            // replaces SavedCloseSound as now only the server selects random CloseSound & replicates it to net clients
var     ROArtillerySound    SoundActor;                 // used to play the CloseSound // TODO: check necessity of this
var     AvoidMarker         Fear;                       // scare the bots away from this

// Explosion effects
var     sound               ExplosionSound[4];          // sound of the artillery exploding
var     sound               DistantSound[4];            // sound of the artillery distant overhead
var     sound               CloseSound[4];              // sound of the artillery whooshing in close
var     class<Emitter>      ShellHitDirtEffectClass;    // artillery hitting dirt emitter
var     class<Emitter>      ShellHitSnowEffectClass;    // artillery hitting snow emitter
var     class<Emitter>      ShellHitDirtEffectLowClass; // artillery hitting dirt emitter low settings
var     class<Emitter>      ShellHitSnowEffectLowClass; // artillery hitting snow emitter low settings

// Camera shake & blue
var     vector              ShakeRotMag;                // how far to rot view
var     vector              ShakeRotRate;               // how fast to rot view
var     float               ShakeRotTime;               // how much time to rot the instigator's view
var     vector              ShakeOffsetMag;             // max view offset vertically
var     vector              ShakeOffsetRate;            // how fast to offset view verticallyy
var     float               ShakeOffsetTime;            // how much time to offset view
var     float               BlurTime;                   // how long blur effect should last for this shell
var     float               BlurEffectScalar;

replication
{
    // Variables the server will replicate to clients when this actor is 1st replicated
    reliable if (bNetInitial && bNetDirty && Role == ROLE_Authority)
        CloseSoundIndex;
}

// Modified from deprecated ROArtilleryShell class so server selects a random CloseSound & replicates the index no. to net clients so their timing is in sync
simulated function PostBeginPlay()
{
    local sound RandomDistantSound;

    super.PostBeginPlay();

    // This fixes trouble when the player who initiated the arty strike leaves the server because their PC is gone, so Owner is now none
    if (Controller(Owner) != none)
    {
        Instigator = Controller(Owner).Pawn;

        if (InstigatorController == none)
        {
            InstigatorController = Controller(Owner);
        }
    }

    RandomDistantSound = DistantSound[Rand(4)];
    PlaySound(RandomDistantSound,, 10.0,, 50000.0, 1.0, true);
    SetTimer(GetSoundDuration(RandomDistantSound) * 0.95, false);

    if (Role == ROLE_Authority)
    {
        CloseSoundIndex = Rand(arraycount(CloseSound)); // added so server selects random CloseSound & replicates it to clients
    }
}

// From deprecated ROArtilleryShell class
simulated function Destroyed()
{
    super.Destroyed();

    if (Fear != none)
    {
        Fear.Destroy();
    }

    if (SoundActor != none)
    {
        SoundActor.Destroy();
    }
}

// From deprecated ROArtilleryShell class
simulated function Timer()
{
    local float CloseSoundDuration, NextTimerDuration;

    // On 1st Timer call, set things up, based on whether the projectile's flight time is going to be longer or shorter than the CloseSound duration
    if (!bAlreadyPlayedCloseSound && !bAlreadyDroppedProjectile)
    {
        SetUpStrike();
        CloseSoundDuration = GetSoundDuration(CloseSound[CloseSoundIndex]);

        // If CloseSound is longer than projectile's flight time, start playing CloseSound now & set a timer to delay dropping the projectile (while part of CloseSound plays)
        if (CloseSoundDuration > FlightTimeToTarget)
        {
            PlayCloseSound();
            NextTimerDuration = CloseSoundDuration - FlightTimeToTarget;
        }
        // Or if flight time is longer than CloseSound, drop the projectile now & set a timer to delay playing CloseSound
        else
        {
            DropProjectile();
            NextTimerDuration = FlightTimeToTarget - CloseSoundDuration;
        }

        SetTimer(NextTimerDuration, false);
    }
    // Or if we've already played the CloseSound, now drop the projectile
    else if (bAlreadyPlayedCloseSound)
    {
        DropProjectile();
    }
    // Or if we've already dropped the projectile, now play the CloseSound
    else if (bAlreadyDroppedProjectile)
    {
        PlayCloseSound();
    }
}

// Modified from deprecated ROArtilleryShell class (renamed from SetupStrikeFX) so we no longer select a random CloseSound here
// That is crucial as now only the server selects a random CloseSound & replicates it to net clients as CloseSoundIndex, so their timing is in sync with the server
// And the server has to do that earlier so it replicates the index to net clients when this actor is replicated to them, so it now happens in PostBeginPlay()
simulated function SetUpStrike()
{
    local Actor  HitActor;
    local vector HitNormal;

    HitActor = Trace(ImpactLocation, HitNormal, Location + (50000.0 * Normal(PhysicsVolume.Gravity)), Location, true);

    if (HitActor != none)
    {
        FlightTimeToTarget = VSize(Location - ImpactLocation) / Speed;

        if (Role == ROLE_Authority)
        {
            Fear = Spawn(class'AvoidMarker',,, ImpactLocation);
            Fear.SetCollisionSize(DamageRadius, 200.0);
            Fear.StartleBots();
        }
    }
    else
    {
        Log("Artillery shell set up error - failed to trace HitActor & get an ImpactLocation, so destroying shell actor!!!");
        Destroy();
    }
}

// New function to make the projectile visible & start it falling
simulated function DropProjectile()
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        SetDrawType(DT_StaticMesh);
    }

    Velocity = Normal(PhysicsVolume.Gravity) * Speed;
    bAlreadyDroppedProjectile = true;
}

// From deprecated ROArtilleryShell class (renamed from DoTraceFX for clarity)
simulated function PlayCloseSound()
{
    SoundActor = Spawn(class'ROArtillerySound', self,, ImpactLocation, rotator(PhysicsVolume.Gravity));
    SoundActor.PlaySound(CloseSound[CloseSoundIndex],, 10.0, true, 5248.0, 1.0, true);
    bAlreadyPlayedCloseSound = true;
}

// Matt: modified to handle new collision mesh actor - if we hit a CM we switch hit actor to CM's owner & proceed as if we'd hit that actor
// Also re-factored generally to optimise, but original functionality unchanged
simulated singular function Touch(Actor Other)
{
    local vector HitLocation, HitNormal;

    if (Other == none || (!Other.bProjTarget && !Other.bBlockActors))
    {
        return;
    }

    // We use TraceThisActor do a simple line check against the actor we've hit, to get an accurate HitLocation to pass to ProcessTouch()
    // It's more accurate than using our current location as projectile has often travelled a little further by the time this event gets called
    // But if that trace returns true then it somehow didn't hit the actor, so we fall back to using our current location as the HitLocation
    // Also skip trace & use location as HitLocation if our velocity is somehow zero (collided immediately on launch?) or we hit a Mover actor
    if (Velocity == vect(0.0, 0.0, 0.0) || Other.IsA('Mover')
        || Other.TraceThisActor(HitLocation, HitNormal, Location, Location - (2.0 * Velocity), GetCollisionExtent()))
    {
        HitLocation = Location;
    }

    // Special handling for hit on a collision mesh actor - switch hit actor to CM's owner & proceed as if we'd hit that actor
    if (Other.IsA('DHCollisionMeshActor'))
    {
        if (DHCollisionMeshActor(Other).bWontStopShell)
        {
            return; // exit, doing nothing, if col mesh actor is set not to stop a shell
        }

        Other = Other.Owner;
    }

    // Now call ProcessTouch(), which is the where the class-specific Touch functionality gets handled
    // Record LastTouched to prevent possible recursive calls & then clear it after
    LastTouched = Other;
    ProcessTouch(Other, HitLocation);
    LastTouched = none;

    // On a net client call ClientSideTouch() if we hit a pawn with an authority role on the client (in practice this can only be a ragdoll corpse)
    // TODO: probably remove this & empty out ClientSideTouch() as ProcessTouch() will get called clientside anyway & is much more class-specific & sophisticated
    if (Role < ROLE_Authority && Other.Role == ROLE_Authority && Pawn(Other) != none && Velocity != vect(0.0, 0.0, 0.0))
    {
        ClientSideTouch(Other, HitLocation);
    }
}

// From deprecated ROArtilleryShell class
simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
    if (Other != Instigator)
    {
        SpawnExplosionEffects(HitLocation, -Normal(Velocity));
        Explode(HitLocation, Normal(HitLocation - Other.Location));
    }
}

// From deprecated ROArtilleryShell class
simulated function HitWall(vector HitNormal, Actor Wall)
{
    Landed(HitNormal);
}

// From deprecated ROArtilleryShell class
simulated function Landed(vector HitNormal)
{
    SpawnExplosionEffects(Location, HitNormal);
    Explode(Location, HitNormal);
}

// Containing ragdoll functionality from deprecated ROArtilleryShell class (moved here from Destroyed), but with explosion radius damage moved to BlowUp()
simulated function Explode(vector HitLocation, vector HitNormal)
{
    local ROPawn Victims;
    local vector Direction, Start;
    local float  DamageScale, Distance;

    // Move karma ragdolls around when this explodes (formerly in Destroyed)
    if (Level.NetMode != NM_DedicatedServer)
    {
        Start = Location + (32.0 * vect(0.0, 0.0, 1.0));

        foreach VisibleCollidingActors(class 'ROPawn', Victims, DamageRadius, Start)
        {
            if (Victims != self && Victims.Physics == PHYS_KarmaRagDoll)
            {
                Direction = Victims.Location - Start;
                Distance = FMax(1.0, VSize(Direction));
                Direction = Direction / Distance;
                DamageScale = 1.0 - FMax(0.0, (Distance - Victims.CollisionRadius) / DamageRadius);
                Victims.DeadExplosionKarma(MyDamageType, DamageScale * MomentumTransfer * Direction, DamageScale);
            }
        }
    }

    BlowUp(HitLocation);
    Destroy();
}

// Containing explosion radius damage from deprecated ROArtilleryShell class (moved here from Explode)
function BlowUp(vector HitLocation)
{
    if (Role == ROLE_Authority)
    {
        DelayedHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
    }
}

// From deprecated ROArtilleryShell class (renamed from SpawnEffects)
simulated function SpawnExplosionEffects(vector HitLocation, vector HitNormal)
{
    local vector        TraceHitLocation, TraceHitNormal;
    local material      HitMaterial;
    local ESurfaceTypes ST;

    PlaySound(ExplosionSound[Rand(4)],, 6.0 * TransientSoundVolume, false, 5248.0, 1.0, true);

    DoShakeEffect();

    if (EffectIsRelevant(HitLocation, false))
    {
        Trace(TraceHitLocation, TraceHitNormal, Location + (16.0 * vector(Rotation)), Location, false,, HitMaterial);

        if (HitMaterial != none)
        {
            ST = ESurfaceTypes(HitMaterial.SurfaceType);
        }
        else
        {
            ST = EST_Default;
        }

        Spawn(class'RORocketExplosion',,, HitLocation + (16.0 * HitNormal), rotator(HitNormal));

        if (ST == EST_Snow || ST == EST_Ice)
        {
            if (Level.bDropDetail || Level.DetailMode == DM_Low)
            {
                Spawn(ShellHitSnowEffectLowClass,,, HitLocation, rotator(HitNormal));
            }
            else
            {
                Spawn(ShellHitSnowEffectClass,,, HitLocation, rotator(HitNormal));
            }

            Spawn(ExplosionDecalSnow, self,, HitLocation, rotator(-HitNormal));
        }
        else
        {
            if (Level.bDropDetail || Level.DetailMode == DM_Low)
            {
                Spawn(ShellHitDirtEffectLowClass,,, HitLocation, rotator(HitNormal));
            }
            else
            {
                Spawn(ShellHitDirtEffectClass,,, HitLocation, rotator(HitNormal));
            }

            Spawn(ExplosionDecal, self,, HitLocation, rotator(-HitNormal));
        }
    }
}

// Matt: modified to handle new collision mesh actor - if we hit a col mesh, we switch hit actor to col mesh's owner & proceed as if we'd hit that actor
// Also to call CheckVehicleOccupantsRadiusDamage() instead of DriverRadiusDamage() on a hit vehicle, to properly handle blast damage to any exposed vehicle occupants
// And to fix problem affecting many vehicles with hull mesh modelled with origin on the ground, where even a slight ground bump could block all blast damage
// Also to update Instigator, so HurtRadius attributes damage to the player's current pawn
function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local Actor         Victim, TraceActor;
    local DHVehicle     V;
    local ROPawn        P;
    local array<ROPawn> CheckedROPawns;
    local bool          bAlreadyChecked;
    local vector        VictimLocation, Direction, TraceHitLocation, TraceHitNormal;
    local float         DamageScale, Distance, DamageExposure;
    local int           i;

    // Make sure nothing else runs HurtRadius() while we are in the middle of the function
    if (bHurtEntry)
    {
        return;
    }

    bHurtEntry = true;

    UpdateInstigator();

    // Find all colliding actors within blast radius, which the blast should damage
    // No longer use VisibleCollidingActors as much slower (FastTrace on every actor found), but we can filter actors & then we do our own, more accurate trace anyway
    foreach CollidingActors(class'Actor', Victim, DamageRadius, HitLocation)
    {
        if (!Victim.bBlockActors)
        {
            continue;
        }

        // If hit a collision mesh actor, switch to its owner
        if (Victim.IsA('DHCollisionMeshActor'))
        {
            if (DHCollisionMeshActor(Victim).bWontStopBlastDamage)
            {
                continue; // ignore col mesh actor if it is set not to stop blast damage
            }

            Victim = Victim.Owner;
        }

        // Don't damage this projectile, an actor already damaged by projectile impact (HurtWall), cannon actors, non-authority actors, or fluids
        // We skip damage on cannons because the blast will hit the vehicle base so we don't want to double up on damage to the same vehicle
        if (Victim == none || Victim == self || Victim == HurtWall || Victim.IsA('DHVehicleCannon') || Victim.Role < ROLE_Authority || Victim.IsA('FluidSurfaceInfo'))
        {
            continue;
        }

        // Now we need to check whether there's something in the way that could shield this actor from the blast
        // Usually we trace to actor's location, but for a tank (or similar, including AT gun), we adjust Z location to give a more consistent, realistic tracing height
        // This is because many vehicles are modelled with their origin on the ground, so even a slight bump in the ground could block all blast damage!
        VictimLocation = Victim.Location;
        V = DHVehicle(Victim);

        if (V != none && V.Cannon != none && V.Cannon.AttachmentBone != '')
        {
            VictimLocation.Z = V.GetBoneCoords(V.Cannon.AttachmentBone).Origin.Z;
        }

        // Trace from explosion point to the actor to check whether anything is in the way that could shield it from the blast
        TraceActor = Trace(TraceHitLocation, TraceHitNormal, VictimLocation, HitLocation);

        if (DHCollisionMeshActor(TraceActor) != none)
        {
            if (DHCollisionMeshActor(TraceActor).bWontStopBlastDamage)
            {
                continue;
            }

            TraceActor = TraceActor.Owner; // as normal, if hit a collision mesh actor then switch to its owner
        }

        // Ignore the actor if the blast is blocked by world geometry, a vehicle, or a turret (but don't let a turret block damage to its own vehicle)
        if (TraceActor != none && TraceActor != Victim && (TraceActor.bWorldGeometry || TraceActor.IsA('ROVehicle') || (TraceActor.IsA('DHVehicleCannon') && Victim != TraceActor.Base)))
        {
            continue;
        }

        // Check for hit on player pawn
        P = ROPawn(Victim);

        if (P != none)
        {
            // If we hit a player pawn, make sure we haven't already registered the hit & add pawn to array of already hit/checked pawns
            for (i = 0; i < CheckedROPawns.Length; ++i)
            {
                if (P == CheckedROPawns[i])
                {
                    bAlreadyChecked = true;
                    break;
                }
            }

            if (bAlreadyChecked)
            {
                bAlreadyChecked = false;
                continue;
            }

            CheckedROPawns[CheckedROPawns.Length] = P;

            // If player is partially shielded from the blast, calculate damage reduction scale
            DamageExposure = P.GetExposureTo(HitLocation + 15.0 * -Normal(PhysicsVolume.Gravity));

            if (DamageExposure <= 0.0)
            {
                continue;
            }
        }

        // Calculate damage based on distance from explosion
        Direction = VictimLocation - HitLocation;
        Distance = FMax(1.0, VSize(Direction));
        Direction = Direction / Distance;
        DamageScale = 1.0 - FMax(0.0, (Distance - Victim.CollisionRadius) / DamageRadius);

        if (P != none)
        {
            DamageScale *= DamageExposure;
        }

        // Record player responsible for damage caused, & if we're damaging LastTouched actor, reset that to avoid damaging it again at end of function
        if (Instigator == none || Instigator.Controller == none)
        {
            Victim.SetDelayedDamageInstigatorController(InstigatorController);
        }

        if (Victim == LastTouched)
        {
            LastTouched = none;
        }

        // Damage the actor hit by the blast - if it's a vehicle, check for damage to any exposed occupants
        Victim.TakeDamage(DamageScale * DamageAmount, Instigator, VictimLocation - 0.5 * (Victim.CollisionHeight + Victim.CollisionRadius) * Direction,
            DamageScale * Momentum * Direction, DamageType);

        if (ROVehicle(Victim) != none && ROVehicle(Victim).Health > 0)
        {
            CheckVehicleOccupantsRadiusDamage(ROVehicle(Victim), DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
        }
    }

    // Same (or very similar) process for the last actor this projectile hit (Touched), but only happens if actor wasn't found by the check for CollidingActors
    if (LastTouched != none && LastTouched != self && LastTouched.Role == ROLE_Authority && !LastTouched.IsA('FluidSurfaceInfo'))
    {
        Direction = LastTouched.Location - HitLocation;
        Distance = FMax(1.0, VSize(Direction));
        Direction = Direction / Distance;
        DamageScale = FMax(LastTouched.CollisionRadius / (LastTouched.CollisionRadius + LastTouched.CollisionHeight),
            1.0 - FMax(0.0, (Distance - LastTouched.CollisionRadius) / DamageRadius));

        if (Instigator == none || Instigator.Controller == none)
        {
            LastTouched.SetDelayedDamageInstigatorController(InstigatorController);
        }

        LastTouched.TakeDamage(DamageScale * DamageAmount, Instigator,
            LastTouched.Location - 0.5 * (LastTouched.CollisionHeight + LastTouched.CollisionRadius) * Direction, DamageScale * Momentum * Direction, DamageType);

        if (ROVehicle(LastTouched) != none && ROVehicle(LastTouched).Health > 0)
        {
            CheckVehicleOccupantsRadiusDamage(ROVehicle(LastTouched), DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
        }

        LastTouched = none;
    }

    bHurtEntry = false;
}

// New function to check for possible blast damage to all vehicle occupants that don't have collision of their own & so won't be 'caught' by HurtRadius()
function CheckVehicleOccupantsRadiusDamage(ROVehicle V, float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local ROVehicleWeaponPawn WP;
    local int i;

    if (V.Driver != none && V.DriverPositions[V.DriverPositionIndex].bExposed && !V.Driver.bCollideActors && !V.bRemoteControlled)
    {
        VehicleOccupantRadiusDamage(V.Driver, DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
    }

    for (i = 0; i < V.WeaponPawns.Length; ++i)
    {
        WP = ROVehicleWeaponPawn(V.WeaponPawns[i]);

        if (WP != none && WP.Driver != none && ((WP.bMultiPosition && WP.DriverPositions[WP.DriverPositionIndex].bExposed) || WP.bSinglePositionExposed)
            && !WP.bCollideActors && !WP.bRemoteControlled)
        {
            VehicleOccupantRadiusDamage(WP.Driver, DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
        }
    }
}

// New function to handle blast damage to vehicle occupants
function VehicleOccupantRadiusDamage(Pawn P, float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local Actor  TraceHitActor;
    local coords HeadBoneCoords;
    local vector HeadLocation, TraceHitLocation, TraceHitNormal, Direction;
    local float  Distance, DamageScale;

    if (P != none)
    {
        HeadBoneCoords = P.GetBoneCoords(P.HeadBone);
        HeadLocation = HeadBoneCoords.Origin + ((P.HeadHeight + (0.5 * P.HeadRadius)) * P.HeadScale * HeadBoneCoords.XAxis);

        // Trace from the explosion to the top of player pawn's head & if there's a blocking actor in between (probably the vehicle), exit without damaging pawn
        foreach TraceActors(class'Actor', TraceHitActor, TraceHitLocation, TraceHitNormal, HeadLocation, HitLocation)
        {
            if (TraceHitActor.bBlockActors)
            {
                return;
            }
        }

        // Calculate damage based on distance from explosion
        Direction = P.Location - HitLocation;
        Distance = FMax(1.0, VSize(Direction));
        Direction = Direction / Distance;
        DamageScale = 1.0 - FMax(0.0, (Distance - P.CollisionRadius) / DamageRadius);

        // Damage the vehicle occupant
        if (DamageScale > 0.0)
        {
            P.SetDelayedDamageInstigatorController(InstigatorController);

            P.TakeDamage(DamageScale * DamageAmount, InstigatorController.Pawn, P.Location - (0.5 * (P.CollisionHeight + P.CollisionRadius)) * Direction,
                DamageScale * Momentum * Direction, DamageType);
        }
    }
}

// From deprecated ROArtilleryShell class (slightly re-factored to optimise & make clearer)
simulated function DoShakeEffect()
{
    local PlayerController PC;
    local float            Distance, MaxShakeDistance, Scale, BlastShielding;

    PC = Level.GetLocalPlayerController();

    if (PC != none && PC.ViewTarget != none)
    {
        Distance = VSize(Location - PC.ViewTarget.Location);
        MaxShakeDistance = DamageRadius * 3.0;

        if (Distance < MaxShakeDistance)
        {
            // Screen shake
            Scale = (MaxShakeDistance - Distance) / MaxShakeDistance * BlurEffectScalar;
            PC.ShakeView(ShakeRotMag * Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag * Scale, ShakeOffsetRate, ShakeOffsetTime);

            // Screen blur (reduce scale if player is not fully exposed to the blast)
            if (ROPawn(PC.Pawn) != none && PC.IsA('ROPlayer'))
            {
                BlastShielding = 1.0 - ROPawn(PC.Pawn).GetExposureTo(Location - (50.0 * Normal(PhysicsVolume.Gravity)));
                Scale -= (0.35 * BlastShielding);
                ROPlayer(PC).AddBlur(BlurTime * Scale, FMin(1.0, Scale));
            }
        }
    }
}

// Colin: Overridden to just return true. The super function is a pointless
// micro-optimization that may have made sense in 2008 when graphics hardware
// wasn't as good, but certainly doesn't make sense now. This is an effect
// that's the size of a building & it's not instantaneous; I don't care how far
// away it is or if you're not looking at it right this instant -- it's relevant.
simulated function bool EffectIsRelevant(vector SpawnLocation, bool bForceDedicated)
{
    return true;
}

// New function updating Instigator reference to ensure damage is attributed to correct player, as may have switched to different pawn since calling arty, e.g. entered vehicle or died
simulated function UpdateInstigator()
{
    if (InstigatorController != none && InstigatorController.Pawn != none)
    {
        Instigator = InstigatorController.Pawn;
    }
}

defaultproperties
{
    // All from deprecated ROArtilleryShell class:
    Damage=500
    DamageRadius=1000.0
    MyDamageType=class'ROArtilleryDamType'
    MomentumTransfer=75000.0

    DrawType=DT_None // was DT_StaticMesh in RO, but was then set to DT_None in PostBeginPlay - now we simply start with None & switch to SM when we drop the projectile
    StaticMesh=StaticMesh'WeaponPickupSM.shells.122mm_shell' // was a panzerfaust warhead in RO, although never visible - now a large shell
    CullDistance=50000.0
    AmbientGlow=100

    Speed=8000.0
    MaxSpeed=8000.0
    LifeSpan=1500.0 // TODO: seems way too long, a few seconds would be fine, same as other projectiles
//  bProjTarget=true // was in RO but removed as makes no sense for a shell be a target for other projectiles & no other projectiles have this

    ExplosionSound(0)=sound'Artillery.explosions.explo01'
    ExplosionSound(1)=sound'Artillery.explosions.explo02'
    ExplosionSound(2)=sound'Artillery.explosions.explo03'
    ExplosionSound(3)=sound'Artillery.explosions.explo04'
    DistantSound(0)=sound'Artillery.fire_distant'
    DistantSound(1)=sound'Artillery.fire_distant'
    DistantSound(2)=sound'Artillery.fire_distant'
    DistantSound(3)=sound'Artillery.fire_distant'
    CloseSound(0)=sound'Artillery.zoomin.zoom_in01'
    CloseSound(1)=sound'Artillery.zoomin.zoom_in02'
    CloseSound(2)=sound'Artillery.zoomin.zoom_in03'
    CloseSound(3)=sound'Artillery.zoomin.zoom_in03'
    TransientSoundVolume=1.0
    SoundVolume=255 // TODO: presume redundant as no ambient sound? (radius too)
    SoundRadius=100.0

    ShellHitDirtEffectClass=class'ROArtilleryDirtEmitter'
    ShellHitSnowEffectClass=class'ROArtillerySnowEmitter'
    ShellHitDirtEffectLowClass=class'ROArtilleryDirtEmitter_simple'
    ShellHitSnowEffectLowClass=class'ROArtillerySnowEmitter_simple'
    ExplosionDecal=class'ArtilleryMarkDirt'
    ExplosionDecalSnow=class'ArtilleryMarkSnow'

    ShakeRotMag=(X=0.0,Y=0.0,Z=200.0)
    ShakeRotRate=(X=0.0,Y=0.0,Z=2500.0)
    ShakeRotTime=3.0
    ShakeOffsetMag=(X=0.0,Y=0.0,Z=10.0)
    ShakeOffsetRate=(X=0.0,Y=0.0,Z=200.0)
    ShakeOffsetTime=5.0
    BlurTime=6.0
    BlurEffectScalar=2.1

    ForceType=FT_Constant
    ForceScale=5.0
    ForceRadius=60.0
}

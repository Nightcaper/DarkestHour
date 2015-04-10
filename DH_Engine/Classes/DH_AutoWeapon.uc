//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_AutoWeapon extends DHProjectileWeapon
    abstract;

simulated function ZoomIn(bool bAnimateTransition)
{
    // Make the weapon stop firing when we transition to/from iron sights
    if (FireMode[0] != none && FireMode[0].IsInState('FireLoop'))
    {
        FireMode[0].GotoState('');
    }

    if (bAnimateTransition)
    {
        GotoState('IronSightZoomIn');
    }

    bUsingSights = true;

    ROPawn(Instigator).SetIronSightAnims(true);
}

simulated function ZoomOut(bool bAnimateTransition)
{
    // Make the weapon stop firing when we transition to/from iron sights
    if (FireMode[0] != none && FireMode[0].IsInState('FireLoop'))
    {
        FireMode[0].GotoState('');
    }

    if (bAnimateTransition)
    {
        GotoState('IronSightZoomOut');
    }

    bUsingSights = false;

    ROPawn(Instigator).SetIronSightAnims(false);

    ResetPlayerFOV();
}

// Take the weapon out of iron sights if you jump
simulated function NotifyOwnerJumped()
{
    // Make the weapon stop firing when we transition to/from iron sights
    if (FireMode[0] != none && FireMode[0].IsInState('FireLoop'))
    {
        FireMode[0].GotoState('');
    }

    super.NotifyOwnerJumped();
}

// Tells bot whether to charge or back off while using this weapon
function float SuggestAttackStyle()
{
    return 0.5;
}

// Tells bot whether to charge or back off while defending against this weapon
function float SuggestDefenseStyle()
{
    return -0.4;
}

function float MaxRange()
{
    return 9000.0; // about 150 meters
}

// Overridden to prevent auto weapons from playing fireend anims while looping
simulated function AnimEnd(int channel)
{
    local name  Anim;
    local float Frame, Rate;

    GetAnimParams(0, Anim, Frame, Rate);

    if (ClientState == WS_ReadyToFire)
    {
        if (Anim == FireMode[0].FireAnim && HasAnim(FireMode[0].FireEndAnim) && !FireMode[0].bIsFiring)
        {
            PlayAnim(FireMode[0].FireEndAnim, FireMode[0].FireEndAnimRate, 0.0);
        }
        else if (Anim== FireMode[1].FireAnim && HasAnim(FireMode[1].FireEndAnim))
        {
            PlayAnim(FireMode[1].FireEndAnim, FireMode[1].FireEndAnimRate, 0.0);
        }
        else if ((FireMode[0] == none || !FireMode[0].bIsFiring) && (FireMode[1] == none || !FireMode[1].bIsFiring))
        {
            PlayIdle();
        }
    }
}

defaultproperties
{
    bCanAttachOnBack=true
}

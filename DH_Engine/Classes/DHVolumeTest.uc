//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHVolumeTest extends ROVolumeTest;

// Modified to handle no arty volumes that are linked to a DHSpawnPoint (as well as an old spawn area) or to a DHObjective
// Also to handle DHMineVolumes that use the option to also act as a NoArtyVolume
function bool IsInNoArtyVolume()
{
    local Volume V;

    foreach TouchingActors(class'Volume', V)
    {
        // Prevent arty if we're in a no arty volume, unless it's linked to a spawn point/area that isn't active/current
        if (V.IsA('RONoArtyVolume'))
        {
            if (DHSpawnPoint(V.AssociatedActor) != none)
            {
                if (IsActiveSpawnPoint(DHSpawnPoint(V.AssociatedActor)))
                {
                    return true;
                }
            }
            else if (RONoArtyVolume(V).AssociatedSpawn != none)
            {
                if (IsCurrentSpawnArea(RONoArtyVolume(V).AssociatedSpawn))
                {
                    return true;
                }
            }
            else if (DHObjective(V.AssociatedActor) != none)
            {
                if (DHObjective(V.AssociatedActor).IsActive())
                {
                    return true;
                }
            }
            else
            {
                return true;
            }
        }
        // Prevent arty if we're in an active mine volume that is set to also function as a no arty volume
        else if (V.IsA('DHMineVolume'))
        {
            if (DHMineVolume(V).bIsAlsoNoArtyVolume && DHMineVolume(V).bActive)
            {
                return true;
            }
        }
        // Prevent arty if we're in a current spawn area's protective volume
        else if (V.AssociatedActor != none && V.AssociatedActor.IsA('ROSpawnArea') && IsCurrentSpawnArea(ROSpawnArea(V.AssociatedActor)))
        {
            return true;
        }
    }

    return false;
}

// New helper function returns true if this DHSpawnPoint is active (just improves readability in main class function above)
// (Similar to IsCurrentSpawnArea() for spawn areas)
function bool IsActiveSpawnPoint(DHSpawnPoint SP)
{
    return SP != none && SP.IsActive();
}

defaultproperties
{
}

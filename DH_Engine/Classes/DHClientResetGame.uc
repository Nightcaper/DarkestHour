//===================================================================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//===================================================================================================================

class DHClientResetGame extends Actor;

/*
Matt: if ResetGame option is used, this actor removes temporary client-only actors such as smoke effects
Spawned by server & replicates to all net clients, then calling Reset on any client-only actors
Then let the client actor's Reset function handle whatever is needed (e.g. for smoke effects Reset calls Destroy)
Note that Reset also gets called on those actors in single player mode, where it will have the same desired result
*/

simulated function PostBeginPlay()
{
    local Actor A;

    if (Role < ROLE_Authority)
    {
        foreach AllActors(class'Actor', A)
        {
            if (A.Role == ROLE_Authority) // means this must be a non-replicated actor that exists independently on the client
            {
                A.Reset();
            }
        }
    }

    if (Role < ROLE_Authority || Level.NetMode == NM_Standalone)
    {
        Destroy(); // the client version of this actor has done it's job (& this actor has no business existing on a standalone)
    }

    super.PostBeginPlay();
}

defaultproperties
{
    bAlwaysRelevant=true
    bNetTemporary=true // client actor gets torn off as soon as it replicates, as all it needs to do is reach the client to do its stuff
    LifeSpan=5.0       // means server version of this actor will be auto-destroyed after a few seconds, giving it time to replicate to clients
    bSkipActorPropertyReplication=true
    bHidden=true
}

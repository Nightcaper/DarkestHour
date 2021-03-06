//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHMapMarker_Friendly_PlatoonHQ extends DHMapMarker_Friendly
    abstract;

static function bool CanBeUsed(DHGameReplicationInfo GRI)
{
    return GRI != none && GRI.bAreConstructionsEnabled;
}

defaultproperties
{
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.platoon_hq'
    MarkerName="Build HQ"
    LifetimeSeconds=300
}


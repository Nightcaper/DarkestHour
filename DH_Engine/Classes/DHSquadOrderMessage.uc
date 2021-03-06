//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHSquadOrderMessage extends ROCriticalMessage
    abstract;

var localized string WaitText;
var localized string AttackText;
var localized string DefendText;
var localized string MoveText;

var sound OrderSound;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0:
            return default.WaitText;
        case 1:
            return default.AttackText;
        case 2:
            return default.DefendText;
        case 3:
            return default.MoveText;
        default:
            return "";
    }
}

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

    P.PlayAnnouncement(default.OrderSound, 1, true);
}

defaultproperties
{
    WaitText="Please wait before making a new order"
    AttackText="Squad leader has issued a new Attack order"
    DefendText="Squad leader has issued a new Defend order"
    MoveText="Squad leader has issued a new Move order"
    OrderSound=Sound'DH_SundrySounds.Squad.squad_order'
}

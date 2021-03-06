//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_Vehicle extends DHConstruction
    abstract
    notplaceable;

var class<ROVehicle>    VehicleClass;
var ROVehicle           Vehicle;

function Destroyed()
{
    super.Destroyed();

    if (Vehicle != none)
    {
        Vehicle.Destroy();
    }
}

simulated function OnTeamIndexChanged()
{
    super.OnTeamIndexChanged();

    VehicleClass = GetVehicleClass(GetContext());
}

simulated function OnConstructed()
{
    if (Role == ROLE_Authority)
    {
        if (VehicleClass != none)
        {
            Vehicle = Spawn(VehicleClass,,, Location, Rotation);

            GotoState('Dummy');
        }
    }
}

simulated state Dummy
{
    function BeginState()
    {
        SetTimer(1.0, true);
    }

    function Timer()
    {
        if (Vehicle == none)
        {
            Destroy();
        }
    }
}

function static UpdateProxy(DHConstructionProxy CP)
{
    local int i, j;
    local DHConstructionProxyAttachment CPA;
    local class<ROVehicle> VehicleClass;

    VehicleClass = GetVehicleClass(CP.GetContext());

    CP.SetDrawType(DT_Mesh);
    CP.LinkMesh(VehicleClass.default.Mesh);

    for (j = 0; j < VehicleClass.default.Skins.Length; ++j)
    {
        if (VehicleClass.default.Skins[j] != none)
        {
            CP.Skins[j] = CP.CreateProxyMaterial(VehicleClass.default.Skins[j]);
        }
    }

    for (i = 0; i < VehicleClass.default.PassengerWeapons.Length; ++i)
    {
        CPA = CP.Spawn(class'DHConstructionProxyAttachment', CP);

        if (CPA != none)
        {
            CP.AttachToBone(CPA, VehicleClass.default.PassengerWeapons[i].WeaponBone);

            CPA.SetDrawType(DT_Mesh);
            CPA.LinkMesh(VehicleClass.default.PassengerWeapons[i].WeaponPawnClass.default.GunClass.default.Mesh);

            j = 0;

            for (j = 0; j < VehicleClass.default.PassengerWeapons[i].WeaponPawnClass.default.GunClass.default.Skins.Length; ++j)
            {
                if (VehicleClass.default.PassengerWeapons[i].WeaponPawnClass.default.GunClass.default.Skins[j] != none)
                {
                    CPA.Skins[j] = CP.CreateProxyMaterial(VehicleClass.default.PassengerWeapons[i].WeaponPawnClass.default.GunClass.default.Skins[j]);
                }
            }

            CP.Attachments[CP.Attachments.Length] = CPA;
        }
    }
}

function static string GetMenuName(DHConstruction.Context Context)
{
    return GetVehicleClass(Context).default.VehicleNameString;
}

function UpdateAppearance()
{
    SetDrawType(DT_Mesh);
    LinkMesh(VehicleClass.default.Mesh);
    SetCollisionSize(VehicleClass.default.CollisionRadius, VehicleClass.default.CollisionHeight);
}

function static GetCollisionSize(DHConstruction.Context Context, out float NewRadius, out float NewHeight)
{
    local class<ROVehicle> VehicleClass;

    VehicleClass = GetVehicleClass(Context);

    if (VehicleClass != none)
    {
        NewRadius = VehicleClass.default.CollisionRadius;
        NewHeight = VehicleClass.default.CollisionHeight;
        return;
    }

    // If we couldn't get the vehicle class, just fall back on to the original method.
    super.GetCollisionSize(Context, NewRadius, NewHeight);
}

// Override to get a different vehicle class based on scenario (eg. snow camo etc.)
function static class<ROVehicle> GetVehicleClass(DHConstruction.Context Context)
{
    return default.VehicleClass;
}

function static DHConstruction.ConstructionError GetPlayerError(DHConstruction.Context Context)
{
    local DHConstruction.ConstructionError E;

    if (GetVehicleClass(Context) == none)
    {
        E.Type = ERROR_Fatal;
        return E;
    }

    return super.GetPlayerError(Context);
}

defaultproperties
{
    StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_02'
    bDestroyOnConstruction=false
    bShouldAlignToGround=true
    BrokenLifespan=0.0
    ConstructionVerb="emplace"
}

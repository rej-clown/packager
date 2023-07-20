#pragma newdecls required

public Plugin myinfo = 
{
	name = "Packager <json>",
	author = "rej.chev",
	description = "Runtime json based cache",
	version = "2.1.0",
	url = "discord.gg/ChTyPUG"
};

bool g_bLate;

#include "packager/methodmap.sp"

Packager packager;
GlobalForward
    fwdPackageUpdate,
    fwdPackageAvailable;

#include "packager/forwards.sp"
#include "packager/natives.sp"

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) 
{
    CreateNative("Packager.GetPackage", Native_GetPackage);
 
    CreateNative("Package.GetArtifact", Native_GetArtifact);
    CreateNative("Package.SetArtifact", Native_SetArtifact);
    CreateNative("Package.HasArtifact", Native_HasArtifact);
    CreateNative("Package.RemoveArtifact", Native_RemoveArtifact);
    CreateNative("Package.Artifacts.get", Native_Artifacts);
    CreateNative("Package.Owner.get", Native_PackageOwner);

    fwdPackageUpdate = new GlobalForward(
        "pckg_OnPackageUpdated", 
        ET_Ignore, Param_Cell, Param_Cell
    );

    fwdPackageAvailable = new GlobalForward(
        "pckg_OnPackageAvailable", 
        ET_Ignore, Param_Cell
    );

    RegPluginLibrary("packager");

    g_bLate = late;
    return APLRes_Success;
}

public void OnPluginStart() 
{
    packager = new Packager();

    if(g_bLate) {
        g_bLate = false;
        for(int i = 1; i <= MaxClients; i++)
            if(IsClientInGame(i) && IsClientAuthorized(i))
                OnClientAuthorized(i, GetClientAuthIdEx(i));
    }
}

public void OnMapStart() 
{
    OnClientAuthorized(0, "STEAM_ID_SERVER");
}

public void OnClientAuthorized(int iClient, const char[] auth) 
{
    packager.RemovePackage(iClient);

    if(iClient && IsClientInGame(iClient) && (IsFakeClient(iClient) || IsClientSourceTV(iClient)))
        return;

    // true
    packager.SetPackage(iClient, new Package(iClient, auth));
        
    Call_StartForward(fwdPackageAvailable);
    Call_PushCell(iClient);
    Call_Finish();
}
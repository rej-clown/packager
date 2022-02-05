#pragma newdecls required

// #define UTIL_MACRO

#include <jansson>

public Plugin myinfo = 
{
	name = "Packager <json>",
	author = "rej.chev",
	description = "...",
	version = "1.2.0",
	url = "discord.gg/ChTyPUG"
};

bool g_bLate;

GlobalForward
    fwdPackageUpdate,
    fwdPackageAvailable;

#include "packager/methodmap.sp"
Packager packager;

#include "packager/forwards.sp"
#include "packager/natives.sp"


public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) {

    CreateNative("Packager.GetPackage", Native_GetPackage);
    CreateNative("Packager.SetPackage", Native_SetPackage);
    CreateNative("Packager.HasPackage", Native_HasPackage);
    // CreateNative("Packager.", Native_IsVerified);
    CreateNative("Packager.GetArtifact", Native_GetArtifact);
    CreateNative("Packager.SetArtifact", Native_SetArtifact);
    CreateNative("Packager.HasArtifact", Native_HasArtifact);
    CreateNative("Packager.RemoveArtifact", Native_Remove);


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
}

public void OnPluginStart() {
    packager = new Packager();

    if(g_bLate) {
        g_bLate = false;
        for(int i = 1; i <= MaxClients; i++) {
            if(IsClientInGame(i) && IsClientAuthorized(i)) {
                OnClientAuthorized(i, GetClientAuthIdEx(i));
            }
        }
    }
}

public void OnMapStart() 
{
    OnClientAuthorized(0, NULL_STRING);
}

public void OnClientAuthorized(int iClient, const char[] auth) 
{
    packager.RemovePackage(iClient);

    if(iClient && IsClientInGame(iClient) && (IsFakeClient(iClient) || IsClientSourceTV(iClient)))
        return;

    if(!packager.CreatePackage(iClient))
        SetFailState("Something went wrong:/");
    
    Call_StartForward(fwdPackageAvailable);
    Call_PushCell(iClient);
    Call_Finish();
}
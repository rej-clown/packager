#pragma newdecls required

#define UTIL_MACRO

#include <jansson>
#include <packager>

public Plugin myinfo = 
{
	name = "Packager <json>",
	author = "rej.chev",
	description = "...",
	version = "1.2.0",
	url = "discord.gg/ChTyPUG"
};

bool g_bLate;

Json packager;

GlobalForward
    fwdPackageUpdate,
    fwdPackageAvailable;

#include "packager/forwards.sp"
// #include "packager/context.sp"
#include "packager/natives.sp"

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) {

    CreateNative("pckg_GetPackage", Native_GetPackage);
    CreateNative("pckg_SetPackage", Native_SetPackage);
    CreateNative("pckg_HasPackage", Native_HasPackage);
    CreateNative("pckg_IsVerified", Native_IsVerified);
    CreateNative("pckg_SetArtifact", Native_SetArtifact);
    CreateNative("pckg_RemoveArtifact", Native_Remove);
    CreateNative("pckg_GetArtifact", Native_GetArtifact);
    CreateNative("pckg_HasArtifact", Native_HasArtifact);


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

bool Initialization(int iClient, const char[] auth = "STEAM_ID_SERVER") {
    Json obj = (new JsonBuilder("{}"))
                .SetInt(
                    "uid", 
                    (iClient) 
                        ? GetClientUserId(iClient) 
                        : 0
                )
                .SetString("auth", auth)
                .Build();

    bool success = pckg_SetPackage(iClient, obj);
    delete obj;

    return success;
}

public void OnPluginStart() {
    packager = new Json("{}");

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
    OnClientAuthorized(0, "STEAM_ID_SERVER");
}

public void OnClientAuthorized(int iClient, const char[] auth) {
    if(iClient && IsClientInGame(iClient) && (IsFakeClient(iClient) || IsClientSourceTV(iClient)))
        return;

    if(!Initialization(iClient, auth))
        SetFailState("What the fuck are u doing?");

    Call_StartForward(fwdPackageAvailable);
    Call_PushCell(iClient);
    Call_Finish();
}

char[] GetClientAuthIdEx(int iClient) {
    static char auth[64];

    if(!GetClientAuthId(iClient, AuthId_Steam2, auth, sizeof(auth)))
        auth = NULL_STRING;

    return auth;
}

char[] IndexToChar(int iClient) {
    static char index[4];
    FormatEx(index, sizeof(index), "%d", iClient);

    return index;
}
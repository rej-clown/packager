#if defined _packager_included
 #endinput
#endif
#define _packager_included

enum ContextLevels {
    CALL_IGNORE = -1,
    CALL_DEFAULT
};

#if defined JSON_MACRO
    #define asJSON(%0)  view_as<JSON>(%0)
    #define asJSONO(%0) view_as<JSONObject>(%0)
    #define asJSONA(%0) view_as<JSONArray>(%0)
    #define asJSONK(%0) view_as<JSONObjectKeys>(%0)
#endif

#if defined UTIL_MACRO
    #define STATUS_LENGTH       16
    #define TEAM_LENGTH         64
    #define PREFIX_LENGTH       64
    #define NAME_LENGTH         128
    #define MESSAGE_LENGTH      256
    #define MAX_LENGTH          512
#endif

forward void        pckg_OnPackageAvailable(int iClient);
forward Action      pckg_OnPackageUpdate(Handle ctx, any &level);
forward void        pckg_OnPackageUpdate_Post(Handle ctx, any level);

native Handle       pckg_GetPackage(int iClient);
native bool         pckg_SetPackage(int iClient, Handle value, any repLevel);
native bool         pckg_HasPackage(int iClient);
native bool         pckg_IsVerified(int iClient);

native bool         pckg_SetArtifact(int iClient, const char[] artifact, Handle value, any repLevel);
native bool         pckg_RemoveArtifact(int iClient, const char[] artifact, any repLevel);
native Handle       pckg_GetArtifact(int iClient, const char[] artifact);
native bool         pckg_HasArtifact(int iClient, const char[] artifact);

public SharedPlugin __pl_packager= 
{
    name = "packager",
    file = "packager.smx",
#if defined REQUIRE_PLUGIN
    required = 1
#else
    required = 0
#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_packager_SetNTVOptional()
{
    MarkNativeAsOptional("pckg_GetPackage");
    MarkNativeAsOptional("pckg_SetPackage");
    MarkNativeAsOptional("pckg_HasPackage");
    MarkNativeAsOptional("pckg_IsVerified");
    MarkNativeAsOptional("pckg_SetArtifact");
    MarkNativeAsOptional("pckg_RemoveArtifact");
    MarkNativeAsOptional("pckg_GetArtifact");
    MarkNativeAsOptional("pckg_HasArtifact");
}
#endif
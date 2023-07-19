#if defined _packager_included
 #endinput
#endif
#define _packager_included

#include <jansson>

/*
* @desc 
* 
* @param iClient - Client index
* 
* @noreturn
*/
forward void            pckg_OnPackageAvailable(int iClient);

/*
* @desc 
* 
* @param plugin - Who is an initiator
* @param iClient - Whose package was updated
* 
* @noreturn
*/
forward void            pckg_OnPackageUpdated(Handle plugin, int iClient);


methodmap Package < Handle {

    /*
    * @desc 
    * 
    * @param sig - An artifact name 
    * 
    * @return Artifact(must be freed or null)
    */
    public native Json GetArtifact(const char[] sig);

    /*
    * @desc 
    * 
    * @param sig - An artifact name
    * 
    * @return true if exists
    */
    public native bool HasArtifact(const char[] sig);

    /*
    * @desc 
    * 
    * @param sig                - An artifact name
    * @param value              - Json object with any data
    * @param freeValueOnSuccess - Free second param on success
    *
    * @return true on success
    */
    public native bool SetArtifact(const char[] sig, const Json value, bool freeValueOnSuccess = false);

    /*
    * @desc 
    * 
    * @param sig - An artifact name
    * 
    * @noreturn
    */
    public native void RemoveArtifact(const char[] a);

    // client artifacts count
    property int Artifacts {
        public native get();
    }

    // package owner user id
    property int Owner {
        public native get();
    }
}


methodmap Packager < Handle
{
    /*
    * @desc Personal client package on session period (must not freed)
    * 
    * @param i - client index
    * 
    * @return Package or null
    */
    public native static Package GetPackage(int i);
};

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
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


methodmap Packager < Handle
{
    /*
    * @desc 
    * 
    * @param i - Client index
    * 
    * @return Package(must be freed) or null
    */
    public static native Json GetPackage(int i);
    
    /*
    * @desc 
    * 
    * @param i - Client index
    * @param o - Json object with any data
    * 
    * @return true on success
    */
    public static native bool SetPackage(int i, Json o);

    /*
    * @desc 
    * 
    * @param i - Client index
    * 
    * @return true if package exists
    */
    public static native bool HasPackage(int i); 
    
    /*
    * @desc 
    * 
    * @param i - Client index
    * @param a - An artifact name 
    * 
    * @return Artifact(must be freed or null)
    */
    public static native Json GetArtifact(int i, const char[] a);

    /*
    * @desc 
    * 
    * @param i - Client index
    * @param a - An artifact name
    * @param o - Json object with any data
    * 
    * @return true on success
    */
    public static native bool SetArtifact(int i, const char[] a, Json o);
    
    /*
    * @desc 
    * 
    * @param i - Client index
    * @param a - An artifact name
    * 
    * @return true if exists
    */
    public static native bool HasArtifact(int i, const char[] a);
    
    /*
    * @desc 
    * 
    * @param i - Client index
    * @param a - An artifact name
    * 
    * @noreturn
    */
    public static native void RemoveArtifact(int i, const char[] a);
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
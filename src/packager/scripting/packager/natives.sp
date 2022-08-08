public any Native_GetPackage(Handle h, int a) {
    return packager.GetPackage(GetNativeCell(1));
}

// bool(iClient, Handle value, int level)
public any Native_SetPackage(Handle h, int a) {
    bool b;
    if((b = packager.SetPackage(
        GetNativeCell(1), view_as<Package>(GetNativeCell(2)))))
        OnPackageUpdated(h, GetNativeCell(1));

    return b;
}

// bool(iClient)
public any Native_HasPackage(Handle h, int a) {
    return packager.HasPackage(GetNativeCell(1));
}

// // bool(iClient) : "auth"?
// public any Native_IsVerified(Handle h, int a) {
//     int iClient = GetNativeCell(1);
//     bool ver;

//     JsonObject obj;
//     if((obj = asJSONO(pckg_GetPackage(iClient))) != null && obj.HasKey("auth") && !JSON_IS_NULL(obj.GetType("auth"))) {
//         char auth[64];
//         auth = GetClientAuthIdEx(iClient);

//         char buffer[64];
//         obj.GetString("auth", buffer, sizeof(buffer));

//         ver = auth[0] != 0 && strcmp(auth, buffer) == 0;
//     }

//     delete obj;
    
//     return ver;
// }

// bool(int iClient, const char[] artifact, Handle value, int repLevel)
public any Native_SetArtifact(Handle h, int a) {
    static char art[66];
    GetNativeString(2, art, sizeof(art));
    
    bool b;
    if((b = packager.SetArtifact(GetNativeCell(1), art, view_as<Json>(GetNativeCell(3)))))
        OnPackageUpdated(h, GetNativeCell(1));
    
    return b;
}

// bool(int iClient, const char[] artifact, int repLevel)
public any Native_Remove(Handle h, int a) {
    static char art[66];
    GetNativeString(2, art, sizeof(art));

    packager.RemoveArtifact(GetNativeCell(1), art);

    if(!packager.HasArtifact(GetNativeCell(1), art))
        OnPackageUpdated(h, GetNativeCell(1));

    return 0;
}

public any Native_GetArtifact(Handle h, int a) {
    static char art[66];
    GetNativeString(2, art, sizeof(art));

    return packager.GetArtifact(GetNativeCell(1), art);
}

public any Native_HasArtifact(Handle h, int a) {
    static char art[66];
    GetNativeString(2, art, sizeof(art));

    return packager.HasArtifact(GetNativeCell(1), art);
}
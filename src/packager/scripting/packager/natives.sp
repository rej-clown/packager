public any Native_GetPackage(Handle h, int a) {
    
    return packager.GetPackage(GetNativeCell(1));
}

public any Native_SetArtifact(Handle h, int a) {
    
    Package pck = view_as<Package>(GetNativeCell(1));

    static char name[MAX_NAME_LENGTH];
    GetNativeString(2, name, sizeof(name));
    
    bool success;
    if((success = pck.SetArtifact(
        name, 
        GetNativeCell(3), 
        GetNativeCell(4))
    )) OnPackageUpdated(h, GetClientOfUserId(pck.Owner));

    return success;    
}

public any Native_RemoveArtifact(Handle h, int a) {

    Package pck = view_as<Package>(GetNativeCell(1));

    static char name[MAX_NAME_LENGTH];
    GetNativeString(2, name, sizeof(name));

    int current = pck.Artifacts;

    pck.RemoveArtifact(name); 

    if(current != pck.Artifacts)
        OnPackageUpdated(h, GetClientOfUserId(pck.Owner));

    return 1;
}

public any Native_GetArtifact(Handle h, int a) {
    
    static char name[MAX_NAME_LENGTH];
    GetNativeString(2, name, sizeof(name));
    
    return view_as<Package>(GetNativeCell(1))
        .GetArtifact(name);
}

public any Native_HasArtifact(Handle h, int a) {
    
    static char name[MAX_NAME_LENGTH];
    GetNativeString(2, name, sizeof(name));
    
    return view_as<Package>(GetNativeCell(1))
        .HasArtifact(name);
}

public any Native_Artifacts(Handle h, int a) {
    return view_as<Package>(GetNativeCell(1)).Artifacts;
}

public any Native_PackageOwner(Handle h, int a) {
    return view_as<Package>(GetNativeCell(1)).Owner;
}
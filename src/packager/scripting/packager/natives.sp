public any Native_GetPackage(Handle h, int a) {
    static char index[4];
    FormatEx(index, sizeof(index), "%d", GetNativeCell(1));

    if(asJSONO(packager).HasKey(index))
        return asJSONO(packager).Get(index);
    
    return 0;
}

// bool(iClient, Handle value, int level)
public any Native_SetPackage(Handle h, int a) {
    Json o;
    if((o = asJSON(GetNativeCell(2))) == null || JSON_TYPE_EQUAL(o, JSON_NULL))
        return 0;
    
    asJSONO(packager).Set(IndexToChar(GetNativeCell(1)), o);

    OnPackageUpdated(h, GetNativeCell(1));
    return 1;
    // return context(h, GetNativeCell(1), NULL_STRING, asJSON(GetNativeCell(2)), GetNativeCell(3)) < Plugin_Handled;
}

// bool(iClient)
public any Native_HasPackage(Handle h, int a) {
    return asJSONO(packager).HasKey(IndexToChar(GetNativeCell(1)));
}

// bool(iClient) : "auth"?
public any Native_IsVerified(Handle h, int a) {
    int iClient = GetNativeCell(1);
    bool ver;

    JsonObject obj;
    if((obj = asJSONO(pckg_GetPackage(iClient))) != null && obj.HasKey("auth") && !JSON_IS_NULL(obj.GetType("auth"))) {
        char auth[64];
        auth = GetClientAuthIdEx(iClient);

        char buffer[64];
        obj.GetString("auth", buffer, sizeof(buffer));

        ver = auth[0] != 0 && strcmp(auth, buffer) == 0;
    }

    delete obj;
    
    return ver;
}

// bool(int iClient, const char[] artifact, Handle value, int repLevel)
public any Native_SetArtifact(Handle h, int a) {
    int iClient = GetNativeCell(1);

    if(!pckg_HasPackage(iClient))
        return false;

    static char artifact[PREFIX_LENGTH];
    GetNativeString(2, artifact, sizeof(artifact));

    Json o = asJSON(pckg_GetPackage(iClient));
    asJSONO(o).Set(artifact, asJSON(GetNativeCell(3)));
    pckg_SetPackage(iClient, o);

    delete o;

    OnPackageUpdated(h, iClient);

    return true;
    // return context(h, GetNativeCell(1), artifact, asJSON(GetNativeCell(3)), GetNativeCell(4)) < Plugin_Handled;
}

// bool(int iClient, const char[] artifact, int repLevel)
public any Native_Remove(Handle h, int a) {
    int iClient = GetNativeCell(1);

    if(!pckg_HasPackage(iClient))
        return false;

    static char artifact[64];
    GetNativeString(2, artifact, sizeof(artifact));

    Json o = asJSON(pckg_GetPackage(iClient));
    asJSONO(o).Remove(artifact);
    pckg_SetPackage(iClient, o);

    delete o;

    OnPackageUpdated(h, iClient);
    return true;
    // return context(h, GetNativeCell(1), artifact, null, GetNativeCell(3)) < Plugin_Handled;
}

public any Native_GetArtifact(Handle h, int a) {
    int iClient = GetNativeCell(1);

    if(!pckg_HasPackage(iClient))
        return 0;

    static char artifact[64];
    GetNativeString(2, artifact, sizeof(artifact));

    JsonObject client;
    client = asJSONO(pckg_GetPackage(iClient));
    
    Json obj;
    if(client.HasKey(artifact) && !JSON_IS_NULL(client.GetType(artifact)))
        obj = client.Get(artifact);

    delete client;
    return obj;
}

public any Native_HasArtifact(Handle h, int a) {
    int iClient = GetNativeCell(1);

    if(!pckg_HasPackage(iClient))
        return false;

    static char artifact[64];
    GetNativeString(2, artifact, sizeof(artifact));

    JsonObject client;
    client = asJSONO(pckg_GetPackage(iClient));
    
    bool has = client.HasKey(artifact) && !JSON_IS_NULL(client.GetType(artifact));

    delete client;
    return has;
}
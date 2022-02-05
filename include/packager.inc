#if defined _packager_included
 #endinput
#endif
#define _packager_included

forward void            pckg_OnPackageAvailable(int iClient);
forward void            pckg_OnPackageUpdated(Handle plugin, int iClient);

methodmap Packager < Handle
{
    public static native bool HasPackage(int i); 
    public static native JsonObject GetPackage(int i);
    public static native bool SetPackage(int i, JsonObject o);
    public static native Json GetArtifact(int i, const char[] a);
    public static native bool HasArtifact(int i, const char[] a);
    public static native void RemoveArtifact(int i, const char[] a);
    public static native bool SetArtifact(int i, const char[] a, Json o);
};

// Возвращает пакет со всеми ключами клиента (JSONObject)
// По-умолчанию доступны поля: "auth" - Steam2, "id" - UserId
#pragma deprecated Use methodmap instead
stock Handle       pckg_GetPackage(int iClient) {
    return Packager.GetPackage(iClient);
}

// Перезаписывает пакет клиента на value (JSONObject)
// repLevel - ContextLevels (enum)
#pragma deprecated Use methodmap instead
stock bool         pckg_SetPackage(int iClient, Handle value, any repLevel = 0) {
    Packager.SetPackage(iClient, view_as<JsonObject>(value));
}

// Существует ли пакет для клиента
#pragma deprecated Use methodmap instead
stock bool         pckg_HasPackage(int iClient) {
    return Packager.HasPackage(iClient);
}

// Проверка поля "auth" на валидность
#pragma deprecated Already removed
stock bool         pckg_IsVerified(int iClient) {
    return true;
}

// Добавлет артефакт к пакету клиента по ключу (JSON)
#pragma deprecated Use methodmap instead
stock bool         pckg_SetArtifact(int iClient, const char[] artifact, Handle value, any repLevel = 0) {
    return Packager.SetArtifact(iClient, artifact, view_as<Json>(value));
}

// Удаляет артефакт по ключу
#pragma deprecated Use methodmap instead
stock bool         pckg_RemoveArtifact(int iClient, const char[] artifact, any repLevel = 0) {
    Packager.RemoveArtifact(iClient, artifact);
    return true;
}

// Возвращает артефакт по ключу (JSON)
#pragma deprecated Use methodmap instead
stock Handle       pckg_GetArtifact(int iClient, const char[] artifact) {
    return Packager.GetArtifact(iClient, artifact);
}

// Проверяет наличие артефакта в пакете клиента по ключу
#pragma deprecated Use methodmap instead
stock bool         pckg_HasArtifact(int iClient, const char[] artifact) {
    return Packager.HasArtifact(iClient, artifact);
}


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
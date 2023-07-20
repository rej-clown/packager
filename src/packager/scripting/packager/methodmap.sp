#define JSON_INCLUDE_BUILDER

#include <jansson>

methodmap Package < Handle
{
    public Package(int iClient, const char[] auth) {
        
        int owner;
        if(iClient)
            owner = GetClientUserId(iClient);

        return view_as<Package>(
            (new JsonBuilder("{}"))
                .SetString("auth", auth)
                .SetInt("owner", owner)
                .Build()
        );
    }

    public bool HasArtifact(const char[] k)
    {
        JsonType type = asJSONO(this).GetType(k);

        return type == JObjectType || type == JArrayType;
    }

    public bool SetArtifact(const char[] key, const Json value) {
        return asJSONO(this).Set(key, value);
    }

    public Json GetArtifact(const char[] key) {
        return asJSONO(this).Get(key);
    }

    property JsonType Type {
        public get() {
            return asJSON(this).Type;
        }
    }

    property int Artifacts {
        public get() {
            return asJSONO(this).Size;
        }
    }

    property int Owner {
        public get() {
            
            int owner;
            if(!asJSONO(this).TryGetInt("owner", owner))
                owner = -1;

            if(owner == -1)
                LogError("Package(%x) structure is broken: field 'owner' is missing", this);

            return owner;
        }
    }

    public void RemoveArtifact(const char[] k)
    {
        if(this.HasArtifact(k))
            asJSONO(this).Remove(k);
    }
}

methodmap Packager < Handle
{
    public Packager() {
        return view_as<Packager>(new ArrayList());
    }

    public int FindPackage(int i) {
        if(i < 0 || i > MAXPLAYERS)
            return -1;

        return view_as<ArrayList>(this).FindValue(i);
    }

    public bool SetPackage(int i, const Package o) {
        if(i < 0 || i > MAXPLAYERS)
            return false;

        if(!o || o.Type != JObjectType)
            return false;

        this.RemovePackage(i);

        view_as<ArrayList>(this).Push(i);
        view_as<ArrayList>(this).Push(o);

        return true;
    }

    public Package GetPackage(int i) {
        int pos;
        if((pos = this.FindPackage(i)) == -1)
            return null;

        if(pos+1 == view_as<ArrayList>(this).Length) {
            view_as<ArrayList>(this).Erase(pos);
            return null;
        }
            
        return view_as<ArrayList>(this).Get(pos + 1); 
    }

    public void RemovePackage(int i) {
        int pos;
        if((pos = this.FindPackage(i)) == -1)
            return;

        if(pos+1 == view_as<ArrayList>(this).Length) {
            view_as<ArrayList>(this).Erase(pos);
            return;
        }

        delete asJSON(view_as<ArrayList>(this).Get(pos + 1));

        view_as<ArrayList>(this).Erase(pos + 1);
        view_as<ArrayList>(this).Erase(pos);
    }

    public void Clear() {
        
        for(int i = 1, s = view_as<ArrayList>(this).Length; i < s; i+=2)
            delete asJSON(view_as<ArrayList>(this).Get(i));

        view_as<ArrayList>(this).Clear();
    }    
};

stock char[] viewIdxAsChar(int i)
{
    char out[4];
    FormatEx(out, sizeof(out), "%s", i);
    return out;
}

stock char[] GetClientAuthIdEx(int idx)
{
    char out[66];

    if(idx && !GetClientAuthId(idx, AuthId_Engine, out, sizeof(out)))
        out = NULL_STRING;
    
    if(!idx)
        out = "STEAM_ID_SERVER";

    return out;
}
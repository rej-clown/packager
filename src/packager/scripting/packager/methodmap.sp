// #define VERIFY_SUCCESS              0x00
// #define VERIFY_INVALID_VALUE_IDX    0x01
// #define VERIFY_INVALID_VALUE_AUTH   0x02
// #define VERIFY_INVALID_TYPE_IDX     0x04
// #define VERIFY_INVALID_TYPE_AUTH    0x06
// #define VERIFY_

methodmap Package < JsonObject
{
    public Package(int idx, const char[] v)
    {
        Json o;
        if(!JSON_TYPE_EQUAL((o = new Json(v)), JSON_OBJECT))
            delete o;

        if(o)
        {
            asJSONO(o).SetString("auth", GetClientAuthIdEx(idx));
            asJSONO(o).SetInt("idx", (idx) ? GetClientUserId(idx) : 0);
        }
        
        return view_as<Package>(o);
    }

    public bool HasArtifact(const char[] k)
    {
        return this.HasKey(k) && (
            JSONO_TYPE_EQUAL(this, k, JSON_OBJECT) ||
            JSONO_TYPE_EQUAL(this, k, JSON_ARRAY)
        )
    }

    public void RemoveArtifact(const char[] k)
    {
        if(this.HasArtifact(k))
            this.Remove(k);
    }

    // TODO: the next gen :/
    // public int IsVerified(int idx){
    //     int userid;
    //     char auth[66];

    //     if(this )

    //     if(!()); 
    //         return
    // }
}

methodmap Packager < JsonObject
{
    public Packager()
    {
        return view_as<Packager>(new Json("{}"));
    }

    public bool HasPackage(int i)
    {
        return this.HasKey(viewIdxAsChar(i));
    }

    public bool SetPackage(int i, Package o)
    {
        if(!o || JSON_TYPE_EQUAL(o, JSON_NULL))
            return false;

        return this.Set(viewIdxAsChar(i), o);
    }

    public Package GetPackage(int i)
    {
        return (this.HasPackage(i)) 
                    ? view_as<Package>(this.Get(viewIdxAsChar(i)))
                    : view_as<Package>(null); 
    }

    public bool CreatePackage(int i, const char[] v = "{}")
    {
        // use .SetPackage() if package already exist
        if(i < 0 || i >= MAXPLAYERS || this.HasPackage(i))
            return false;
        
        Package p;
        if(!(p = new Package(i, v)))
            return false;
        
        bool b = this.SetPackage(i, p);
        delete p;

        return b;
    }

    public bool HasArtifact(int i, const char[] artifact)
    {
        if(!this.HasPackage(i))
            return false;
        
        Package o = this.GetPackage(i);

        bool out = o.HasArtifact(artifact);

        delete o;
        return out;
    }

    public void RemovePackage(int i)
    {
        if(this.HasPackage(i))
            this.Remove(viewIdxAsChar(i));
    }

    public Json GetArtifact(int i, const char[] artifact)
    {
        if(!this.HasPackage(i) || !this.HasArtifact(i, artifact))
            return null;

        Package o = this.GetPackage(i);

        Json a = o.Get(artifact);
        delete o; 

        return a;
    }

    public bool SetArtifact(int i, const char[] artifact, Json v)
    {
        if(!this.HasPackage(i))
            return false;

        Package o = this.GetPackage(i);
        o.Set(artifact, v);

        bool b = this.SetPackage(i, o);
        delete o; 

        return b;
    }

    

    public void RemoveArtifact(int i, const char[] artifact)
    {
        if(!this.HasPackage(i))
            return;
        
        Package p = this.GetPackage(i);
        p.RemoveArtifact(artifact);

        this.SetPackage(i, p);

        delete p;
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
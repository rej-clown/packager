#define JSON_INCLUDE_BUILDER

#include <packager>

public void pckg_OnPackageAvailable(int iClient) {

    Package pck = Packager.GetPackage(iClient);

    Json o;
    char dump[1024];
    pck.SetArtifact( 
        "test", 
        (o = (new JsonBuilder("{}"))
                .Set("test", null)
                .SetBool("text", false)
                .SetInt("value", 213123)
                .SetString("valu", "who are u?")
                .SetFloat("pi", 3.15)
                .Build()
        ),
        freeAnyway
    );

    pck.SetArtifact( 
        "test2", 
        (o = (new JsonBuilder("[]"))
                .Push(null)
                .PushInt(iClient)
                .PushString("guse")
                .PushFloat(3.14)
                .Build()
        ),
        freeAnyway
    );

    o = asJSON(pck);
    if(o.Dump(dump, sizeof(dump), JsonPretty(4)|JsonFloatPrecision(3), true))
        LogMessage("Test package (client: %d): \n%s", iClient, dump);
}
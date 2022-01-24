#include <packager>
#include <jansson>


public void OnPluginStart() {
    Json b;
    Json d;
    Json o = (new JsonBuilder("{}"))
                .Set("v", (b = new Json("{}")))
                .Set("d", (d = new Json("[]")))
                .Build();

    delete b;
    delete d;
}

public void pckg_OnPackageAvailable(int iClient) {
    Json o;
    if(!iClient) {
        for(int i = 1; i <= MAXPLAYERS; i++) {
            if(!pckg_HasPackage(i))
                pckg_SetPackage(i, (o = new Json("{}")));

            delete o;
        }
    }

    // LogMessage("Client: %d", iClient);

    // if(iClient != (MAXPLAYERS))
    //     return;

    char dump[1024];
    for(int i; i <= MaxClients; i++) {
        if(!pckg_HasPackage(i)) 
            continue;

        pckg_SetArtifact(
            i, 
            "test", 
            (o = (new JsonBuilder("{}"))
                    .Set("test", null)
                    .SetBool("text", false)
                    .SetInt("value", 213123)
                    .SetString("valu", "who are u?")
                    .SetFloat("pi", 3.15)
                    .Build()
            )
        );

        delete o;

        pckg_SetArtifact(
            i, 
            "test2", 
            (o = (new JsonBuilder("[]"))
                    .Push(null)
                    .PushBool(i == 0)
                    .PushInt(i)
                    .PushString("guse")
                    .PushFloat(3.14)
                    .Build()
            )
        );

        delete o;

        o = asJSON(pckg_GetPackage(i));
        o.ToString(dump, sizeof(dump), JSON_INDENT(4));

        LogMessage("Test package (client: %d): \n%s", i, dump);

        delete o;
    }

    o = asJSON(pckg_GetPackage(0));
    o.ToString(dump, sizeof(dump), JSON_INDENT(4));

    LogMessage("Test package (client: %d): \n%s", 0, dump);

    delete o;
}
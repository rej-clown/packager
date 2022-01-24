// Action context(Handle plugin, int iClient, const char[] artifact, Json value, any level) {
//     if(!artifact[0] && (!value || JSON_TYPE_EQUAL(value, JSON_NULL)))
//         return Plugin_Handled;
    
//     Json v = asJSON(CloneHandle(value)), ctx;


//     // char dump[1024];
//     // v.ToString(dump, sizeof(dump), JSON_INDENT(4));

//     // LogMessage("CONTEXT (%d): \n%s", iClient, dump);    

//     // ctx = (new JsonBuilder("{}"))
//     //             .SetString("part", ((artifact[0]) ? artifact : "model"))
//     //             .SetInt("client", (iClient) ? iClient : 0)
//     //             .Set((artifact[0]) ? artifact : "model", v)
//     //             .SetInt("caller", view_as<int>(plugin))
//     //             .Build();

//     Action ok;
//     // if(level != CALL_IGNORE && (ok = updatePackage(ctx, level)) == Plugin_Changed) {
//     //     Json o;
//     //     if(artifact[0] || !JSON_TYPE_EQUAL((o = asJSONO(ctx).Get((artifact[0]) ? artifact : "model")), JSON_NULL)) {
//     //         delete v;
//     //         v = o;
//     //     }

//     //     delete o;
//     // }

//     // delete ctx;

//     // if(ok > Plugin_Changed) {
//     //     delete v;
//     //     return ok;
//     // }

//     ctx = (artifact[0]) ? asJSON(pckg_GetPackage(iClient)) : v;

//     if(artifact[0]) 
//     {
//         if(JSON_TYPE_EQUAL(v, JSON_NULL))
//             asJSONO(ctx).Remove(artifact);
//         else  
//             asJSONO(ctx).Set(artifact, v);    
//     }

//     asJSONO(packager).Set(IndexToChar(iClient), ctx);
    
//     delete ctx;
//     return ok;
// }
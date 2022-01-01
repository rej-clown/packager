Action context(Handle plugin, int iClient, const char[] artifact, JSON value, any level) {
    JSONObject ctx = new JSONObject();

    if(level != CALL_IGNORE) {
        ctx.SetBool("isArtifact", artifact[0] != 0);
        ctx.SetInt("client", (iClient) ? GetClientUserId(iClient) : 0);
        ctx.SetString("field", (artifact[0]) ? artifact : "model");

        if(value)
            ctx.Set((artifact[0]) ? artifact : "model", value);
        
        ctx.SetInt("caller", view_as<int>(plugin));
    }

    JSON obj;
    JSON temp;
    Action ok;

    static char szBuffer[PREFIX_LENGTH];

#if defined DEBUG
    static char valve[MAX_LENGTH];
#endif

    if(level == CALL_IGNORE || (ok = updatePackage(ctx, level)) < Plugin_Handled) {
        FormatEx(szBuffer, sizeof(szBuffer), "%d", iClient);

        if(ok == Plugin_Changed)
            temp =  ctx.HasKey((artifact[0]) ? artifact : "model") 
                 ?  ctx.Get((artifact[0]) ? artifact : "model")
                 :  null;
        
        else temp = (value) ? asJSON(CloneHandle(value)) : null;

#if defined DEBUG
        if(temp)
            temp.ToString(valve, sizeof(valve), 0);

        DWRITE("%s: context(temp): \
                \n\t\t\t\tClient: %N \
                \n\t\t\t\tBuffer: %s", DEBUG, iClient, (temp) ? valve : "");
#endif

        if(temp || artifact[0])
            obj = (artifact[0]) ? asJSON(pckg_GetPackage(iClient)) : temp;

        if(artifact[0]) {
            if(!temp)
                asJSONO(obj).Remove(artifact);

            else asJSONO(obj).Set(artifact, temp);

#if defined DEBUG
            obj.ToString(valve, sizeof(valve), 0);

            DWRITE("%s: context(artifact): \
                    \n\t\t\t\tClient: %N \
                    \n\t\t\t\tBuffer: %s", DEBUG, iClient, valve);
#endif
            if(temp)
                delete temp;
        }

        if(!obj)
            packager.Remove(szBuffer);
        else packager.Set(szBuffer, obj);
    }

    delete ctx;
    delete obj;

#if defined DEBUG
    asJSON(packager).ToString(valve, sizeof(valve), 0);

    DWRITE("%s: context(): \
            \n\t\t\t\tClient: %N \
            \n\t\t\t\tBuffer: %s", DEBUG, iClient, valve);
#endif

    return ok;
}
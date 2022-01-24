// Action updatePackage(Json context, int level) {
//     Action result = Plugin_Continue;

//     Call_StartForward(fwdPackageUpdate);
//     Call_PushCell(context);
//     Call_PushCellRef(level);
//     Call_Finish(result);

//     if(result == Plugin_Stop)
//         return result;
    
//     Json back = asJSON(CloneHandle(context));
//     Call_StartForward(fwdPackageUpdate_Post);
//     Call_PushCell(back);
//     Call_PushCell(level);
//     Call_Finish();

//     delete back;

//     return result;
// }

void OnPackageUpdated(Handle plugin, int iClient) {
    Call_StartForward(fwdPackageUpdate);
    Call_PushCell(plugin);
    Call_PushCell(iClient);
    Call_Finish();
}
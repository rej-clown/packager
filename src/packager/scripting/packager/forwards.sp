void OnPackageUpdated(Handle plugin, int iClient) {
    Call_StartForward(fwdPackageUpdate);
    Call_PushCell(plugin);
    Call_PushCell(iClient);
    Call_Finish();
}
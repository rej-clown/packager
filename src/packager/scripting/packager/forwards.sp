Action updatePackage(JSON context, int level) {
    Action result = Plugin_Continue;

    Call_StartForward(fwdPackageUpdate);
    Call_PushCell(context);
    Call_PushCellRef(level);
    Call_Finish(result);

    if(result == Plugin_Stop)
        return result;
    
    Call_StartForward(fwdPackageUpdate_Post);
    Call_PushCell(context)
    Call_PushCell(level);
    Call_Finish();

    return result;
}
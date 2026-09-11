permissionset 72500 "TaskletELK, Read"
{
    Caption = 'Read Tasklet Elkotex', MaxLength = 30, Locked = true;
    Assignable = true;
    Permissions =
        codeunit "Tasklet Mgt." = X;
}

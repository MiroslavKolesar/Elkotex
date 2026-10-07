permissionset 72500 "TaskletELK, Read"
{
    Caption = 'Read Tasklet Elkotex', MaxLength = 30, Locked = true;
    Assignable = true;
    Permissions =
        codeunit "MOB WMS Ship Cx Tasklet" = X,
        codeunit "MOB Pack Feature Management" = X,
        codeunit "Report Sel. Events Tasklet" = X,
        codeunit "Shipment Print Mgt. Tasklet" = X,
        codeunit "Tasklet Mgt." = X;
}

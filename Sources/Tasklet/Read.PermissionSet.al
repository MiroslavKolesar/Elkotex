permissionset 72500 "TaskletELK, Read"
{
    Caption = 'Read Tasklet Elkotex', MaxLength = 30, Locked = true;
    Assignable = true;
    Permissions =
        codeunit "MOB Pack Feature Management" = X,
        codeunit "MOB WMS Ship Cx Tasklet" = X,
        codeunit "Report Sel. Events Tasklet" = X,
        codeunit "Shipment Print Mgt. Tasklet" = X,
        codeunit "Tasklet Mgt." = X,
        report "Tasklet Sales Shipment" = X;
}

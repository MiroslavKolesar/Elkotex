codeunit 72501 "MOB WMS Ship Cx Tasklet"
{
    Access = Internal;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MOB WMS Ship", OnPostShipOrder_OnBeforeRunWhsePostShipment, '', false, false)]
    local procedure MOBWMSShipOnPostShipOrderOnBeforeRunWhsePostShipment(var _WhseShipmentLinesToPost: Record "Warehouse Shipment Line")
    var
        ShipmentPrintMgt: Codeunit "Shipment Print Mgt. Tasklet";
    begin
        ShipmentPrintMgt.PreparePrint(_WhseShipmentLinesToPost);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MOB WMS Ship", OnPostShipOrder_OnAfterPostWarehouseShipment, '', false, false)]
    local procedure MOBWMSShipOnPostShipOrderOnAfterPostWarehouseShipment()
    var
        ShipmentPrintMgt: Codeunit "Shipment Print Mgt. Tasklet";
    begin
        ShipmentPrintMgt.PrintDocuments();
    end;
}
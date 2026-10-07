codeunit 72502 "Shipment Print Mgt. Tasklet"
{
    Access = Internal;
    SingleInstance = true;
    Permissions =
        tabledata "MOB Report Print Setup" = r,
        tabledata "Sales Header" = r,
        tabledata "Sales Shipment Header" = r;

    var
        TempSalesHeaderToPrint: Record "Sales Header" temporary;

    procedure PreparePrint(var WarehouseShipmentLine: Record "Warehouse Shipment Line")
    var
        MobReportPrintSetup: Record "MOB Report Print Setup";
        SalesHeader: Record "Sales Header";
        WarehouseShipmentLineToCheck: Record "Warehouse Shipment Line";
    begin
        TempSalesHeaderToPrint.Reset();
        TempSalesHeaderToPrint.DeleteAll();

        if not MobReportPrintSetup.Get() then
            exit;
        if not MobReportPrintSetup."Auto Print LP Contents" then
            exit;
        if MobReportPrintSetup."LP Shipment Method Code" = '' then
            exit;

        WarehouseShipmentLineToCheck.Copy(WarehouseShipmentLine);
        WarehouseShipmentLineToCheck.SetLoadFields("Source Type", "Source Subtype", "Source No.");
        if WarehouseShipmentLineToCheck.FindSet() then
            repeat
                if WarehouseShipmentLineToCheck."Source Type" = Database::"Sales Line" then begin
                    SalesHeader.SetLoadFields("Shipment Method Code", "Last Shipping No.");
                    if SalesHeader.Get(WarehouseShipmentLineToCheck."Source Subtype", WarehouseShipmentLineToCheck."Source No.") then
                        if SalesHeader."Shipment Method Code" = MobReportPrintSetup."LP Shipment Method Code" then
                            if not TempSalesHeaderToPrint.Get(SalesHeader."Document Type", SalesHeader."No.") then begin
                                TempSalesHeaderToPrint := SalesHeader;
                                TempSalesHeaderToPrint.Insert();
                            end;
                end;
            until WarehouseShipmentLineToCheck.Next() = 0;
    end;

    procedure PrintDocuments()
    var
        ReportSelections: Record "Report Selections";
        SalesHeader: Record "Sales Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        DocumentsToPrintExist: Boolean;
    begin
        TempSalesHeaderToPrint.Reset();
        if TempSalesHeaderToPrint.FindSet() then
            repeat
                SalesHeader.SetLoadFields("Last Shipping No.");
                if SalesHeader.Get(TempSalesHeaderToPrint."Document Type", TempSalesHeaderToPrint."No.") then
                    if (SalesHeader."Last Shipping No." <> '') and
                       (SalesHeader."Last Shipping No." <> TempSalesHeaderToPrint."Last Shipping No.")
                    then
                        if SalesShipmentHeader.Get(SalesHeader."Last Shipping No.") then begin
                            SalesShipmentHeader.Mark(true);
                            DocumentsToPrintExist := true;
                        end;
            until TempSalesHeaderToPrint.Next() = 0;

        TempSalesHeaderToPrint.DeleteAll();

        if DocumentsToPrintExist then begin
            SalesShipmentHeader.MarkedOnly(true);
            ReportSelections.PrintWithDialogForCust(
                Enum::"Report Selection Usage"::"Tasklet Shipment",
                SalesShipmentHeader,
                false,
                SalesShipmentHeader.FieldNo("Bill-to Customer No."));
        end;
    end;
}
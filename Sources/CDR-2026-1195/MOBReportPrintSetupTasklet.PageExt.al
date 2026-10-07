pageextension 72500 "MOB Print Setup Tasklet" extends "MOB Report Print Setup"
{
    layout
    {
        addafter("Print Shipment on Post")
        {
            group("License Plate Printing")
            {
                ShowCaption = false;
                field(LPShipmentMethodCode; Rec."LP Shipment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the sales order shipment method for which License Plate contents labels are printed automatically.';
                }
                field(AutoPrintLPContents; Rec."Auto Print LP Contents")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether License Plate contents labels are printed automatically after posting in Mobile WMS Shipping.';
                }
            }
        }
    }
}
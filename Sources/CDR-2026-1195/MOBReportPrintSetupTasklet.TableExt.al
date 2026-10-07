tableextension 72500 "MOB Print Setup Tasklet" extends "MOB Report Print Setup"
{
    fields
    {
        field(72500; "Auto Print LP Contents"; Boolean)
        {
            Caption = 'Auto Print - Package Content Label';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Auto Print LP Contents" and ("LP Shipment Method Code" = '') then
                    FieldError("LP Shipment Method Code", ShipmentMethodRequiredErr);
            end;
        }
        field(72501; "LP Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            DataClassification = CustomerContent;
            TableRelation = "Shipment Method".Code;

            trigger OnValidate()
            begin
                if ("LP Shipment Method Code" = '') and "Auto Print LP Contents" then
                    FieldError("LP Shipment Method Code", ShipmentMethodRequiredErr);
            end;
        }
    }

    var
        ShipmentMethodRequiredErr: Label 'A shipment method code must be specified before automatic License Plate contents printing can be enabled.';
}
report 72500 "Tasklet Sales Shipment"
{
    Caption = 'Tasklet Sales Shipment';
    DefaultRenderingLayout = TaskletSalesShipmentRDLC;
    Extensible = false;
    PreviewMode = PrintLayout;
    UsageCategory = None;

    dataset
    {
        dataitem(SalesShipmentHeader; "Sales Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Posted Sales Shipment';

            dataitem(PrintLoop; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));

                column(ShipmentNo; SalesShipmentHeader."No.")
                {
                }
                column(EncodedShipmentNo; EncodedShipmentNo)
                {
                }
                column(RecipientName; RecipientName)
                {
                }
                column(RecipientAddress; RecipientAddress)
                {
                }
                column(CompanyName; CompanyName)
                {
                }
                column(CompanyAddress; CompanyAddress)
                {
                }
                column(NoCaption; NoLbl)
                {
                }
                column(DescriptionCaption; DescriptionLbl)
                {
                }
                column(QuantityCaption; QuantityLbl)
                {
                }
                column(UnitCaption; UnitLbl)
                {
                }

                dataitem(SalesShipmentLine; "Sales Shipment Line")
                {
                    DataItemLink = "Document No." = field("No.");
                    DataItemLinkReference = SalesShipmentHeader;
                    DataItemTableView = sorting("Document No.", "Line No.");

                    column(LineNo; "Line No.")
                    {
                    }
                    column(ItemNo; "No.")
                    {
                    }
                    column(Description; Description)
                    {
                    }
                    column(Quantity; Quantity)
                    {
                    }
                    column(UnitOfMeasureCode; "Unit of Measure Code")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if ("No." = '') and (Description = '') and (Quantity = 0) then
                            CurrReport.Skip();
                    end;
                }

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then
                        Codeunit.Run(Codeunit::"Sales Shpt.-Printed", SalesShipmentHeader);
                end;
            }

            trigger OnAfterGetRecord()
            var
                BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
            begin
                CurrReport.Language := LanguageMgt.GetLanguageIdOrDefault("Language Code");
                CurrReport.FormatRegion := LanguageMgt.GetFormatRegionOrDefault("Format Region");
                FormatAddress.SetLanguageCode("Language Code");

                FormatAddress.GetCompanyAddr("Responsibility Center", ResponsibilityCenter, CompanyInformation, CompanyAddressLines);
                FormatAddress.SalesShptShipTo(RecipientAddressLines, SalesShipmentHeader);

                CompanyName := CompanyAddressLines[1];
                CompanyAddress := GetAddressText(CompanyAddressLines, 2);
                RecipientName := RecipientAddressLines[1];
                RecipientAddress := GetAddressText(RecipientAddressLines, 2);

                BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                EncodedShipmentNo := BarcodeFontProvider2D.EncodeFont(
                    "No.", Enum::"Barcode Symbology 2D"::"Data Matrix");
            end;
        }
    }

    rendering
    {
        layout(TaskletSalesShipmentRDLC)
        {
            Type = RDLC;
            LayoutFile = './Sources/Layouts/TaskletSalesShipment.rdlc';
            Caption = 'Tasklet Sales Shipment (RDLC)';
            Summary = 'Tasklet sales shipment label in 4 x 6 inch format.', Locked = true;
        }
    }

    trigger OnInitReport()
    begin
        CompanyInformation.Get();
    end;

    var
        CompanyInformation: Record "Company Information";
        ResponsibilityCenter: Record "Responsibility Center";
        FormatAddress: Codeunit "Format Address";
        LanguageMgt: Codeunit Language;
        CompanyAddressLines: array[8] of Text[100];
        RecipientAddressLines: array[8] of Text[100];
        CompanyAddress: Text;
        CompanyName: Text[100];
        EncodedShipmentNo: Text;
        RecipientAddress: Text;
        RecipientName: Text[100];
        DescriptionLbl: Label 'Description';
        NoLbl: Label 'No.';
        QuantityLbl: Label 'Quantity';
        UnitLbl: Label 'Unit';

    local procedure GetAddressText(AddressLines: array[8] of Text[100]; StartIndex: Integer): Text
    var
        TypeHelper: Codeunit "Type Helper";
        LineNo: Integer;
        AddressText: Text;
    begin
        for LineNo := StartIndex to ArrayLen(AddressLines) do
            if AddressLines[LineNo] <> '' then begin
                if AddressText <> '' then
                    AddressText += TypeHelper.LFSeparator();
                AddressText += AddressLines[LineNo];
            end;

        exit(AddressText);
    end;
}
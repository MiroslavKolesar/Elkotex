codeunit 72500 "Tasklet Mgt."
{
    //CDR-2026-1193
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MOB Item Reference Mgt.", 'OnBeforeSearchItemReference', '', true, true)]
    internal procedure OnBeforeSearchItemReference(_ScannedBarcode: Code[50]; var _ReturnItemNo: Code[20]; var _ReturnVariantCode: Code[10]; var _ReturnUoMCode: Code[10]; var _IsHandled: Boolean)
    var
        ItemReference: Record "Item Reference";
        TempItem: Record Item temporary;
    begin
        ItemReference.Reset();
        ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::"Bar Code");
        ItemReference.SetRange("Reference No.", _ScannedBarcode);
        if ItemReference.FindSet() then
            repeat
                if not TempItem.Get(ItemReference."Item No.") then begin
                    TempItem.Init();
                    TempItem."No." := ItemReference."Item No.";
                    TempItem.Insert();
                end;
            until ItemReference.Next = 0;
        TempItem.Reset();
        if TempItem.FindSet() then begin
            repeat
                if _ReturnItemNo = '' then
                    _ReturnItemNo := TempItem."No."
                else
                    _ReturnItemNo += '|' + TempItem."No.";
            until TempItem.Next = 0;
            _IsHandled := true;
        end;
    end;

    //CDR-2026-1197
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MOB WMS Receive", 'OnGetReceiveOrderLines_OnAfterSetFromWarehouseReceiptLine', '', true, true)]
    local procedure OnGetReceiveOrderLines_OnAfterSetFromWarehouseReceiptLine(_WhseReceiptLine: Record "Warehouse Receipt Line"; var _BaseOrderLineElement: Record "MOB NS BaseDataModel Element")
    var
        Item2: Record Item;
        ElementText: Text;
    begin
        Item2.SetLoadFields("Expiration Calculation-RclBm");
        if not Item2.Get(_WhseReceiptLine."Item No.") then
            exit;
        if Format(Item2."Expiration Calculation-RclBm") <> '' then
            ElementText := Item2.FieldCaption("Expiration Calculation-RclBm") + ': ' + Format(Item2."Expiration Calculation-RclBm");
        //if Format(Item2."Expiration Calc. HR-RclBm") <> '' then
        //    ElementText := Item2.FieldCaption("Expiration Calc. HR-RclBm") + ': ' + Format(Item2."Expiration Calc. HR-RclBm");
        if ElementText <> '' then
            _BaseOrderLineElement.Set_DisplayLine4(ElementText);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MOB WMS Lookup", 'OnLookupOnLocateItem_OnAfterSetFromBinContent', '', false, false)]
    local procedure MobWmsLookupOnLookupOnLocateItemOnAfterSetFromBinContent(_BinContent: Record "Bin Content"; var _LookupResponseElement: Record "MOB NS WhseInquery Element")
    var
        Item2: Record Item;
        ElementText: Text;
    begin
        Item2.SetLoadFields("Expiration Calculation-RclBm");
        if not Item2.Get(_BinContent."Item No.") then
            exit;
        if Format(Item2."Expiration Calculation-RclBm") <> '' then
            ElementText := Item2.FieldCaption("Expiration Calculation-RclBm") + ': ' + Format(Item2."Expiration Calculation-RclBm");
        if ElementText <> '' then
            _LookupResponseElement.Set_DisplayLine4(ElementText);
    end;
}
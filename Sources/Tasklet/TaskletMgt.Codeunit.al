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
}
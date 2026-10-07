codeunit 72503 "Report Sel. Events Tasklet"
{
    Access = Internal;

    [EventSubscriber(ObjectType::Page, Page::"Report Selection - Sales", OnSetUsageFilterOnAfterSetFiltersByReportUsage, '', false, false)]
    local procedure ReportSelectionSalesOnSetUsageFilterOnAfterSetFiltersByReportUsage(var Rec: Record "Report Selections"; ReportUsage2: Option)
    begin
        if ReportUsage2 = Enum::"Report Selection Usage Sales"::"Tasklet Shipment".AsInteger() then
            Rec.SetRange(Usage, Enum::"Report Selection Usage"::"Tasklet Shipment");
    end;

    [EventSubscriber(ObjectType::Page, Page::"Report Selection - Sales", OnInitUsageFilterOnElseCase, '', false, false)]
    local procedure ReportSelectionSalesOnInitUsageFilterOnElseCase(ReportUsage: Enum "Report Selection Usage"; var ReportUsage2: Enum "Report Selection Usage Sales")
    begin
        if ReportUsage = Enum::"Report Selection Usage"::"Tasklet Shipment" then
            ReportUsage2 := Enum::"Report Selection Usage Sales"::"Tasklet Shipment";
    end;
}
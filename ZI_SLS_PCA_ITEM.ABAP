@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Iterface View For Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_SLS_PCA_ITEM as select from zsls_pca_item
association to parent ZISLS_PCA_HDR as _header on $projection.ContractId = _header.ContractId
{
    key contract_id as ContractId,
    key item_no as ItemNo,
    material_id as MaterialId,
      @Semantics.quantity.unitOfMeasure : 'Unit'
    quantity as Quantity,
    unit as Unit,
    @Semantics.amount.currencyCode : 'Currency'
    net_value as NetValue,
    currency as Currency,
    created_by as CreatedBy,
    created_at as CreatedAt,
    local_last_changed_by as LocalLastChangedBy,
    local_last_changed_at as LocalLastChangedAt,
    last_changed_at as LastChangedAt,
    _header
}

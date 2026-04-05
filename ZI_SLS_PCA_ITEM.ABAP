@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View for Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZISLS_PCA_HDR as select from zsls_pca_hdr
composition [1..*] of ZI_SLS_PCA_ITEM as _item
{
    key contract_id as ContractId,
    supplier_name as SupplierName,
    contract_date as ContractDate,
@Semantics.amount.currencyCode : 'Currency'
    total_value as TotalValue,
    currency as Currency,
    created_by as CreatedBy,
    created_at as CreatedAt,
    local_last_changed_by as LocalLastChangedBy,
    local_last_changed_at as LocalLastChangedAt,
    last_changed_at as LastChangedAt,
    _item
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_SLS_PCA_HDR
  provider contract transactional_query as projection on ZISLS_PCA_HDR
{
    key ContractId,
    SupplierName,
    ContractDate,
    @Semantics.amount.currencyCode : 'currency'
    TotalValue,
    Currency,
    CreatedBy,
    CreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _item : redirected to composition child ZC_SLS_PCA_ITEM
}

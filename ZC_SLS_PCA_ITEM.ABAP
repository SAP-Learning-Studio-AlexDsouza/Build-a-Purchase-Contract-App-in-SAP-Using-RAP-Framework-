@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_SLS_PCA_ITEM as projection on ZI_SLS_PCA_ITEM
{
    key ContractId,
    key ItemNo,
    MaterialId,
    @Semantics.quantity.unitOfMeasure : 'Unit'
    Quantity,
    Unit,
     @Semantics.amount.currencyCode : 'Currency'
    NetValue,
    Currency,
    CreatedBy,
    CreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _header : redirected to parent ZC_SLS_PCA_HDR
}

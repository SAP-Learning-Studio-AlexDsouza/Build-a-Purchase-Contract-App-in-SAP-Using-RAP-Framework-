@EndUserText.label : 'Item Table'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zsls_pca_item {

  key client            : abap.clnt not null;
  key contract_id       : abap.numc(10) not null;
  key item_no           : abap.numc(6) not null;
  material_id           : abap.char(20);
  @Semantics.quantity.unitOfMeasure : 'zpca_item.unit'
  quantity              : abap.quan(13,3);
  unit                  : abap.unit(2);
  @Semantics.amount.currencyCode : 'zpca_item.currency'
  net_value             : abap.curr(15,2);
  currency              : abap.cuky;
  created_by            : abp_creation_user;
  created_at            : abp_creation_tstmpl;
  local_last_changed_by : abp_locinst_lastchange_user;
  local_last_changed_at : abp_locinst_lastchange_tstmpl;
  last_changed_at       : abp_lastchange_tstmpl;

}

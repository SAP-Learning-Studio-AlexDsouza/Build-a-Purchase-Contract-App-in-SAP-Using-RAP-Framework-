@EndUserText.label : 'Header Table'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zsls_pca_hdr {

  key client            : abap.clnt not null;
  key contract_id       : abap.numc(10) not null;
  supplier_name         : abap.char(40);
  contract_date         : abap.dats;
  @Semantics.amount.currencyCode : 'zpca_hdr.currency'
  total_value           : abap.curr(15,2);
  currency              : abap.cuky;
  created_by            : abp_creation_user;
  created_at            : abp_creation_tstmpl;
  local_last_changed_by : abp_locinst_lastchange_user;
  local_last_changed_at : abp_locinst_lastchange_tstmpl;
  last_changed_at       : abp_lastchange_tstmpl;

}

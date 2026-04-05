# 📄 Build a Purchase Contract App in SAP Using RAP Framework

> A complete, production-style **Custom Fiori App** built using the **ABAP RESTful Application Programming (RAP) Framework** — covering database tables, CDS interface views, projection views, metadata extensions, and service definition.

---

## 🎥 Video Tutorial

▶️ **Watch on YouTube** → *[Coming Soon — link will be added]*

---

## 📌 What This App Covers

This project walks through building a **Purchase Contract App** — a real-world master-detail Fiori Elements application with full Create, Update, and Delete (CRUD) capabilities.

| Layer | Object | Purpose |
|---|---|---|
| Database Tables | `zpca_hdr`, `zpca_item` | Stores header and item data |
| Interface CDS Views | `ZI_PCA_HDR`, `ZI_PCA_ITEM` | Technical data access layer |
| Projection CDS Views | `ZC_PCA_HDR`, `ZC_PCA_ITEM` | UI consumption layer |
| Metadata Extension | `ZC_PCA_HDR` (MDE) | Fiori UI annotations |
| Service Definition | `ZC_PCA_HDR_UI` | OData V4 service exposure |

---

## 🌍 Real-World Context

A **Purchase Contract** is a legal agreement between your company and a supplier specifying material, quantity, price, and validity period.

From a data structure perspective:
- **Header** (`zpca_hdr`) — Supplier, Contract Date, Total Value, Currency
- **Items** (`zpca_item`) — Material ID, Quantity, Unit, Net Value

This is a classic **parent-child (composition)** relationship — one header, many items.

---

## 🗄️ Step 1 — Database Tables

### `zpca_hdr` — Purchase Contract Header

```abap
@EndUserText.label : 'Purchase Contract Header'
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zpca_hdr {
  key client        : abap.clnt not null;
  key contract_id   : abap.char(10) not null;
  supplier_name     : abap.char(100);
  contract_date     : abap.dats;
  @Semantics.amount.currencyCode : 'zpca_hdr.currency'
  total_value       : abap.curr(15,2);
  currency          : abap.cuky;
  created_by            : abp_creation_user;
  created_at            : abp_creation_tstmpl;
  local_last_changed_by : abp_locinst_lastchange_user;
  local_last_changed_at : abp_locinst_lastchange_tstmpl;
  last_changed_at       : abp_lastchange_tstmpl;
}
```

### `zpca_item` — Purchase Contract Items

```abap
@EndUserText.label : 'Purchase Contract Items'
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zpca_item {
  key client      : abap.clnt not null;
  key contract_id : abap.char(10) not null;
  key item_no     : abap.numc(6) not null;
  material_id     : abap.char(40);
  @Semantics.quantity.unitOfMeasure : 'zpca_item.unit'
  quantity        : abap.quan(13,3);
  unit            : abap.unit(2);
  @Semantics.amount.currencyCode : 'zpca_item.currency'
  net_value       : abap.curr(15,2);
  currency        : abap.cuky;
  created_by            : abp_creation_user;
  created_at            : abp_creation_tstmpl;
  local_last_changed_by : abp_locinst_lastchange_user;
  local_last_changed_at : abp_locinst_lastchange_tstmpl;
  last_changed_at       : abp_lastchange_tstmpl;
}
```

> ⚠️ **Important:** Always include all **5 RAP admin fields**. Missing even one will cause activation errors.

---

## 🔍 Step 2 — Interface CDS Views (ZI Layer)

### `ZI_PCA_HDR` — Root View Entity

```abap
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_PCA_HDR as select from zpca_hdr
composition [ 1..* ] of ZI_PCA_ITEM as _item
{
  key contract_id   as ContractId,
  supplier_name     as SupplierName,
  contract_date     as ContractDate,
  @Semantics.amount.currencyCode : 'Currency'
  total_value       as TotalValue,
  currency          as Currency,
  created_by            as CreatedBy,
  created_at            as CreatedAt,
  local_last_changed_by as LocalLastChangedBy,
  local_last_changed_at as LocalLastChangedAt,
  last_changed_at       as LastChangedAt,
  _item
}
```

### `ZI_PCA_ITEM` — Child View Entity

```abap
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PCA_ITEM as select from zpca_item
association to parent ZI_PCA_HDR as _header
  on $projection.ContractId = _header.ContractId
{
  key contract_id as ContractId,
  key item_no     as ItemNo,
  material_id     as MaterialId,
  @Semantics.quantity.unitOfMeasure: 'Unit'
  quantity        as Quantity,
  unit            as Unit,
  @Semantics.amount.currencyCode : 'Currency'
  net_value       as NetValue,
  currency        as Currency,
  created_by            as CreatedBy,
  created_at            as CreatedAt,
  local_last_changed_by as LocalLastChangedBy,
  local_last_changed_at as LocalLastChangedAt,
  last_changed_at       as LastChangedAt,
  _header
}
```

---

## 🎯 Step 3 — Projection CDS Views (ZC Layer)

### `ZC_PCA_HDR` — Header Projection

```abap
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_PCA_HDR
  provider contract transactional_query
  as projection on ZI_PCA_HDR
{
  key ContractId,
  SupplierName,
  ContractDate,
  @Semantics.amount.currencyCode : 'Currency'
  TotalValue,
  Currency,
  CreatedBy,
  CreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt,
  /* Associations */
  _item : redirected to composition child ZC_PCA_ITEM
}
```

### `ZC_PCA_ITEM` — Items Projection

```abap
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_PCA_ITEM as projection on ZI_PCA_ITEM
{
  key ContractId,
  key ItemNo,
  MaterialId,
  @Semantics.quantity.unitOfMeasure: 'Unit'
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
  _header : redirected to parent ZC_PCA_HDR
}
```

> ⚠️ **Always include `@Metadata.allowExtensions: true`** on projection views, otherwise UI annotations will be silently ignored.

---

## 🎨 Step 4 — Metadata Extension

```abap
@Metadata.layer: #CORE
@UI: {
  headerInfo: {
    typeName      : 'Purchase Contract',
    typeNamePlural: 'Purchase Contracts',
    title: { type: #STANDARD, value: 'ContractId' }
  }
}
annotate entity ZC_PCA_HDR with
{
  @UI.facet: [
    { id: 'General', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE,
      label: 'General Information', position: 10 },
    { id: 'Items', purpose: #STANDARD, type: #LINEITEM_REFERENCE,
      label: 'Contract Items', position: 20, targetElement: '_item' }
  ]

  @UI: { selectionField: [{ position: 10 }],
         lineItem:       [{ position: 10 }],
         identification: [{ position: 10, label: 'Contract ID' }] }
  ContractId;

  @UI: { selectionField: [{ position: 20 }],
         lineItem:       [{ position: 20 }],
         identification: [{ position: 20, label: 'Supplier Name' }] }
  SupplierName;

  @UI: { selectionField: [{ position: 30 }],
         lineItem:       [{ position: 30 }],
         identification: [{ position: 30, label: 'Contract Date' }] }
  ContractDate;

  @UI: { lineItem:       [{ position: 40 }],
         identification: [{ position: 40, label: 'Total Value' }] }
  TotalValue;

  @UI: { lineItem:       [{ position: 50 }],
         identification: [{ position: 50, label: 'Currency' }] }
  Currency;
}
```

---

## 🔌 Step 5 — Service Definition

```abap
@EndUserText.label: 'Purchase Contract App Service'
define service ZC_PCA_HDR_UI {
  expose ZC_PCA_HDR;
  expose ZC_PCA_ITEM;
}
```

After creating this, create a **Service Binding** in ADT:
- Binding Type: `OData V4 - UI`
- Activate and click **Preview** to launch the Fiori app

---

## 📱 Final App Output

| Page | What You See |
|---|---|
| **List Page** | Table with Contract ID, Supplier, Date, Value + Filter Bar |
| **Object Page** | Header form + embedded Items table |
| **Create/Edit** | Full CRUD form for both header and items |

---

## 🧰 Prerequisites

- SAP BTP ABAP Environment **or** SAP S/4HANA on-premise (2022+)
- ABAP Development Tools (ADT) in Eclipse
- Basic understanding of ABAP and CDS Views

---

## 👨‍💻 Author

**Alex D'Souza** — SAP Learning Studio

- 🎥 YouTube: [SAP Learning Studio](https://www.youtube.com/@SAP-Learning-Studio)
- 💻 GitHub: [SAP-Learning-Studio-AlexDsouza](https://github.com/SAP-Learning-Studio-AlexDsouza)

---

## ⭐ Support

If this helped you please **star this repo** and **subscribe** to the YouTube channel for more SAP tutorials!

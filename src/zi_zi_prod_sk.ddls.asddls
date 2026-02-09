@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Basic Interface View forzi_prod_sk'
define view entity ZI_zi_prod_sk
  as select from ZPROD_SK as zi_prod_sk
{
  key ID as ID,
  MATERIAL as Material,
  DESCRIPTION as Description,
  COLOUR as Colour,
  WEIGHT as Weight,
  @Semantics.user.createdBy: true
  LOCAL_CREATED_BY as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  LOCAL_CREATED_AT as LocalCreatedAt,
  LOCAL_LAST_CHANGED_BY as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt
}

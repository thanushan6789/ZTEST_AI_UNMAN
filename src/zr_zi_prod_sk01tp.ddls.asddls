@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forzi_prod_sk'
define root view entity ZR_zi_prod_sk01TP
  as select from ZI_zi_prod_sk as zi_prod_sk
{
  key ID,
  Material,
  Description,
  Colour,
  Weight,
  @Semantics.user.createdBy: true
  LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  LocalCreatedAt,
  LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  LastChangedAt
}

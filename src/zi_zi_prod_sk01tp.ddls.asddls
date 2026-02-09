@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection View forzi_prod_sk'
define root view entity ZI_zi_prod_sk01TP
  provider contract TRANSACTIONAL_INTERFACE
  as projection on ZR_zi_prod_sk01TP as zi_prod_sk
{
  key ID,
  Material,
  Description,
  Colour,
  Weight,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt
}

@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forzi_prod_sk'
@ObjectModel.semanticKey: [ 'ID' ]
@Search.searchable: true
define root view entity ZC_zi_prod_sk01TP
  provider contract transactional_query
  as projection on ZR_zi_prod_sk01TP as zi_prod_sk
{
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.90 
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

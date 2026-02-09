@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root cds entity'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zi_prod_sk as select from zprod_sk
{
    key id as Id,
    material as Material,
    description as Description,
    colour as Colour,
    weight as Weight,
    local_created_by as LocalCreatedBy,
    local_created_at as LocalCreatedAt,
    local_last_changed_by as LocalLastChangedBy,
    local_last_changed_at as LocalLastChangedAt,
    last_changed_at as LastChangedAt

}

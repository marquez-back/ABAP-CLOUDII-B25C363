@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Incident Interface Entity'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZDDF_INCIDENT_I_YMP
provider contract transactional_interface
  as projection on ZDDF_INCIDENT_R_YMP
{
  key IncUuid,
      IncidentId,
      Title,
      Description,
      Status,
      Priority,
      CreationDate,
      ChangedDate,
      
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      /* Associations */
      _History,
      _Priority,
      _Status


}

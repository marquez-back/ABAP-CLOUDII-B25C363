@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Incident History Comsumption Entity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZDDF_INCIDENT_HIS_C_YMP
  as projection on ZDDF_INCIDENT_HIS_YMP
{
  key HisUuid,
  key IncUuid,
      HisId,
      PreviousStatus,
      NewStatus,
      Text,
      local_created_by,
      local_created_at,
      local_last_changed_by,
      local_last_changed_at,
      last_changed_at,
      /* Associations */
      _Incident /*: redirected to parent ZDDF_INCIDENT_C_YMP*/
}

    @AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Incident History Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDDF_INCIDENT_HIS_YMP
  as select from zdt_inct_h_ymp
 association to parent ZDDF_INCIDENT_R_YMP as _Incident 
    on $projection.IncUuid = _Incident.IncUuid
  
     

{
  key    his_uuid        as HisUuid,
  key    inc_uuid        as IncUuid,
         his_id          as HisId,
         previous_status as PreviousStatus,
         new_status      as NewStatus,
         text            as Text,
         local_created_by,
         local_created_at,
         local_last_changed_by,
         local_last_changed_at,
         last_changed_at,
         _Incident
         
}

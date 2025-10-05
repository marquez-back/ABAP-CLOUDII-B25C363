@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Change Status Parameters'
@Metadata.ignorePropagatedAnnotations: true


define view entity ZI_CHANGUE_STATUS_YMP
  as select from zddf_status_ymp
{
  @EndUserText.label: 'New Status'
 
  key zddf_status_ymp.StatusCode
}

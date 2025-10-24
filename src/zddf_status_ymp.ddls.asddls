@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Incident Status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.representativeKey: 'StatusCode'

@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@VDM.viewType: #COMPOSITE
@Search.searchable: true
define view entity zddf_status_ymp
  as select from zdt_status_ymp
{

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element: ['StatusDescription']
  key status_code        as StatusCode,

      @Semantics.text: true
      status_description as StatusDescription
}

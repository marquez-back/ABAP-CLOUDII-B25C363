@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Incident Comsumption Entity'
@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true
@Metadata.allowExtensions: true

define root view entity ZDDF_INCIDENT_C_YMP
  provider contract transactional_query
  as projection on ZDDF_INCIDENT_R_YMP
{
  key IncUuid,
      IncidentId, 
      
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8  
      @Search.ranking: #MEDIUM    
      Title,
      Description,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8  
      @Search.ranking: #MEDIUM   
      @ObjectModel.text.element: [ 'status_description' ] 
      Status,
      _Status.status_description,
      
      /* Elemento virtual para la edad del ticket
      @EndUserText.label: 'Egae Incident'     
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_AGE_CALCULATOR_YP'
      virtual IncidentAge: abap.int4,  */
      
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8  
      @Search.ranking: #MEDIUM   
      @ObjectModel.text.element: [ 'priority_description' ]
      Priority,
      _Priority.priority_description,
      
      CreationDate,
      ChangedDate,
   
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      /* Associations */
     
      _Priority,
      _Status
      
       //@ObjectModel.association.type: [#TO_COMPOSITION_CHILD]
      //_History //: redirected to composition child ZDDF_INCIDENT_HIS_C_YMP

}

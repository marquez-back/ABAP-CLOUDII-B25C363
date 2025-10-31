@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Incident History Comsumption Entity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

@UI.headerInfo: {
  typeName: 'Registro de Historial',
  typeNamePlural: 'Historial del Incidente',
  title: { type: #STANDARD, value: 'HisId' },
  description: { type: #STANDARD, value: 'NewStatus' }
}


define view entity ZDDF_INCIDENT_HIS_C_YMP
  as projection on ZDDF_INCIDENT_HIS_YMP
{
  key HisUuid,
  key IncUuid,
      @UI.lineItem: [{ position: 10, label: 'ID Histórico' }]
  @UI.identification: [{ position: 10, label: 'ID Histórico' }]
  HisId,

  @UI.lineItem: [{ position: 20, label: 'Estado Anterior' }]
  @UI.identification: [{ position: 20, label: 'Estado Anterior' }]
  PreviousStatus,
 

  @UI.lineItem: [{ position: 30, label: 'Nuevo Estado' }]
  @UI.identification: [{ position: 30, label: 'Nuevo Estado' }]
  NewStatus,
  

  @UI.lineItem: [{ position: 40, label: 'Comentario' }]
  @UI.identification: [{ position: 40, label: 'Comentario' }]
  Text,

  @UI.lineItem: [{ position: 50, label: 'Creado Por' }]
  @UI.identification: [{ position: 50, label: 'Creado Por' }]
  local_created_by,

  @UI.lineItem: [{ position: 60, label: 'Creado En' }]
  @UI.identification: [{ position: 60, label: 'Creado En' }]
  local_created_at,
      /* Associations */     
      _Incident : redirected to parent ZDDF_INCIDENT_C_YMP
}

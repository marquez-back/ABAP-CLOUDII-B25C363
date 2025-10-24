@EndUserText.label: 'Parameter structure changeStatus action'
define abstract entity ZI_CHANGUE_STATUS_YMP
{
 @EndUserText.label: 'Nuevo Estado' 
  @Consumption.valueHelpDefinition: [ 
    {
     entity: { name: 'zddf_status_ymp', element: 'StatusCode' } 
    }
  ]

  NewStatus   : zde_status_code_ymp;
  
  @EndUserText.label: 'Comentario'
  Observation  : abap.char(80);
  
  
  
}



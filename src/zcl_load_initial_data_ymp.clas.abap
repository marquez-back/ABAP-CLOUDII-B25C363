CLASS zcl_load_initial_data_ymp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_load_initial_data_ymp IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    " Eliminar datos existentes
    DELETE FROM zdt_priority_ymp.

    " Insertar valores de prioridad
    INSERT zdt_priority_ymp FROM TABLE @(
      VALUE #(
        ( priority_code = 'H' priority_description = 'High' )
        ( priority_code = 'M' priority_description = 'Medium' )
        ( priority_code = 'L' priority_description = 'Low' )
      )
    ).

    " Confirmar y mostrar mensaje
    COMMIT WORK.
    out->write( 'Tabla ZDT_PRIORITY_USER poblada exitosamente.' ).
  ENDMETHOD.

ENDCLASS.

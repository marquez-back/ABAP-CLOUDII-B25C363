CLASS zcl_dt_status_ymp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_dt_status_ymp IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    " Eliminar datos existentes
    DELETE FROM zdt_status_ymp.

    " Insertar valores de estado
    INSERT zdt_status_ymp FROM TABLE @(
      VALUE #(
        ( status_code = 'OP' status_description = 'Open' )
        ( status_code = 'IP' status_description = 'In Progress' )
        ( status_code = 'PE' status_description = 'Pending' )
        ( status_code = 'CO' status_description = 'Completed' )
        ( status_code = 'CL' status_description = 'Closed' )
        ( status_code = 'CN' status_description = 'Canceled' )
      )
    ).

    " Confirmar y mostrar mensaje
    COMMIT WORK.
    out->write( 'Tabla ZDT_STATUS_USER poblada exitosamente.' ).
  ENDMETHOD.

ENDCLASS.

CLASS zbp_ddf_incident_r_ymp DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  FOR BEHAVIOR OF ZDDF_INCIDENT_R_YMP.

  PUBLIC SECTION.
    CLASS-DATA:
      gt_status_values TYPE TABLE OF zddf_status_ymp.

  PRIVATE SECTION.
    CLASS-METHODS:
      _validate_status
        IMPORTING
          iv_status TYPE zde_status_code_ymp
        RAISING
          cx_rap_query_provider,
      _get_status_description
        IMPORTING
          iv_status        TYPE zde_status_code_ymp
        RETURNING
          VALUE(rv_result) TYPE zde_status_description_ymp.
ENDCLASS.



CLASS ZBP_DDF_INCIDENT_R_YMP IMPLEMENTATION.


  METHOD _validate_status.
    " Cargar valores de estado válidos si no están en memoria
    IF gt_status_values IS INITIAL.
      SELECT * FROM zddf_status_ymp INTO TABLE @gt_status_values.
    ENDIF.

    " Validar que el estado existe
    READ TABLE gt_status_values TRANSPORTING NO FIELDS
      WITH KEY StatusCode = iv_status.

  ENDMETHOD.


  METHOD _get_status_description.
    " Cargar valores de estado si no están en memoria
    IF gt_status_values IS INITIAL.
      SELECT * FROM zddf_status_ymp INTO TABLE @gt_status_values.
    ENDIF.

    " Obtener descripción del estado
    READ TABLE gt_status_values INTO DATA(ls_status)
      WITH KEY StatusCode = iv_status.
    IF sy-subrc = 0.
      rv_result = ls_status-StatusDescription.
    ELSE.
      rv_result = |Estado desconocido ({ iv_status })|.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lhc_Incident DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.

    CONSTANTS: BEGIN OF mc_status,
                 open        TYPE zde_status_code VALUE 'OP',
                 in_progress TYPE zde_status_code VALUE 'IP',
                 pending     TYPE zde_status_code VALUE 'PE',
                 completed   TYPE zde_status_code VALUE 'CO',
                 closed      TYPE zde_status_code VALUE 'CL',
                 canceled    TYPE zde_status_code VALUE 'CN',
               END OF mc_status.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Incident RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Incident RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Incident RESULT result.

    METHODS changeStatus FOR MODIFY
      IMPORTING keys FOR ACTION Incident~changeStatus RESULT result.

    METHODS setHistory FOR MODIFY
      IMPORTING keys FOR ACTION Incident~setHistory.

    METHODS SetInitialValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Incident~SetInitialValues.

    METHODS CreateHistoryEntry FOR DETERMINE ON SAVE
      IMPORTING keys FOR Incident~CreateHistoryEntry.

    METHODS ValidateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incident~ValidateDates.

    METHODS ValidatePriority FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incident~ValidatePriority.

    METHODS ValidateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incident~ValidateStatus.



ENDCLASS.

CLASS lhc_Incident IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD changeStatus.
    " Acción para cambiar el estado de un incidente
    READ ENTITIES OF zddf_incident_r_ymp IN LOCAL MODE
      ENTITY Incident
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(incidents).

    " Declarar variables de respuesta
    DATA: reported_response TYPE RESPONSE FOR REPORTED zddf_incident_r_ymp,
          failed_response   TYPE RESPONSE FOR FAILED zddf_incident_r_ymp.

    " Actualizar el estado
    MODIFY ENTITIES OF zddf_incident_r_ymp IN LOCAL MODE
      ENTITY Incident
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR key IN keys
                      ( %tky   = key-%tky
                        Status = 'IP' ) )
      REPORTED reported_response
      FAILED failed_response.

    " Leer y devolver los incidentes actualizados
    READ ENTITIES OF zddf_incident_r_ymp IN LOCAL MODE
      ENTITY Incident
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(updated_incidents).

    " Asignar al resultado - forma correcta
    result = VALUE #( FOR incident IN updated_incidents
                      ( %tky   = incident-%tky
                        %param = incident ) ).
  ENDMETHOD.

  METHOD setHistory.
  ENDMETHOD.

  METHOD SetInitialValues.

** Read root entity entries
    READ ENTITIES OF zddf_incident_r_ymp IN LOCAL MODE
     ENTITY Incident
     FIELDS ( CreationDate
              Status ) WITH CORRESPONDING #( keys )
     RESULT DATA(incidents).

** This important for logic
    DELETE incidents WHERE CreationDate IS NOT INITIAL.

    CHECK incidents IS NOT INITIAL.

** Get Last index from Incidents
    SELECT FROM zdt_inct_a_ymp
      FIELDS MAX( incident_id ) AS max_inct_id
      WHERE incident_id IS NOT NULL
      INTO @DATA(lv_max_inct_id).

    IF lv_max_inct_id IS INITIAL.
      lv_max_inct_id = 1.
    ELSE.
      lv_max_inct_id += 1.
    ENDIF.

** Modify status in Root Entity
    MODIFY ENTITIES OF zddf_incident_r_ymp IN LOCAL MODE
      ENTITY Incident
      UPDATE
      FIELDS ( IncidentId
               CreationDate
               Status )
      WITH VALUE #(  FOR incident IN incidents ( %tky = incident-%tky
                                                 IncidentId = lv_max_inct_id
                                                 CreationDate = cl_abap_context_info=>get_system_date( )
                                                 Status       = mc_status-open )  ).

    ENDMETHOD.

  METHOD CreateHistoryEntry.
  ENDMETHOD.

  METHOD ValidateDates.
  ENDMETHOD.

  METHOD ValidatePriority.
  ENDMETHOD.

  METHOD ValidateStatus.
  ENDMETHOD.

ENDCLASS.









CLASS lhc_Incident DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.

    CONSTANTS: BEGIN OF inc_status,
                 open        TYPE zde_status_code VALUE 'OP',
                 in_progress TYPE zde_status_code VALUE 'IP',
                 pending     TYPE zde_status_code VALUE 'PE',
                 completed   TYPE zde_status_code VALUE 'CO',

                 canceled    TYPE zde_status_code VALUE 'CN',
               END OF inc_status.

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

  METHOD changeStatus .
    DATA: lt_updated_root_entity TYPE TABLE FOR UPDATE zddf_incident_r_ymp,
          lt_association_entity  TYPE TABLE FOR CREATE zddf_incident_r_ymp\_History,
          lv_status              TYPE zde_status_code_ymp,
**          lv_text                TYPE zde_text,
          lv_exception           TYPE string,
          lv_error               TYPE c,
          ls_incident_history    TYPE zdt_inct_h_ymp,
**          lv_max_his_id          TYPE zde_his_id,
          lv_wrong_status        TYPE zde_status_code_ymp.

    READ ENTITIES OF zddf_incident_r_ymp IN LOCAL MODE
        ENTITY Incident
          ALL FIELDS WITH CORRESPONDING #( keys )
                  RESULT DATA(lt_incidents)
    FAILED failed.

    LOOP AT lt_incidents ASSIGNING FIELD-SYMBOL(<incident>).
      lv_status = keys[ KEY id %tky = <incident>-%tky ]-%param-NewStatus.

    ENDLOOP.
*    LOOP AT lt_incidents INTO DATA(ls_incident).
*
*      MODIFY ENTITIES OF zddf_incident_r_ymp IN LOCAL MODE
*        ENTITY Incident
*          UPDATE FIELDS ( Status )
*          WITH VALUE #(
*            ( %tky        = ls_incident-%tky
*              Status       = 'PE'
*              ChangedDate  = cl_abap_context_info=>get_system_date( ) )
*          ).
*
*    ENDLOOP.

    " --- Crear registro de historial ---
*  MODIFY ENTITIES OF zddf_incident_his_ymp IN LOCAL MODE
*    ENTITY History
*      CREATE
*      FIELDS ( IncUuid PreviousStatus NewStatus Text )
*      WITH VALUE #(
*        ( IncUuid        = ls_incident-IncUuid
*          PreviousStatus = ls_incident-Status
*          NewStatus      = parameters-NewStatus
*          Text           = parameters-Observation )
*      ).

    result = VALUE #( FOR incident IN lt_incidents ( %tky = incident-%tky ) ).

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
               Status
               Priority )
      WITH VALUE #(  FOR incident IN incidents ( %tky = incident-%tky
                                                 IncidentId = lv_max_inct_id
                                                 CreationDate = cl_abap_context_info=>get_system_date( )
                                                 Status = 'OP'
                                                 Priority = 'H' )  ).

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

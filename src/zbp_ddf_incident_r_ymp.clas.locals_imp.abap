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
          lv_text                TYPE string,
          lv_exception           TYPE string,
          lv_error               TYPE c,
          ls_incident_history    TYPE zdt_inct_h_ymp,
*          lv_max_his_id          TYPE zde_his_id,
          lv_wrong_status        TYPE zde_status_code_ymp.

    READ ENTITIES OF zddf_incident_r_ymp IN LOCAL MODE
        ENTITY Incident
          ALL FIELDS WITH CORRESPONDING #( keys )
                  RESULT DATA(lt_incidents)
    FAILED failed.

    LOOP AT lt_incidents ASSIGNING FIELD-SYMBOL(<incident>).
      lv_status = keys[ KEY id %tky = <incident>-%tky ]-%param-NewStatus.
      lv_text = keys[ KEY id %tky = <incident>-%tky ]-%param-Observation.




      MODIFY ENTITIES OF zddf_incident_r_ymp IN LOCAL MODE
        ENTITY Incident
        UPDATE FIELDS ( Status
                        ChangedDate )
         WITH VALUE #(
           ( %tky        = <incident>-%tky
             Status       = lv_status
             ChangedDate  = cl_abap_context_info=>get_system_date( ) )
         ).

      SELECT FROM zdt_inct_h_ymp
      FIELDS MAX( his_id ) AS max_inct_id
      WHERE inc_uuid EQ @<incident>-IncUuid AND inc_uuid IS NOT NULL
      INTO @DATA(lv_max_his_id).

      IF lv_max_his_id IS INITIAL.
        ls_incident_history-his_id = 1.
      ELSE.
        ls_incident_history-his_id = lv_max_his_id + 1.
      ENDIF.

      ls_incident_history-new_status = lv_status.
      ls_incident_history-text = lv_text.

      TRY.
          ls_incident_history-inc_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error INTO DATA(lo_error).
          lv_exception = lo_error->get_text(  ).
      ENDTRY.

      IF ls_incident_history-his_id IS NOT INITIAL.

        APPEND VALUE #( %tky = <incident>-%tky
                       %target = VALUE #( (  HisUuid = ls_incident_history-inc_uuid
                                             IncUuid = <incident>-IncUuid
                                             HisID = ls_incident_history-his_id
                                             PreviousStatus = <incident>-Status
                                             NewStatus = ls_incident_history-new_status
                                             Text = ls_incident_history-text ) )
                                              ) TO lt_association_entity.
      ENDIF.

    ENDLOOP.

    MODIFY ENTITIES OF zddf_incident_r_ymp IN LOCAL MODE
     ENTITY Incident
     CREATE BY \_History FIELDS ( HisUuid
                                  IncUuid
                                  HisID
                                  PreviousStatus
                                  NewStatus
                                  Text )
        AUTO FILL CID
        WITH lt_association_entity
     MAPPED mapped
     FAILED failed
     REPORTED reported.

    result = VALUE #( FOR incident IN lt_incidents ( %tky = incident-%tky
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
               Status
               Priority )
      WITH VALUE #(  FOR incident IN incidents ( %tky = incident-%tky
                                                 IncidentId = lv_max_inct_id
                                                 CreationDate = cl_abap_context_info=>get_system_date( )
                                                 Status = 'OP'
                                                 Priority = 'H' )  ).

  ENDMETHOD.

  METHOD CreateHistoryEntry.
    DATA: lt_updated_root_entity TYPE TABLE FOR UPDATE zddf_incident_r_ymp,
          lt_association_entity  TYPE TABLE FOR CREATE zddf_incident_r_ymp\_History,
          lv_exception           TYPE string,
          ls_incident_history    TYPE zdt_inct_h_ymp,
          lv_status              TYPE zde_status_code_ymp,
          lv_text                TYPE string,
*          lv_exception           TYPE string,
          lv_error               TYPE c.

    READ ENTITIES OF zddf_incident_r_ymp IN LOCAL MODE
          ENTITY Incident
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(incidents).

    LOOP AT incidents ASSIGNING FIELD-SYMBOL(<incident>).
      SELECT FROM zdt_inct_h_ymp
     FIELDS MAX( his_id ) AS max_inct_id
     WHERE inc_uuid EQ @<incident>-IncUuid AND
            his_uuid IS NOT NULL
     INTO @DATA(lv_max_his_id).

      IF lv_max_his_id IS INITIAL.
        ls_incident_history-his_id = 1.
      ELSE.
        ls_incident_history-his_id = lv_max_his_id + 1.
      ENDIF.

      ls_incident_history-new_status = lv_status.
      ls_incident_history-text = lv_text.

      TRY.
          ls_incident_history-inc_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error INTO DATA(lo_error).
          lv_exception = lo_error->get_text(  ).
      ENDTRY.

      IF ls_incident_history-his_id IS NOT INITIAL.

        APPEND VALUE #( %tky = <incident>-%tky
                       %target = VALUE #( (  HisUuid = ls_incident_history-inc_uuid
                                             IncUuid = <incident>-IncUuid
                                             HisID = ls_incident_history-his_id
                                             PreviousStatus = <incident>-Status
                                             NewStatus = ls_incident_history-new_status
                                             Text = 'First Incident'  ) )
                                              ) TO lt_association_entity.
      ENDIF.

    ENDLOOP.

    MODIFY ENTITIES OF zddf_incident_r_ymp IN LOCAL MODE
     ENTITY Incident
     CREATE BY \_History FIELDS ( HisUuid
                                  IncUuid
                                  HisID
                                  PreviousStatus
                                  NewStatus
                                  Text )
        AUTO FILL CID
        WITH lt_association_entity.


*    result = VALUE #( FOR incident IN lt_incidents ( %tky = incident-%tky
*                                                  %param = incident ) ).

  ENDMETHOD.

  METHOD ValidateDates.
  ENDMETHOD.

  METHOD ValidatePriority.
  ENDMETHOD.

  METHOD ValidateStatus.
  ENDMETHOD.

ENDCLASS.

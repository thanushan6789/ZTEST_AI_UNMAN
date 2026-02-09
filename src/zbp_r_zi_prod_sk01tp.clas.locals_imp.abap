CLASS lhc_zi_prod_sk DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR zi_prod_sk
        RESULT result,
      create FOR MODIFY
        IMPORTING
          entities FOR CREATE  zi_prod_sk,
      update FOR MODIFY
        IMPORTING
          entities FOR UPDATE  zi_prod_sk,
      delete FOR MODIFY
        IMPORTING
          keys FOR DELETE  zi_prod_sk,
      lock FOR LOCK
        IMPORTING
          keys FOR LOCK  zi_prod_sk,
      read FOR READ
        IMPORTING
                  keys   FOR READ  zi_prod_sk
        RESULT    result.
ENDCLASS.

CLASS lhc_zi_prod_sk IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD create.
   LOOP AT entities INTO DATA(ls_entity).
      " Draft framework stores data automatically
      " Only fill technical fields if needed
    ENDLOOP.
  ENDMETHOD.
  METHOD update.
  ENDMETHOD.
  METHOD delete.
  ENDMETHOD.
  METHOD lock.
  ENDMETHOD.
  METHOD read.
    DATA(lo_ext_srv) = NEW zcl_con_svc1( ).
    IF keys IS INITIAL.
* Get all the data
      DATA(lt_prod) = lo_ext_srv->get_prod_list(  ).
      result = CORRESPONDING #( lt_prod ).
    ELSE.
* If single key
      " check for draft exist
      READ ENTITIES OF zr_zi_prod_sk01tp IN LOCAL MODE
      ENTITY zi_prod_sk
      FIELDS ( id )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result)
      FAILED failed.

      IF line_exists( lt_result[ %is_draft = abap_true ] ).
        " Draft exists
        " keep the draft data
        result = lt_result.
      ELSE.

        " Read data from the the api and override the data
*        SELECT * FROM zsk_prod
*          FOR ALL ENTRIES IN @keys
*          WHERE id = @keys-id
*          INTO TABLE @DATA(lt_data).

        LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
          DATA(ls_prod) = lo_ext_srv->get_prod( iv_prod_id = <key>-id  ).
          " map external data to RAP entity
          APPEND VALUE #(
            id = <key>-id
            description  = ls_prod-description
            material = ls_prod-material
            weight = ls_prod-weight
            colour = ls_prod-colour
          ) TO result.

        ENDLOOP.

      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
CLASS lcl_zr_zi_prod_sk01tp DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS:
      finalize REDEFINITION,
      check_before_save REDEFINITION,
      save REDEFINITION,
      cleanup REDEFINITION,
      cleanup_finalize REDEFINITION.
ENDCLASS.

CLASS lcl_zr_zi_prod_sk01tp IMPLEMENTATION.
  METHOD finalize.
  ENDMETHOD.
  METHOD check_before_save.
  ENDMETHOD.
  METHOD save.
  ENDMETHOD.
  METHOD cleanup.
  ENDMETHOD.
  METHOD cleanup_finalize.
  ENDMETHOD.
ENDCLASS.

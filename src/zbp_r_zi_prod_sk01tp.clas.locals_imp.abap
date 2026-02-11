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
          RESULT    result,
      earlynumbering_create FOR NUMBERING
            IMPORTING entities FOR CREATE zi_prod_sk.
ENDCLASS.

CLASS lhc_zi_prod_sk IMPLEMENTATION.

  METHOD get_global_authorizations.
    result-%create = if_abap_behv=>auth-allowed.
    result-%update = if_abap_behv=>auth-allowed.
    result-%delete = if_abap_behv=>auth-allowed.
  ENDMETHOD.

  METHOD create.
    DATA(lo_prod) = zcl_products_helper=>get_instance( ).
    lo_prod->create(
    EXPORTING
      entities = entities
    CHANGING
      mapped   = mapped
      failed   = failed
      reported  = reported
  ).
  ENDMETHOD.

  METHOD update.
    zcl_products_helper=>get_instance( )->update(
    EXPORTING
      entities = entities
    CHANGING
      mapped   = mapped
      failed   = failed
      reported  = reported
  ).
  ENDMETHOD.

  METHOD delete.
    zcl_products_helper=>get_instance( )->delete(
   EXPORTING
     keys = keys
   CHANGING
     mapped   = mapped
     failed   = failed
     reported  = reported
 ).
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.



  METHOD read.
    DATA(lo_ext_srv) = NEW zcl_con_svc1( ).
    IF keys IS INITIAL.
* Get all the data
      DATA(lt_prod) = lo_ext_srv->get_prod_list(  ).
      result = CORRESPONDING #( lt_prod  ).
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
  METHOD earlynumbering_create.

  DATA: lv_id TYPE int4.
    SELECT MAX( id ) FROM zzi_prod_sk00d INTO @DATA(lv_id1).
    SELECT MAX( id ) FROM zsk_prod INTO @DATA(lv_id2).

    IF lv_id1 > lv_id2.
      lv_id = lv_id1.
    ELSE.
      lv_id = lv_id2.
    ENDIF.

    if lv_id IS NOT INITIAL.
      lv_Id = lv_id + 1.
    ELSE.
        lv_id = 1.
    endif.


    DATA(ls_entities) = VALUE #( entities[ 1 ] OPTIONAL ).
    ls_entities-Id = lv_id.
    mapped-zi_prod_sk  = VALUE #( ( %cid = ls_entities-%cid
                                     %is_draft = ls_entities-%is_draft
                                     %key = ls_entities-%key ) ).
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

   zcl_products_helper=>get_instance( )->save_data(
   CHANGING
     reported  = reported
 ).

  ENDMETHOD.
  METHOD cleanup.
  ENDMETHOD.
  METHOD cleanup_finalize.
  ENDMETHOD.
ENDCLASS.

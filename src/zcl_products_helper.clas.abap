CLASS zcl_products_helper DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES : tt_create         TYPE TABLE FOR CREATE ZR_zi_prod_sk01TP,
            tt_delete         TYPE TABLE FOR DELETE ZR_zi_prod_sk01TP,
            tt_update         TYPE TABLE FOR UPDATE ZR_zi_prod_sk01TP,
            tt_mapped_early   TYPE RESPONSE FOR MAPPED EARLY ZR_zi_prod_sk01TP,
            tt_mapped_late    TYPE RESPONSE FOR MAPPED LATE ZR_zi_prod_sk01TP,
            tt_failed_early   TYPE RESPONSE FOR FAILED EARLY ZR_zi_prod_sk01TP,
            tt_reported_early TYPE RESPONSE FOR REPORTED EARLY ZR_zi_prod_sk01TP,
            tt_reported_late  TYPE RESPONSE FOR REPORTED LATE ZR_zi_prod_sk01TP,
            tt_keys_read      TYPE TABLE FOR READ IMPORT ZR_zi_prod_sk01TP,
            tt_read_result    TYPE TABLE FOR READ RESULT ZR_zi_prod_sk01TP.

   DATA: ls_ext_data1     TYPE zcl_prod_serv=>tys_zc_skprodtype,
         ls_ext_data_tab1 TYPE zcl_prod_serv=>tyt_zc_skprodtype.


    CLASS-METHODS get_instance RETURNING VALUE(ro_prod) TYPE REF TO zcl_products_helper.
    CLASS-DATA : go_prod        TYPE REF TO zcl_products_helper,
                 gt_prod_create TYPE TABLE OF zzi_prod_sk00d,
                 gt_prod_update TYPE TABLE OF zzi_prod_sk00d,
                 gt_prod_delete TYPE RANGE OF zzi_prod_sk00d-id,
                 gs_prod        TYPE zzi_prod_sk00d.


    METHODS:
      create
        IMPORTING entities TYPE tt_create
        CHANGING
                  mapped   TYPE tt_mapped_early
                  failed   TYPE tt_failed_early
                  reported TYPE tt_reported_early,

      delete
        IMPORTING keys     TYPE tt_delete
        CHANGING  mapped   TYPE tt_mapped_early
                  failed   TYPE tt_failed_early
                  reported TYPE tt_reported_early,

      update
        IMPORTING entities TYPE tt_update
        CHANGING  mapped   TYPE tt_mapped_early
                  failed   TYPE tt_failed_early
                  reported TYPE tt_reported_early,

      read
        IMPORTING keys     TYPE tt_keys_read
        CHANGING  result   TYPE tt_read_result
                  failed   TYPE tt_failed_early
                  reported TYPE tt_reported_early,

      save_data
        CHANGING reported TYPE tt_reported_late.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_products_helper IMPLEMENTATION.
  METHOD create.
    gt_prod_create = CORRESPONDING #( entities MAPPING FROM ENTITY ).
  ENDMETHOD.

  METHOD get_instance.
    go_prod = ro_prod = COND #( WHEN go_prod IS BOUND THEN go_prod
                                      ELSE NEW #( ) ).
  ENDMETHOD.

  METHOD save_data.

    IF gt_prod_create IS NOT INITIAL.
      DATA(lo_ext_prod) = NEW zcl_con_svc1( ).

      LOOP AT gt_prod_create INTO DATA(ls_create).
        MOVE-CORRESPONDING ls_create TO ls_ext_data1.
        TRY.
            lo_ext_prod->create_prod(
              IMPORTING
                ls_data = ls_ext_data1
            ).

          CATCH cx_root INTO DATA(lx).

        ENDTRY.


      ENDLOOP.
    ENDIF.

    IF gt_prod_delete IS NOT INITIAL.

    ENDIF.

    IF gt_prod_update IS NOT INITIAL.

    ENDIF.

  ENDMETHOD.

  METHOD delete.
    DATA : lt_prod_delete TYPE TABLE OF zzi_prod_sk00d.
    lt_prod_delete = CORRESPONDING #( keys MAPPING FROM ENTITY ).
    gt_prod_delete = VALUE #( FOR ls_delete IN lt_prod_delete
                                     sign = 'I' option = 'EQ' ( low = ls_delete-id ) ).
  ENDMETHOD.

  METHOD update.
    gt_prod_update = CORRESPONDING #( entities MAPPING FROM ENTITY ).
    DATA(ls_prod_update) = VALUE #( gt_prod_update[ 1 ] OPTIONAL ).

    SELECT SINGLE FROM zzi_prod_sk00d
    FIELDS *
    WHERE id = @ls_prod_update-id
    INTO @DATA(lv_prod).

    gt_prod_update = VALUE #( ( id = ls_prod_update-id

                                   material =
                                   COND #( WHEN ls_prod_update-material IS INITIAL THEN ls_prod_update-material
                                   ELSE ls_prod_update-material )

                                   description =
                                   COND #( WHEN ls_prod_update-description IS INITIAL THEN ls_prod_update-description
                                   ELSE ls_prod_update-description )

                                   colour =
                                   COND #( WHEN ls_prod_update-colour IS INITIAL THEN ls_prod_update-colour
                                   ELSE ls_prod_update-colour )

                                   weight =
                                   COND #( WHEN ls_prod_update-weight IS INITIAL THEN ls_prod_update-weight
                                   ELSE ls_prod_update-weight )

                                  lastchangedat =
                                   COND #( WHEN ls_prod_update-lastchangedat IS INITIAL THEN ls_prod_update-lastchangedat
                                   ELSE ls_prod_update-lastchangedat )
                                   ) ).
  ENDMETHOD.

  METHOD read.
*    SELECT FROM zzi_prod_sk00d FIELDS * FOR ALL ENTRIES IN
*    WHERE id = -Id
*    INTO TABLE (lt_read_prod).
*
*  result = CORRESPONDING #( lt_read_prod MAPPING to ENTITY ).

  ENDMETHOD.
ENDCLASS.




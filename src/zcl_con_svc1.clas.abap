CLASS zcl_con_svc1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      get_prod_list
        IMPORTING iv_prod_id     TYPE int4 OPTIONAL
        RETURNING VALUE(rt_prod) TYPE  zcl_prod_serv=>tyt_zc_skprodtype,
      get_prod
        IMPORTING iv_prod_id     TYPE int4
        RETURNING VALUE(rs_prod) TYPE  zcl_prod_serv=>tys_zc_skprodtype,
       create_prod
        EXPORTING ls_data type zcl_prod_serv=>tys_zc_skprodtype.



  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS: gv_root TYPE string VALUE 'https://276860ba-d056-4682-9f44-b4d9470cc840.abap-web.eu10.hana.ondemand.com/sap/opu/odata4/sap/zapi_skprod_o4/srvd_a2x/sap/zapi_skprod_o4/0001/?sap-client=100'.
    CONSTANTS: gv_url_root TYPE string VALUE '/sap/opu/odata4/sap/api_product_srv/srvd_a2x/sap/api_product/0001/'.
ENDCLASS.



CLASS zcl_con_svc1 IMPLEMENTATION.
  method create_prod.

DATA:
  ls_business_data TYPE zcl_prod_serv=>tys_zc_skprodtype,
  lo_http_client   TYPE REF TO if_web_http_client,
  lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
  lo_request       TYPE REF TO /iwbep/if_cp_request_create,
  lo_response      TYPE REF TO /iwbep/if_cp_response_create.


TRY.
" Create http client
*DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
*                                             comm_scenario  = '<Comm Scenario>'
*                                             comm_system_id = '<Comm System Id>'
*                                             service_id     = '<Service Id>' ).
*lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v4_remote_proxy(
  EXPORTING
     is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                         proxy_model_id      = 'ZCL_PROD_SERV'
                                         proxy_model_version = '0001' )
    io_http_client             = lo_http_client
    iv_relative_service_root   = gv_root ).

ASSERT lo_http_client IS BOUND.


* Prepare business data
*ls_business_data = VALUE #(
*          id                     = 30
*          material               = 'Material'
*          description            = 'Description'
*          colour                 = 'Colour'
*          weight                 = 30
*          local_created_by       = 'LocalCreatedBy'
*          local_created_at       = 20170101123000
*          local_last_changed_by  = 'LocalLastChangedBy'
*          local_last_changed_at  = 20170101123000
*          last_changed_at        = 20170101123000 ).
ls_business_data = CORRESPONDING #( ls_data ).

" Navigate to the resource and create a request for the create operation
lo_request = lo_client_proxy->create_resource_for_entity_set( 'ZC_SKPROD' )->create_request_for_create( ).

" Set the business data for the created entity
lo_request->set_business_data( ls_business_data ).

" Execute the request
lo_response = lo_request->execute( ).

" Get the after image
*lo_response->get_business_data( IMPORTING es_business_data = ls_business_data ).

CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
" Handle remote Exception
" It contains details about the problems of your http(s) connection


CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
" Handle Exception

CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
" Handle Exception
RAISE SHORTDUMP lx_web_http_client_error.

ENDTRY.

  endmethod.
  METHOD get_prod.

    DATA:
      ls_entity_key    TYPE zcl_prod_serv=>tys_zc_skprodtype,
      ls_business_data TYPE zcl_prod_serv=>tys_zc_skprodtype,
      lo_http_client   TYPE REF TO if_web_http_client,
      lo_resource      TYPE REF TO /iwbep/if_cp_resource_entity,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request       TYPE REF TO /iwbep/if_cp_request_read,
      lo_response      TYPE REF TO /iwbep/if_cp_response_read.



    TRY.
        " Create http client
*DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
*                                             comm_scenario  = '<Comm Scenario>'
*                                             comm_system_id = '<Comm System Id>'
*                                             service_id     = '<Service Id>' ).
*lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v4_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZCL_PROD_SERV'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = gv_root ).

        ASSERT lo_http_client IS BOUND.


        " Set entity key
        ls_entity_key = VALUE #(
                  id  = iv_prod_id ).

        " Navigate to the resource
        lo_resource = lo_client_proxy->create_resource_for_entity_set( 'ZC_SKPROD' )->navigate_with_key( ls_entity_key ).

        " Execute the request and retrieve the business data
        lo_response = lo_resource->create_request_for_read( )->execute( ).
        lo_response->get_business_data( IMPORTING es_business_data = ls_business_data ).
        rs_prod = ls_business_data.

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        RAISE SHORTDUMP lx_web_http_client_error.


    ENDTRY.
  ENDMETHOD.
  METHOD get_prod_list.

    DATA:
      lt_business_data TYPE TABLE OF zcl_prod_serv=>tys_zc_skprodtype,
      lo_http_client   TYPE REF TO if_web_http_client,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.

*DATA:
* lo_filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
* lo_filter_node_1    TYPE REF TO /iwbep/if_cp_filter_node,
* lo_filter_node_2    TYPE REF TO /iwbep/if_cp_filter_node,
* lo_filter_node_root TYPE REF TO /iwbep/if_cp_filter_node,
* lt_range_ID TYPE RANGE OF int4,
* lt_range_MATERIAL TYPE RANGE OF <element_name>.



    TRY.
        " Create http client
*DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
*                                             comm_scenario  = '<Comm Scenario>'
*                                             comm_system_id = '<Comm System Id>'
*                                             service_id     = '<Service Id>' ).
*lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v4_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZCL_PROD_SERV'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = gv_root ).

        ASSERT lo_http_client IS BOUND.


        " Navigate to the resource and create a request for the read operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'ZC_SKPROD' )->create_request_for_read( ).

        " Create the filter tree
*lo_filter_factory = lo_request->create_filter_factory( ).
*
*lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'ID'
*                                                        it_range             = lt_range_ID ).
*lo_filter_node_2  = lo_filter_factory->create_by_range( iv_property_path     = 'MATERIAL'
*                                                        it_range             = lt_range_MATERIAL ).

*lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 ).
*lo_request->set_filter( lo_filter_node_root ).

        lo_request->set_top( 50 )->set_skip( 0 ).

        " Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = lt_business_data ).

        rt_prod = lt_business_data.

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        RAISE SHORTDUMP lx_web_http_client_error.


    ENDTRY.

  ENDMETHOD.

ENDCLASS.

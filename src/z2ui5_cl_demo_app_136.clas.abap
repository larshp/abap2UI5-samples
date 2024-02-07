CLASS z2ui5_cl_demo_app_136 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_path TYPE string.
    DATA mv_value TYPE string.
    DATA mr_table TYPE REF TO data.
    DATA mv_check_edit TYPE abap_bool.
    DATA mv_check_download TYPE abap_bool.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS ui5_on_event.

    METHODS ui5_view_main_display.

    METHODS ui5_view_init_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_136 IMPLEMENTATION.


  METHOD ui5_on_event.
    TRY.

        CASE client->get( )-event.

          WHEN 'START' OR 'CHANGE'.
            ui5_view_main_display( ).

          WHEN 'UPLOAD'.

            DATA lv_dummy TYPE string.
            DATA lv_data TYPE string.
            SPLIT mv_value AT `;` INTO lv_dummy lv_data.
            SPLIT lv_data AT `,` INTO lv_dummy lv_data.

            DATA lv_data2 TYPE xstring.
            lv_data2 = z2ui5_cl_demo_utility=>decode_x_base64( lv_data ).
            DATA lv_ready TYPE string.
            lv_ready = z2ui5_cl_demo_utility=>get_string_by_xstring( lv_data2 ).

            mr_table = z2ui5_cl_demo_utility=>get_table_by_csv( lv_ready ).
            client->message_box_display( `CSV loaded to table` ).

            ui5_view_main_display( ).

            CLEAR mv_value.
            CLEAR mv_path.

          WHEN 'BACK'.
            client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

        ENDCASE.

        DATA x TYPE REF TO cx_root.
      CATCH cx_root INTO x.
        client->message_box_display( text = x->get_text( ) type = `error` ).
    ENDTRY.

  ENDMETHOD.


  METHOD ui5_view_init_display.

    ui5_view_main_display( ).
*    client->view_display( client->factory_view( )->_ns_z2ui5(
*        )->timer( client->_event( `START` ) )->_ns_html(
*        )->script( )->_add_c( z2ui5_cl_cc_file_uploader=>get_js( )
*        )->_stringify( ) ).
*
*    client->view_display( z2ui5_cl_xml_view=>factory( client
*         )->_cc( )->timer( )->control(
*         )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_file_uploader=>get_js( )
*         )->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_view_main_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp3 TYPE xsdboolean.
    temp3 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = view->shell( )->page(
            title          = 'abap2UI5 - CSV to ABAP internal Table'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = temp3
        )->header_content(
            )->toolbar_spacer(
            )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
        )->get_parent( ).

    IF mr_table IS NOT INITIAL.

      FIELD-SYMBOLS <tab> TYPE table.
      ASSIGN mr_table->* TO <tab>.

      DATA temp1 TYPE string.
      IF mv_check_edit = abap_true.
        temp1 = client->_bind_edit( <tab> ).
      ELSE.
        temp1 = client->_bind_edit( <tab> ).
      ENDIF.
      DATA tab TYPE REF TO z2ui5_cl_xml_view.
      tab = page->table(
              items = temp1
          )->header_toolbar(
              )->overflow_toolbar(
                  )->title( 'CSV Content'
                  )->toolbar_spacer(
          )->get_parent( )->get_parent( ).


      DATA lr_fields TYPE string_table.
      lr_fields = z2ui5_cl_demo_utility=>get_fieldlist_by_table( <tab> ).
      DATA lo_cols TYPE REF TO z2ui5_cl_xml_view.
      lo_cols = tab->columns( ).
      DATA temp2 LIKE LINE OF lr_fields.
      DATA lr_col LIKE REF TO temp2.
      LOOP AT lr_fields REFERENCE INTO lr_col.
        lo_cols->column( )->text( lr_col->* ).
      ENDLOOP.
      DATA lo_cells TYPE REF TO z2ui5_cl_xml_view.
      lo_cells = tab->items( )->column_list_item( )->cells( ).
      LOOP AT lr_fields REFERENCE INTO lr_col.
        lo_cells->text( `{` && lr_col->* && `}` ).
      ENDLOOP.
    ENDIF.

    DATA footer TYPE REF TO z2ui5_cl_xml_view.
    footer = page->footer( )->overflow_toolbar( ).

    footer->_z2ui5( )->file_uploader(
      value       = client->_bind_edit( mv_value )
      path        = client->_bind_edit( mv_path )
      placeholder = 'filepath here...'
      upload      = client->_event( 'UPLOAD' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      ui5_view_init_display( ).
      RETURN.
    ENDIF.

    IF client->get( )-check_on_navigated = abap_true.
      ui5_view_main_display( ).
    ENDIF.

    ui5_on_event( ).

  ENDMETHOD.
ENDCLASS.

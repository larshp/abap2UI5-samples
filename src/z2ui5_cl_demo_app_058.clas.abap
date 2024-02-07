CLASS Z2UI5_CL_DEMO_APP_058 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    TYPES:
      BEGIN OF s_combobox,
        key  TYPE string,
        text TYPE string,
      END OF s_combobox.

    TYPES ty_t_combo TYPE STANDARD TABLE OF s_combobox WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_S_cols,
        visible  TYPE abap_bool,
        name     TYPE string,
        length   TYPE string,
        title    TYPE string,
        editable TYPE abap_bool,
      END OF ty_S_cols.

    TYPES:
      BEGIN OF ty_S_db_layout,
        selkz   TYPE ABap_bool,
        name    TYPE string,
        user    TYPE string,
        default TYPE abap_bool,
        data    TYPE string,
      END OF ty_S_db_layout.
    TYPES temp1_09e4fe8083 TYPE STANDARD TABLE OF ty_S_db_layout.
DATA mt_db_layout TYPE temp1_09e4fe8083.

    TYPES temp2_09e4fe8083 TYPE STANDARD TABLE OF ty_S_cols.
DATA:
      BEGIN OF ms_layout,
        check_zebra   TYPE abap_bool,
        title         TYPE string,
        sticky_header TYPE string,
        selmode       TYPE string,
        t_cols        TYPE temp2_09e4fe8083,
      END OF ms_layout.

    TYPES:
      BEGIN OF ty_s_tab,
        selkz            TYPE abap_bool,
        product          TYPE string,
        create_date      TYPE string,
        create_by        TYPE string,
        storage_location TYPE string,
        quantity         TYPE i,
      END OF ty_s_tab.
    TYPES ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY.

    DATA mv_check_table TYPE abap_bool.

    DATA mv_check_columns TYPE abap_bool.
    DATA mt_table TYPE ty_t_table.

    DATA mv_layout TYPE string.
    DATA mv_check_sort TYPE abap_bool.



  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client.
    DATA:
      BEGIN OF app,
        check_initialized TYPE abap_bool,
        view_main         TYPE string,
        view_popup        TYPE string,
        get               TYPE Z2UI5_if_client=>ty_s_get,
      END OF app.

    METHODS Z2UI5_on_init.
    METHODS Z2UI5_on_event.
    METHODS Z2UI5_on_render.
    METHODS Z2UI5_on_render_main.

    METHODS Z2UI5_set_data.
    METHODS Z2UI5_on_render_popup.
    METHODS Z2UI5_on_render_popup_save.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_058 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    me->client     = client.
    app-get        = client->get( ).
    app-view_popup = ``.
*    app-next-title = `Filter`.


    IF app-check_initialized = abap_false.
      app-check_initialized = abap_true.
      Z2UI5_on_init( ).
    ENDIF.

    IF app-get-event IS NOT INITIAL.
      Z2UI5_on_event( ).
    ENDIF.

    Z2UI5_on_render( ).

*    client->set_next( app-next ).
    CLEAR app-get.
*    CLEAR app-next.

  ENDMETHOD.


  METHOD Z2UI5_on_event.

    CASE app-get-event.
      WHEN `BUTTON_START`.
        Z2UI5_set_data( ).
      WHEN `BUTTON_SETUP`.
        app-view_popup = `POPUP`.
      WHEN `BUTTON_SAVE`.
        app-view_popup = `POPUP_SAVE`.

      WHEN `POPUP_LAYOUT_LOAD`.
        DATA ls_layout2 LIKE LINE OF mt_db_layout.
        DATA temp1 LIKE LINE OF mt_db_layout.
        DATA temp2 LIKE sy-tabix.
        temp2 = sy-tabix.
        READ TABLE mt_db_layout WITH KEY selkz = abap_true INTO temp1.
        sy-tabix = temp2.
        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE cx_sy_itab_line_not_found.
        ENDIF.
        ls_layout2 = temp1.
        z2ui5_cl_demo_utility=>trans_xml_2_object(
          EXPORTING
            xml  = ls_layout2-data
          IMPORTING
             data = ms_layout
        ).
        app-view_popup = `POPUP_SAVE`.

      WHEN `BUTTON_SAVE_LAYOUT`.
        DATA temp1 TYPE ty_s_db_layout.
        CLEAR temp1.
        temp1-data = z2ui5_cl_demo_utility=>trans_data_2_xml( ms_layout ).
        temp1-name = mv_layout.
        DATA ls_layout LIKE temp1.
        ls_layout = temp1.
        INSERT ls_layout INTO TABLE mt_db_layout.
        app-view_popup = `POPUP_SAVE`.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( app-get-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_on_init.

    app-view_main = `MAIN`.

    ms_layout-title = `data`.
    DATA temp2 LIKE ms_layout-t_cols.
    CLEAR temp2.
    DATA temp3 LIKE LINE OF temp2.
    temp3-name = `PRODUCT`.
    temp3-title = `PRODUCT`.
    temp3-visible = abap_true.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `CREATE_DAT`.
    temp3-title = `CREATE_DAT`.
    temp3-visible = abap_true.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `CREATE_BY`.
    temp3-title = `CREATE_BY`.
    temp3-visible = abap_true.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `STORAGE_LOCATION`.
    temp3-title = `STORAGE_LOCATION`.
    temp3-visible = abap_true.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `QUANTITY`.
    temp3-title = `QUANTITY`.
    temp3-visible = abap_true.
    INSERT temp3 INTO TABLE temp2.
    ms_layout-t_cols = temp2.

  ENDMETHOD.


  METHOD Z2UI5_on_render.

    CASE app-view_popup.
      WHEN `POPUP`.
        Z2UI5_on_render_popup( ).
      WHEN `POPUP_SAVE`.
        Z2UI5_on_render_popup_save( ).
    ENDCASE.

    CASE app-view_main.
      WHEN 'MAIN'.
        Z2UI5_on_render_main( ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_on_render_main.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).
       DATA temp1 TYPE xsdboolean.
       temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
       view = view->page( id = `page_main`
                title          = 'abap2UI5 - List Report Features'
                navbuttonpress = client->_event( 'BACK' )
                shownavbutton = temp1
            )->header_content(
                )->link(
                    text = 'Demo' target = '_blank'
                    href = 'https://twitter.com/abap2UI5/status/1662821284873396225'
                )->link(
                    text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
           )->get_parent( ).

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = view->dynamic_page(
            headerexpanded = abap_true
            headerpinned   = abap_true
            ).

    DATA header_title TYPE REF TO z2ui5_cl_xml_view.
    header_title = page->title( ns = 'f'
            )->get( )->dynamic_page_title( ).

    header_title->heading( ns = 'f' )->hbox(
        )->title( `Layout` ).

    header_title->expanded_content( 'f' ).

    header_title->snapped_content( ns = 'f' ).

    DATA lo_box TYPE REF TO z2ui5_cl_xml_view.
    lo_box = page->header( )->dynamic_page_header( pinnable = abap_true
         )->flex_box( alignitems = `Start` justifycontent = `SpaceBetween` )->flex_box( alignItems = `Start` ).

    lo_box->get_parent( )->hbox( justifycontent = `End` )->button(
        text = `Go` press = client->_event( `BUTTON_START` ) type = `Emphasized`
        ).

    DATA cont TYPE REF TO z2ui5_cl_xml_view.
    cont = page->content( ns = 'f' ).

    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    tab = cont->table(
        headertext = ms_layout-title
        items = client->_bind( mt_table )
        alternaterowcolors = ms_layout-check_zebra
        sticky = ms_layout-sticky_header
        autopopinmode = abap_true
        mode = ms_layout-selmode ).

    DATA temp4 TYPE string.
    temp4 = lines( mt_table ).
    tab->header_toolbar(
          )->toolbar(
              )->title( text = ms_layout-title && ` (` && shift_right( temp4 ) && `)` level = `H2`

      )->toolbar_spacer(
              )->button(
                  icon = 'sap-icon://save'
                  press = client->_event( 'BUTTON_SAVE' )
              )->button(
                  icon = 'sap-icon://action-settings'
                  press = client->_event( 'BUTTON_SETUP' )
              ).

    DATA lv_width TYPE i.
    lv_width = 10.
    DATA lo_columns TYPE REF TO z2ui5_cl_xml_view.
    lo_columns = tab->columns( ).
    DATA temp5 LIKE LINE OF ms_layout-t_cols.
    DATA lr_field LIKE REF TO temp5.
    LOOP AT ms_layout-t_cols REFERENCE INTO lr_field
          WHERE visible = abap_true.
      DATA temp6 TYPE string.
      temp6 = lv_width.
      DATA temp3 TYPE char10.
      temp3 = lr_field->title.
      lo_columns->column(
            minscreenwidth = shift_right( temp6 ) && `px`
            demandpopin = abap_true width = lr_field->length )->text( text = temp3
            ).
      lv_width = lv_width + 10.
    ENDLOOP.

    DATA temp7 TYPE string_table.
    CLEAR temp7.
    INSERT `${UUID}` INTO TABLE temp7.
    DATA lo_cells TYPE REF TO z2ui5_cl_xml_view.
    lo_cells = tab->items( )->column_list_item(
        press = client->_event( val = 'DETAIL' t_arg = temp7 )
        selected = `{SELKZ}`
      )->cells( ).

    LOOP AT ms_layout-t_cols REFERENCE INTO lr_field
          WHERE visible = abap_true.
      IF lr_field->editable = abap_true.
        lo_cells->input( `{` && lr_field->name && `}` ).
      ELSE.
        lo_cells->text( text = `{` && lr_field->name && `}` ).
      ENDIF.
    ENDLOOP.

   client->view_display( page->get_root( )->xml_get( ) ).

  ENDMETHOD.


  METHOD Z2UI5_on_render_popup.

    DATA ro_popup TYPE REF TO z2ui5_cl_xml_view.
    ro_popup = Z2UI5_cl_xml_view=>factory_popup( ).

    ro_popup = ro_popup->dialog( title = 'View Setup'  resizable = abap_true
          contentheight = `50%` contentwidth = `50%` ).

    ro_popup->custom_header(
          )->bar(
              )->content_right(
          )->button( text = `zurücksetzten` press = client->_event( 'BUTTON_INIT' ) ).

    DATA lo_tab TYPE REF TO z2ui5_cl_xml_view.
    lo_tab = ro_popup->tab_container( ).

    DATA temp9 TYPE ty_t_combo.
    CLEAR temp9.
    DATA temp10 LIKE LINE OF temp9.
    temp10-key = 'None'.
    temp10-text = 'None'.
    INSERT temp10 INTO TABLE temp9.
    temp10-key = 'SingleSelect'.
    temp10-text = 'SingleSelect'.
    INSERT temp10 INTO TABLE temp9.
    temp10-key = 'SingleSelectLeft'.
    temp10-text = 'SingleSelectLeft'.
    INSERT temp10 INTO TABLE temp9.
    temp10-key = 'MultiSelect'.
    temp10-text = 'MultiSelect'.
    INSERT temp10 INTO TABLE temp9.
    lo_tab->tab( text = 'Table' selected = client->_bind_Edit( mv_check_table )
       )->simple_form( editable = abap_true
           )->content( 'form'
               )->label( 'zebra mode'
               )->checkbox( client->_bind( ms_layout-check_zebra )
               )->label( 'sticky header'
               )->input( client->_bind( ms_layout-sticky_header )
               )->label( text = `Title`
               )->Input( value = client->_bind( ms_layout-title )
               )->label( 'sel mode'
               )->combobox(
                   selectedkey = client->_bind_edit( ms_layout-selmode )
                   items       = client->_bind_local( temp9 )
                   )->item(
                       key = '{KEY}'
                       text = '{TEXT}' ).

    lo_tab->tab(
                text     = 'Columns'
                selected = client->_bind( mv_check_columns )
       )->table(
        items = client->_bind_edit( ms_layout-t_cols )
        )->columns(
            )->column( )->text( 'Visible' )->get_parent(
            )->column( )->text( 'Name' )->get_parent(
            )->column( )->text( 'Title' )->get_parent(
            )->column( )->text( 'Editable' )->get_parent(
            )->column( )->text( 'Length' )->get_parent(
        )->get_parent(
        )->items( )->column_list_item(
            )->cells(
                )->checkbox( '{VISIBLE}'
                )->text( '{NAME}'
                )->Input( '{TITLE}'
                  )->checkbox( '{EDITABLE}'
                  )->Input( '{LENGTH}'
         "       )->text( '{DESCR}'
    )->get_parent( )->get_parent( )->get_parent( )->get_parent(  )->get_parent( ).

   lo_tab->tab(
                   text     = 'Sort'
                   selected = client->_bind( mv_check_sort ) ).

    ro_popup->footer( )->overflow_toolbar(
          )->toolbar_spacer(
          )->button(
              text  = 'continue'
              press = client->_event( 'POPUP_FILTER_CONTINUE' )
              type  = 'Emphasized' ).

    client->popup_display( ro_popup->get_root( )->xml_get( ) ).


  ENDMETHOD.


  METHOD Z2UI5_on_render_popup_save.

    DATA lo_popup TYPE REF TO z2ui5_cl_xml_view.
    lo_popup = Z2UI5_cl_xml_view=>factory_popup( ).

    lo_popup = lo_popup->dialog( title = 'abap2UI5 - Layout'  contentwidth = `50%`
        )->input( description = `Name` value = client->_bind( mv_layout )
        )->button( text = `Save` press = client->_event( `BUTTON_SAVE_LAYOUT` )
        )->table(
            mode = 'SingleSelectLeft'
            items = client->_bind_edit( mt_db_layout )
            )->columns(
                )->column( )->text( 'Name' )->get_parent(
                )->column( )->text( 'User' )->get_parent(
                )->column( )->text( 'Default' )->get_parent(
             "   )->column( )->text( 'Description' )->get_parent(
            )->get_parent(
            )->items( )->column_list_item( selected = '{SELKZ}'
                )->cells(
                    )->text( '{NAME}'
                    )->text( '{USER}'
                    )->text( '{DEFAULT}'
        )->get_parent( )->get_parent( )->get_parent( )->get_parent(
        )->footer( )->overflow_toolbar(
            )->toolbar_spacer(
             )->button(
                text  = 'load'
                press = client->_event( 'POPUP_LAYOUT_LOAD' )
                type  = 'Emphasized'
            )->button(
                text  = 'close'
                press = client->_event( 'POPUP_LAYOUT_CONTINUE' )
                type  = 'Emphasized' ).

       client->popup_display( lo_popup->get_root( )->xml_get( ) ).

  ENDMETHOD.


  METHOD Z2UI5_set_data.

    DATA temp11 TYPE ty_t_table.
    CLEAR temp11.
    DATA temp12 LIKE LINE OF temp11.
    temp12-product = 'table'.
    temp12-create_date = `01.01.2023`.
    temp12-create_by = `Peter`.
    temp12-storage_location = `AREA_001`.
    temp12-quantity = 400.
    INSERT temp12 INTO TABLE temp11.
    temp12-product = 'chair'.
    temp12-create_date = `01.01.2023`.
    temp12-create_by = `Peter`.
    temp12-storage_location = `AREA_001`.
    temp12-quantity = 400.
    INSERT temp12 INTO TABLE temp11.
    temp12-product = 'sofa'.
    temp12-create_date = `01.01.2023`.
    temp12-create_by = `Peter`.
    temp12-storage_location = `AREA_001`.
    temp12-quantity = 400.
    INSERT temp12 INTO TABLE temp11.
    temp12-product = 'computer'.
    temp12-create_date = `01.01.2023`.
    temp12-create_by = `Peter`.
    temp12-storage_location = `AREA_001`.
    temp12-quantity = 400.
    INSERT temp12 INTO TABLE temp11.
    temp12-product = 'oven'.
    temp12-create_date = `01.01.2023`.
    temp12-create_by = `Peter`.
    temp12-storage_location = `AREA_001`.
    temp12-quantity = 400.
    INSERT temp12 INTO TABLE temp11.
    temp12-product = 'table2'.
    temp12-create_date = `01.01.2023`.
    temp12-create_by = `Peter`.
    temp12-storage_location = `AREA_001`.
    temp12-quantity = 400.
    INSERT temp12 INTO TABLE temp11.
    mt_table = temp11.

  ENDMETHOD.
ENDCLASS.

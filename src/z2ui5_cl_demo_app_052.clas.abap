CLASS Z2UI5_CL_DEMO_APP_052 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

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

    DATA mt_table TYPE ty_T_table.
    DATA check_initialized TYPE abap_bool.
    DATA client TYPE REF TO Z2UI5_if_client.

    DATA mv_check_popover TYPE abap_bool.
    DATA mv_product TYPE string.

    METHODS  Z2UI5_set_data.
    METHODS Z2UI5_display_view.
    METHODS Z2UI5_display_popover
      IMPORTING
        id TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_052 IMPLEMENTATION.


  METHOD Z2UI5_display_popover.

    DATA lo_popover TYPE REF TO z2ui5_cl_xml_view.
    lo_popover = Z2UI5_cl_xml_view=>factory_popup( ).

    lo_popover->popover( placement = `Right` title = `abap2UI5 - Popover - ` && mv_product  contentwidth = `50%`
      )->simple_form( editable = abap_true
      )->content( 'form'
          )->label( 'Product'
          )->text(  mv_product
          )->label( 'info2'
          )->text(  `this is a text`
          )->label( 'info3'
          )->text(  `this is a text`
          )->text(  `this is a text`
        )->get_parent( )->get_parent(
        )->footer(
         )->overflow_toolbar(
            )->toolbar_spacer(
            )->button(
                text  = 'details'
                press = client->_event( 'BUTTON_DETAILS' )
                type  = 'Emphasized'
                ).

    client->popover_display( xml = lo_popover->stringify( )  by_id = id ).

  ENDMETHOD.


  METHOD Z2UI5_display_view.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp2 TYPE xsdboolean.
    temp2 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = view->page( id = `page_main`
            title          = 'abap2UI5 - List Report Features'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = temp2
        )->header_content(
            )->link(
                text = 'Demo' target = '_blank'
                href = 'https://twitter.com/abap2UI5/status/1662001605950971904'
            )->link(
                text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
       )->get_parent( ).

    page = page->dynamic_page( headerexpanded = abap_true  headerpinned = abap_true ).

    DATA header_title TYPE REF TO z2ui5_cl_xml_view.
    header_title = page->title( ns = 'f'  )->get( )->dynamic_page_title( ).
    header_title->heading( ns = 'f' )->hbox( )->title( `Item Popover` ).
    header_title->expanded_content( 'f' ).
    header_title->snapped_content( ns = 'f' ).

    DATA lo_box TYPE REF TO z2ui5_cl_xml_view.
    lo_box = page->header( )->dynamic_page_header( pinnable = abap_true
         )->flex_box( alignitems = `Start` justifycontent = `SpaceBetween` )->flex_box( alignItems = `Start` ).

    lo_box->get_parent( )->hbox( justifycontent = `End` )->button(
        text = `Go`
        press = client->_event( `BUTTON_START` )
        type = `Emphasized` ).

    DATA cont TYPE REF TO z2ui5_cl_xml_view.
    cont = page->content( ns = 'f' ).

    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    tab = cont->table( items = client->_bind_edit( val = mt_table ) ).

    tab->header_toolbar(
            )->toolbar(
                )->toolbar_spacer(
                )->button(
                    icon = 'sap-icon://download'
                    press = client->_event( 'BUTTON_DOWNLOAD' )
                ).

    DATA lo_columns TYPE REF TO z2ui5_cl_xml_view.
    lo_columns = tab->columns( ).
    lo_columns->column( )->text( text = `Product` ).
    lo_columns->column( )->text( text = `Date` ).
    lo_columns->column( )->text( text = `Name` ).
    lo_columns->column( )->text( text = `Location` ).
    lo_columns->column( )->text( text = `Quantity` ).

    DATA lo_cells TYPE REF TO z2ui5_cl_xml_view.
    lo_cells = tab->items( )->column_list_item( ).
    DATA temp1 TYPE string_table.
    CLEAR temp1.
    INSERT `${$source>/id}` INTO TABLE temp1.
    INSERT `${PRODUCT}` INTO TABLE temp1.
    lo_cells->link( text = '{PRODUCT}' press = client->_event( val = `POPOVER_DETAIL` t_arg = temp1  ) ).
    lo_cells->text( `{CREATE_DATE}` ).
    lo_cells->text( `{CREATE_BY}` ).
    lo_cells->text( `{STORAGE_LOCATION}` ).
    lo_cells->text( `{QUANTITY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      Z2UI5_display_view( ).
      RETURN.
    ENDIF.

    CASE client->get( )-event.

      when `BUTTON_DETAILS`.
        client->popover_destroy( ).

      WHEN `POPOVER_DETAIL`.
        DATA lt_arg TYPE string_table.
        lt_arg = client->get( )-t_event_arg.
        DATA lv_open_by_id LIKE LINE OF lt_arg.
        DATA temp1 LIKE LINE OF lt_arg.
        DATA temp2 LIKE sy-tabix.
        temp2 = sy-tabix.
        READ TABLE lt_arg INDEX 1 INTO temp1.
        sy-tabix = temp2.
        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE cx_sy_itab_line_not_found.
        ENDIF.
        lv_open_by_id = temp1.
        mv_check_popover = abap_true.
        DATA temp3 LIKE LINE OF lt_arg.
        DATA temp4 LIKE sy-tabix.
        temp4 = sy-tabix.
        READ TABLE lt_arg INDEX 2 INTO temp3.
        sy-tabix = temp4.
        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE cx_sy_itab_line_not_found.
        ENDIF.
        mv_product = temp3.
        Z2UI5_display_popover( lv_open_by_id ).

      WHEN 'BUTTON_START'.
        Z2UI5_set_data( ).
        client->view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.


  ENDMETHOD.


  METHOD Z2UI5_set_data.

    DATA temp5 TYPE ty_t_table.
    CLEAR temp5.
    DATA temp6 LIKE LINE OF temp5.
    temp6-product = 'table'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Peter`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 400.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'chair'.
    temp6-create_date = `01.01.2022`.
    temp6-create_by = `James`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 123.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'sofa'.
    temp6-create_date = `01.05.2021`.
    temp6-create_by = `Simone`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 700.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'computer'.
    temp6-create_date = `27.01.2023`.
    temp6-create_by = `Theo`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 200.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'printer'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Hannah`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 90.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'table2'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Julia`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 110.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'table'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Peter`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 400.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'chair'.
    temp6-create_date = `01.01.2022`.
    temp6-create_by = `James`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 123.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'sofa'.
    temp6-create_date = `01.05.2021`.
    temp6-create_by = `Simone`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 700.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'computer'.
    temp6-create_date = `27.01.2023`.
    temp6-create_by = `Theo`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 200.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'printer'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Hannah`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 90.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'table2'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Julia`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 110.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'table'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Peter`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 400.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'chair'.
    temp6-create_date = `01.01.2022`.
    temp6-create_by = `James`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 123.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'sofa'.
    temp6-create_date = `01.05.2021`.
    temp6-create_by = `Simone`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 700.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'computer'.
    temp6-create_date = `27.01.2023`.
    temp6-create_by = `Theo`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 200.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'printer'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Hannah`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 90.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'table2'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Julia`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 110.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'table'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Peter`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 400.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'chair'.
    temp6-create_date = `01.01.2022`.
    temp6-create_by = `James`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 123.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'sofa'.
    temp6-create_date = `01.05.2021`.
    temp6-create_by = `Simone`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 700.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'computer'.
    temp6-create_date = `27.01.2023`.
    temp6-create_by = `Theo`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 200.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'printer'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Hannah`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 90.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'table2'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Julia`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 110.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'table'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Peter`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 400.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'chair'.
    temp6-create_date = `01.01.2022`.
    temp6-create_by = `James`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 123.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'sofa'.
    temp6-create_date = `01.05.2021`.
    temp6-create_by = `Simone`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 700.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'computer'.
    temp6-create_date = `27.01.2023`.
    temp6-create_by = `Theo`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 200.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'printer'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Hannah`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 90.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'table2'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Julia`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 110.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'table'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Peter`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 400.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'chair'.
    temp6-create_date = `01.01.2022`.
    temp6-create_by = `James`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 123.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'sofa'.
    temp6-create_date = `01.05.2021`.
    temp6-create_by = `Simone`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 700.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'computer'.
    temp6-create_date = `27.01.2023`.
    temp6-create_by = `Theo`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 200.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'printer'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Hannah`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 90.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'table2'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Julia`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 110.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'table'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Peter`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 400.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'chair'.
    temp6-create_date = `01.01.2022`.
    temp6-create_by = `James`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 123.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'sofa'.
    temp6-create_date = `01.05.2021`.
    temp6-create_by = `Simone`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 700.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'computer'.
    temp6-create_date = `27.01.2023`.
    temp6-create_by = `Theo`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 200.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'printer'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Hannah`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 90.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'table2'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Julia`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 110.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'table'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Peter`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 400.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'chair'.
    temp6-create_date = `01.01.2022`.
    temp6-create_by = `James`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 123.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'sofa'.
    temp6-create_date = `01.05.2021`.
    temp6-create_by = `Simone`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 700.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'computer'.
    temp6-create_date = `27.01.2023`.
    temp6-create_by = `Theo`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 200.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'printer'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Hannah`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 90.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = 'table2'.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Julia`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 110.
    INSERT temp6 INTO TABLE temp5.
    mt_table = temp5.


  ENDMETHOD.
ENDCLASS.

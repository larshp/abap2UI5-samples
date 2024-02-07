CLASS Z2UI5_CL_DEMO_APP_071 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES Z2UI5_if_app .

    TYPES:
      BEGIN OF ty_value_map,
        pc TYPE string,
        ea TYPE string,
      END OF ty_value_map.

    TYPES:
      BEGIN OF ty_column_config,
        label             TYPE string,
        property          TYPE string,
        type              TYPE string,
        unit              TYPE string,
        delimiter         TYPE abap_bool,
        unit_property     TYPE string,
        width             TYPE string,
        scale             TYPE i,
        text_align        TYPE string,
        display_unit      TYPE string,
        true_value        TYPE string,
        false_value       TYPE string,
        template          TYPE string,
        input_format      TYPE string,
        wrap              TYPE abap_bool,
        auto_scale        TYPE abap_bool,
        timezone          TYPE string,
        timezone_property TYPE string,
        display_timezone  TYPE abap_bool,
        utc               TYPE abap_bool,
        value_map         TYPE ty_value_map,
      END OF ty_column_config.

    TYPES temp1_20ee6210d6 TYPE STANDARD TABLE OF ty_column_config WITH DEFAULT KEY.
DATA: mt_column_config TYPE temp1_20ee6210d6.
    DATA: mv_column_config TYPE string.

    TYPES:
      BEGIN OF ty_s_tab,
        selkz           TYPE abap_bool,
        rowid           TYPE string,
        product         TYPE string,
        createdate      TYPE string,
        createby        TYPE string,
        storagelocation TYPE string,
        quantity        TYPE i,
        meins           TYPE meins,
        price           TYPE p LENGTH 10 DECIMALS 2,
        waers           TYPE waers,
        selected        TYPE abap_bool,
      END OF ty_s_tab .
    TYPES:
      ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_s_filter_pop,
        option TYPE string,
        low    TYPE string,
        high   TYPE string,
        key    TYPE string,
      END OF ty_s_filter_pop .

    DATA mt_mapping TYPE Z2UI5_if_client=>ty_t_name_value .
    DATA mv_search_value TYPE string .
    DATA mt_table TYPE ty_t_table .
    DATA lv_selkz TYPE abap_bool .
  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client.
    DATA check_initialized TYPE abap_bool VALUE abap_false.

    METHODS Z2UI5_on_init.
    METHODS Z2UI5_on_event.
    METHODS Z2UI5_set_search.
    METHODS Z2UI5_set_data.

  PRIVATE SECTION.

    METHODS set_selkz
      IMPORTING
        iv_selkz TYPE abap_bool.

ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_071 IMPLEMENTATION.


  METHOD set_selkz.

    FIELD-SYMBOLS: <ls_table> TYPE ty_s_tab.

    LOOP AT mt_table ASSIGNING <ls_table>.
      <ls_table>-selkz = iv_selkz.
    ENDLOOP.

  ENDMETHOD.


  METHOD Z2UI5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      Z2UI5_set_data( ).

      client->view_display( Z2UI5_cl_xml_view=>factory(
        )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_spreadsheet=>get_js( mv_column_config )
        )->_z2ui5( )->timer(  client->_event( 'START' )
        )->stringify( ) ).

      RETURN.
    ENDIF.

    Z2UI5_on_event( ).

  ENDMETHOD.


  METHOD Z2UI5_on_event.

    CASE client->get( )-event.
      WHEN 'START'.
*        Z2UI5_set_data( ).
        Z2UI5_on_init( ).
      WHEN 'BUTTON_SEARCH' OR 'BUTTON_START'.
*        client->message_toast_display( 'Search Entries' ).
*        Z2UI5_set_data( ).
        Z2UI5_set_search( ).
        client->view_model_update( ).
      WHEN 'SORT'.
        DATA lt_arg TYPE string_table.
        lt_arg = client->get( )-t_event_arg.
        client->message_toast_display( 'Event SORT' ).
      WHEN 'FILTER'.
        lt_arg = client->get( )-t_event_arg.
        client->message_toast_display( 'Event FILTER' ).
      WHEN 'SELKZ'.
        client->message_toast_display( |'Event SELKZ' { lv_selkz } | ).
        set_selkz( lv_selkz ).
        client->view_model_update( ).
      WHEN 'CUSTOMFILTER'.
        lt_arg = client->get( )-t_event_arg.
        client->message_toast_display( 'Event CUSTOMFILTER' ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
      WHEN 'ROWEDIT'.
        lt_arg = client->get( )-t_event_arg.
        DATA ls_arg TYPE string.
        READ TABLE lt_arg INTO ls_arg INDEX 1.
        IF sy-subrc = 0.
          client->message_toast_display( |Event ROWEDIT Row Index { ls_arg } | ).
        ENDIF.

      WHEN 'ROW_ACTION_ITEM_NAVIGATION'.
        lt_arg = client->get( )-t_event_arg.
        READ TABLE lt_arg INTO ls_arg INDEX 1.
        IF sy-subrc = 0.
          client->message_toast_display( |Event ROW_ACTION_ITEM_NAVIGATION Row Index { ls_arg } | ).
        ENDIF.

      WHEN 'ROW_ACTION_ITEM_EDIT'.
        lt_arg = client->get( )-t_event_arg.
        READ TABLE lt_arg INTO ls_arg INDEX 1.
        IF sy-subrc = 0.
          client->message_toast_display( |Event ROW_ACTION_ITEM_EDIT Row Index { ls_arg } | ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_on_init.

    DATA temp1 LIKE mt_mapping.
    CLEAR temp1.
    DATA temp2 LIKE LINE OF temp1.
    temp2-n = `EQ`.
    temp2-v = `={LOW}`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `LT`.
    temp2-v = `<{LOW}`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `LE`.
    temp2-v = `<={LOW}`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `GT`.
    temp2-v = `>{LOW}`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `GE`.
    temp2-v = `>={LOW}`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `CP`.
    temp2-v = `*{LOW}*`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `BT`.
    temp2-v = `{LOW}...{HIGH}`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `NE`.
    temp2-v = `!(={LOW})`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `NE`.
    temp2-v = `!(<leer>)`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `<leer>`.
    temp2-v = `<leer>`.
    INSERT temp2 INTO TABLE temp1.
    mt_mapping = temp1.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    DATA page1 TYPE REF TO z2ui5_cl_xml_view.
    DATA temp5 TYPE xsdboolean.
    temp5 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page1 = view->page( id = `page_main`
            title          = 'abap2UI5 - sap.ui.table.Table Features'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = temp5
            class = 'sapUiContentPadding' ).

    page1->header_content(
          )->link(
              text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
     ).

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = page1->dynamic_page( headerexpanded = abap_true headerpinned = abap_true ).

    DATA header_title TYPE REF TO z2ui5_cl_xml_view.
    header_title = page->title( ns = 'f'  )->get( )->dynamic_page_title( ).
    header_title->heading( ns = 'f' )->hbox( )->title( `Search Field` ).
    header_title->expanded_content( 'f' ).
    header_title->snapped_content( ns = 'f' ).

    DATA lo_box TYPE REF TO z2ui5_cl_xml_view.
    lo_box = page->header( )->dynamic_page_header( pinnable = abap_true
         )->flex_box( alignitems = `Start` justifycontent = `SpaceBetween` )->flex_box( alignitems = `Start` ).

    lo_box->vbox( )->text( `Search` )->search_field(
         value  = client->_bind_edit( mv_search_value )
         search = client->_event( 'BUTTON_SEARCH' )
         change = client->_event( 'BUTTON_SEARCH' )
*         livechange = client->__event( 'BUTTON_SEARCH' )
         width  = `17.5rem`
         id     = `SEARCH` ).

    lo_box->get_parent( )->hbox( justifycontent = `End` )->button(
        text = `Go`
        press = client->_event( `BUTTON_START` )
        type = `Emphasized`
        ).

    DATA cont TYPE REF TO z2ui5_cl_xml_view.
    cont = page->content( ns = 'f' ).

    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    tab = cont->ui_table( rows = client->_bind( val = mt_table )
                                editable = abap_false
                                id = 'exportTable'
                                alternaterowcolors = abap_true
                                enablegrouping = abap_false
                                fixedcolumncount = '1'
                                rowactioncount = '2'
                                selectionmode = 'None'
                                sort = client->_event( 'SORT' )
                                filter = client->_event( 'FILTER' )
                                customfilter =  client->_event( 'CUSTOMFILTER' ) ).
    tab->ui_extension( )->overflow_toolbar( )->title( text = 'Products' )->toolbar_spacer( )->_z2ui5( )->spreadsheet_export( tableid = 'exportTable' icon = 'sap-icon://excel-attachment' type = 'Emphasized' ).
    DATA lo_columns TYPE REF TO z2ui5_cl_xml_view.
    lo_columns = tab->ui_columns( ).
    lo_columns->ui_column( width = '4rem' )->checkbox( selected = client->_bind_edit( lv_selkz ) enabled = abap_true select = client->_event( val = `SELKZ` ) )->ui_template( )->checkbox( selected = `{SELKZ}`  ).
    lo_columns->ui_column( width = '5rem' sortproperty = 'ROWID'
                                          filterproperty = 'ROWID' )->text( text = `Index` )->ui_template( )->text(   text = `{ROWID}` ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'PRODUCT'
                           filterproperty = 'PRODUCT' )->text( text = `Product` )->ui_template( )->input( value = `{PRODUCT}` editable = abap_false ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'CREATEDATE' filterproperty = 'CREATEDATE' )->text( text = `Date` )->ui_template( )->text(  '{CREATEDATE}' ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'CREATEBY' filterproperty = 'CREATEBY')->text( text = `Name` )->ui_template( )->text( text = `{CREATEBY}` ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'STORAGELOCATION'  filterproperty = 'STORAGELOCATION' )->text( text = `Location` )->ui_template( )->text( text = `{STORAGELOCATION}`).
    lo_columns->ui_column( width = '11rem' sortproperty = 'QUANTITY' filterproperty = 'QUANTITY' )->text( text = `Quantity` )->ui_template( )->text( text = `{QUANTITY}`).
    lo_columns->ui_column( width = '6rem' sortproperty = 'MEINS' filterproperty = 'MEINS' )->text( text = `Unit` )->ui_template( )->text( text = `{MEINS}`).
    lo_columns->ui_column( width = '11rem' sortproperty = 'PRICE' filterproperty = 'PRICE' )->text( text = `Price` )->ui_template( )->currency( value = `{PRICE}` currency = `{WAERS}` ).
*    lo_columns->Ui_column( width = '4rem' )->text( )->ui_template( )->overflow_toolbar( )->overflow_toolbar_button( icon = 'sap-icon://edit' type = 'Transparent' press = client->_event( val = `ROWEDIT` t_arg = VALUE #( ( `${ROW_ID}` ) ) ) ).

    DATA temp3 TYPE string_table.
    CLEAR temp3.
    INSERT `${ROWID}` INTO TABLE temp3.
    DATA temp4 TYPE string_table.
    CLEAR temp4.
    INSERT `${ROWID}` INTO TABLE temp4.
    lo_columns->get_parent( )->ui_row_action_template( )->ui_row_action(
    )->ui_row_action_item( type = 'Navigation'
                           press = client->_event( val = 'ROW_ACTION_ITEM_NAVIGATION' t_arg = temp3 )
                          )->get_parent( )->ui_row_action_item( icon = 'sap-icon://edit' text = 'Edit' press = client->_event( val = 'ROW_ACTION_ITEM_EDIT' t_arg = temp4 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_set_data.

    DATA temp5 TYPE ty_t_table.
    CLEAR temp5.
    DATA temp6 LIKE LINE OF temp5.
    temp6-selkz = abap_false.
    temp6-rowid = '1'.
    temp6-product = 'table'.
    temp6-createdate = `01.01.2023`.
    temp6-createby = `Olaf`.
    temp6-storagelocation = `AREA_001`.
    temp6-quantity = 400.
    temp6-meins = 'PC'.
    temp6-price = '1000.50'.
    temp6-waers = 'EUR'.
    INSERT temp6 INTO TABLE temp5.
    temp6-selkz = abap_false.
    temp6-rowid = '2'.
    temp6-product = 'chair'.
    temp6-createdate = `01.01.2022`.
    temp6-createby = `Karlo`.
    temp6-storagelocation = `AREA_001`.
    temp6-quantity = 123.
    temp6-meins = 'PC'.
    temp6-price = '2000.55'.
    temp6-waers = 'USD'.
    INSERT temp6 INTO TABLE temp5.
    temp6-selkz = abap_false.
    temp6-rowid = '3'.
    temp6-product = 'sofa'.
    temp6-createdate = `01.05.2021`.
    temp6-createby = `Elin`.
    temp6-storagelocation = `AREA_002`.
    temp6-quantity = 700.
    temp6-meins = 'PC'.
    temp6-price = '3000.11'.
    temp6-waers = 'CNY'.
    INSERT temp6 INTO TABLE temp5.
    temp6-selkz = abap_false.
    temp6-rowid = '4'.
    temp6-product = 'computer'.
    temp6-createdate = `27.01.2023`.
    temp6-createby = `Theo`.
    temp6-storagelocation = `AREA_002`.
    temp6-quantity = 200.
    temp6-meins = 'EA'.
    temp6-price = '4000.88'.
    temp6-waers = 'USD'.
    INSERT temp6 INTO TABLE temp5.
    temp6-selkz = abap_false.
    temp6-rowid = '5'.
    temp6-product = 'printer'.
    temp6-createdate = `01.01.2023`.
    temp6-createby = `Renate`.
    temp6-storagelocation = `AREA_003`.
    temp6-quantity = 90.
    temp6-meins = 'PC'.
    temp6-price = '5000.47'.
    temp6-waers = 'EUR'.
    INSERT temp6 INTO TABLE temp5.
    temp6-selkz = abap_false.
    temp6-rowid = '6'.
    temp6-product = 'table2'.
    temp6-createdate = `01.01.2023`.
    temp6-createby = `Angela`.
    temp6-storagelocation = `AREA_003`.
    temp6-quantity = 1110.
    temp6-meins = 'PC'.
    temp6-price = '6000.33'.
    temp6-waers = 'GBP'.
    INSERT temp6 INTO TABLE temp5.
    mt_table = temp5.

    DATA temp7 LIKE mt_column_config.
    CLEAR temp7.
    DATA temp8 LIKE LINE OF temp7.
    temp8-label = 'Index'.
    temp8-property = 'ROWID'.
    temp8-type = 'String'.
    INSERT temp8 INTO TABLE temp7.
    temp8-label = 'Product'.
    temp8-property = 'PRODUCT'.
    temp8-type = 'String'.
    INSERT temp8 INTO TABLE temp7.
    temp8-label = 'Date'.
    temp8-property = 'CREATEDATE'.
    temp8-type = 'String'.
    INSERT temp8 INTO TABLE temp7.
    temp8-label = 'Name'.
    temp8-property = 'CREATEBY'.
    temp8-type = 'String'.
    INSERT temp8 INTO TABLE temp7.
    temp8-label = 'Location'.
    temp8-property = 'STORAGELOCATION'.
    temp8-type = 'String'.
    INSERT temp8 INTO TABLE temp7.
    temp8-label = 'Quantity'.
    temp8-property = 'QUANTITY'.
    temp8-type = 'Number'.
    temp8-delimiter = abap_true.
    INSERT temp8 INTO TABLE temp7.
    temp8-label = 'Unit'.
    temp8-property = 'MEINS'.
    temp8-type = 'String'.
    INSERT temp8 INTO TABLE temp7.
    temp8-label = 'Price'.
    temp8-property = 'PRICE'.
    temp8-type = 'Currency'.
    temp8-unit_property = 'WAERS'.
    temp8-width = 14.
    temp8-scale = 2.
    INSERT temp8 INTO TABLE temp7.
    mt_column_config = temp7.

    mv_column_config =  /ui2/cl_json=>serialize(
                          data             = mt_column_config
                          compress         = abap_true
                          pretty_name      = 'X' "camel_case
                        ).

  ENDMETHOD.


  METHOD Z2UI5_set_search.

    IF mv_search_value IS NOT INITIAL.

      DATA temp9 LIKE LINE OF mt_table.
      DATA lr_row LIKE REF TO temp9.
      LOOP AT mt_table REFERENCE INTO lr_row.
        DATA lv_row TYPE string.
        lv_row = ``.
        DATA lv_index TYPE i.
        lv_index = 1.
        DO.
          FIELD-SYMBOLS <field> TYPE any.
          ASSIGN COMPONENT lv_index OF STRUCTURE lr_row->* TO <field>.
          IF sy-subrc <> 0.
            EXIT.
          ENDIF.
          lv_row = lv_row && <field>.
          lv_index = lv_index + 1.
        ENDDO.

        IF lv_row NS mv_search_value.
          DELETE mt_table.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.

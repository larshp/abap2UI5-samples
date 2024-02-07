CLASS z2ui5_cl_demo_app_090 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    TYPES: BEGIN OF t_items2,
             columnkey TYPE string,
             text      TYPE string,
             visible   TYPE abap_bool,
             index     TYPE i,
           END OF t_items2.
    TYPES: tt_items2 TYPE STANDARD TABLE OF t_items2 WITH DEFAULT KEY.

    TYPES: BEGIN OF t_items3,
             columnkey     TYPE string,
             operation     TYPE string,
             showifgrouped TYPE abap_bool,
             key           TYPE string,
             text          TYPE string,
           END OF t_items3.
    TYPES: tt_items3 TYPE STANDARD TABLE OF t_items3 WITH DEFAULT KEY.

    DATA: mt_columns TYPE tt_items2.
    DATA: mt_columns1 TYPE tt_items2.
    DATA: mt_groups TYPE tt_items3.

    "P13N
    TYPES: BEGIN OF t_items22,
             visible TYPE abap_bool,
             name    TYPE string,
             label   TYPE string,
           END OF t_items22.
    TYPES: tt_items22 TYPE STANDARD TABLE OF t_items22 WITH DEFAULT KEY.

    TYPES: BEGIN OF t_items32,
             sorted     TYPE abap_bool,
             name       TYPE string,
             label      TYPE string,
             descending TYPE abap_bool,
           END OF t_items32.
    TYPES: tt_items32 TYPE STANDARD TABLE OF t_items32 WITH DEFAULT KEY.

    TYPES: BEGIN OF t_items33,
             grouped TYPE abap_bool,
             name    TYPE string,
             label   TYPE string,
           END OF t_items33.
    TYPES: tt_items33 TYPE STANDARD TABLE OF t_items33 WITH DEFAULT KEY.

    DATA: mt_columns_p13n TYPE tt_items22.
    DATA: mt_sort_p13n TYPE tt_items32.
    DATA: mt_groups_p13n TYPE tt_items33.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_view_display.
    METHODS z2ui5_view_p13n.
    METHODS z2ui5_view_p13n_popup.
    METHODS z2ui5_on_event.


  PRIVATE SECTION.
    DATA mv_page TYPE string.

ENDCLASS.



CLASS z2ui5_cl_demo_app_090 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      DATA temp1 TYPE tt_items2.
      CLEAR temp1.
      DATA temp2 LIKE LINE OF temp1.
      temp2-columnkey = `productId`.
      temp2-text = `Product ID`.
      INSERT temp2 INTO TABLE temp1.
      temp2-columnkey = `name`.
      temp2-text = `Name`.
      INSERT temp2 INTO TABLE temp1.
      temp2-columnkey = `category`.
      temp2-text = `Category`.
      INSERT temp2 INTO TABLE temp1.
      temp2-columnkey = `supplierName`.
      temp2-text = `Supplier Name`.
      INSERT temp2 INTO TABLE temp1.
      mt_columns =  temp1.
      DATA temp3 TYPE tt_items2.
      CLEAR temp3.
      DATA temp4 LIKE LINE OF temp3.
      temp4-columnkey = `name`.
      temp4-visible = abap_true.
      temp4-index = 0.
      INSERT temp4 INTO TABLE temp3.
      temp4-columnkey = `category`.
      temp4-visible = abap_true.
      temp4-index = 1.
      INSERT temp4 INTO TABLE temp3.
      temp4-columnkey = `productId`.
      temp4-visible = abap_false.
      INSERT temp4 INTO TABLE temp3.
      temp4-columnkey = `supplierName`.
      temp4-visible = abap_false.
      INSERT temp4 INTO TABLE temp3.
      mt_columns1 = temp3.

      DATA temp5 TYPE tt_items3.
      CLEAR temp5.
      DATA temp6 LIKE LINE OF temp5.
      temp6-columnkey = `name`.
      temp6-text = `Name`.
      temp6-showifgrouped = abap_true.
      INSERT temp6 INTO TABLE temp5.
      temp6-columnkey = `category`.
      temp6-text = `Category`.
      temp6-showifgrouped = abap_true.
      INSERT temp6 INTO TABLE temp5.
      temp6-columnkey = `productId`.
      temp6-showifgrouped = abap_false.
      INSERT temp6 INTO TABLE temp5.
      temp6-columnkey = `supplierName`.
      temp6-showifgrouped = abap_false.
      INSERT temp6 INTO TABLE temp5.
      mt_groups = temp5.


      DATA temp7 TYPE tt_items22.
      CLEAR temp7.
      DATA temp8 LIKE LINE OF temp7.
      temp8-visible = `true`.
      temp8-name = `key1`.
      temp8-label = `City`.
      INSERT temp8 INTO TABLE temp7.
      temp8-visible = `false`.
      temp8-name = `key2`.
      temp8-label = `Country`.
      INSERT temp8 INTO TABLE temp7.
      temp8-visible = `false`.
      temp8-name = `key2`.
      temp8-label = `Region`.
      INSERT temp8 INTO TABLE temp7.
      mt_columns_p13n = temp7.

      DATA temp9 TYPE tt_items32.
      CLEAR temp9.
      DATA temp10 LIKE LINE OF temp9.
      temp10-sorted = `true`.
      temp10-name = `key1`.
      temp10-label = `City`.
      temp10-descending = `true`.
      INSERT temp10 INTO TABLE temp9.
      temp10-sorted = `false`.
      temp10-name = `key2`.
      temp10-label = `Country`.
      temp10-descending = `false`.
      INSERT temp10 INTO TABLE temp9.
      temp10-sorted = `false`.
      temp10-name = `key2`.
      temp10-label = `Region`.
      temp10-descending = `false`.
      INSERT temp10 INTO TABLE temp9.
      mt_sort_p13n = temp9.

      DATA temp11 TYPE tt_items33.
      CLEAR temp11.
      DATA temp12 LIKE LINE OF temp11.
      temp12-grouped = `true`.
      temp12-name = `key1`.
      temp12-label = `City`.
      INSERT temp12 INTO TABLE temp11.
      temp12-grouped = `false`.
      temp12-name = `key2`.
      temp12-label = `Country`.
      INSERT temp12 INTO TABLE temp11.
      temp12-grouped = `false`.
      temp12-name = `key2`.
      temp12-label = `Region`.
      INSERT temp12 INTO TABLE temp11.
      mt_groups_p13n = temp11.

      DATA lv_custom_js TYPE string.
      lv_custom_js = `sap.z2ui5.setInitialData = () => {` && |\n| &&
                           `    debugger;` && |\n| &&
                           `    var oView = sap.z2ui5.oView` && |\n| &&
                           `    var oSelectionPanel = oView.byId("columnsPanel");` && |\n| &&
                           `    var oSortPanel = oView.byId("sortPanel");` && |\n| &&
                           `    var oGroupPanel = oView.byId("groupPanel");` && |\n| &&
                           `    oSelectionPanel.setP13nData(oView.getModel().oData.EDIT.MT_COLUMNS_P13N);` && |\n| &&
                           `    oSortPanel.setP13nData(oView.getModel().oData.EDIT.MT_SORT_P13N);` && |\n| &&
                           `    oGroupPanel.setP13nData(oView.getModel().oData.EDIT.MT_GROUPS_P13N);` && |\n| &&
                           `    var oPopup = oView.byId("p13nPopup");` && |\n| &&
                           `    oPopup.open();` && |\n| &&
                           `};` && |\n| &&
                           `sap.z2ui5.updateData = (oReason) => {` && |\n| &&
                           `  if( oReason === "Ok" ) {` && |\n| &&
                           `    var oView = sap.z2ui5.oView` && |\n| &&
                           `    var oSelectionPanel = oView.byId("columnsPanel");` && |\n| &&
                           `    var oSortPanel = oView.byId("sortPanel");` && |\n| &&
                           `    var oGroupPanel = oView.byId("groupPanel");` && |\n| &&
                           `    oView.getModel().oData.EDIT.MT_COLUMNS_P13N = oSelectionPanel.getP13nData();` && |\n| &&
                           `    oView.getModel().oData.EDIT.MT_SORT_P13N = oSortPanel.getP13nData();` && |\n| &&
                           `    oView.getModel().oData.EDIT.MT_GROUPS_P13N = oGroupPanel.getP13nData();` && |\n| &&
                           `  };` && |\n| &&
                           `};`.

      client->view_display( z2ui5_cl_xml_view=>factory(
       )->_z2ui5( )->timer(  client->_event( `DISPLAY_VIEW` )
        )->_generic( ns = `html` name = `script` )->_cc_plain_xml( lv_custom_js
        "val = `<html:script>` && lv_custom_js && `</html:script>`
        )->stringify( ) ).

*    client->timer_set(
*      interval_ms    = '0'
*      event_finished = client->_event( 'DISPLAY_VIEW' )
*    ).

      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'DISPLAY_VIEW'.
        z2ui5_view_display( ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN 'P13N_OPEN'.
        z2ui5_view_p13n( ).

      WHEN 'P13N_POPUP'.
        z2ui5_view_p13n_popup( ).

      WHEN 'OK' OR 'CANCEL'.
        client->popup_destroy( ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_view_display.

*    client->_bind_edit( val = mt_columns_p13n pretty_mode = 'L' ).
*    client->_bind_edit( val = mt_sort_p13n pretty_mode = 'L' ).
*    client->_bind_edit( val = mt_groups_p13n pretty_mode = 'L' ).
    client->_bind_edit( val = mt_columns_p13n custom_mapper = z2ui5_cl_ajson_mapping=>create_lower_case( ) ).
    client->_bind_edit( val = mt_sort_p13n custom_mapper = z2ui5_cl_ajson_mapping=>create_lower_case( ) ).
    client->_bind_edit( val = mt_groups_p13n custom_mapper = z2ui5_cl_ajson_mapping=>create_lower_case( )  ).

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page =  z2ui5_cl_xml_view=>factory( ).

    DATA temp9 TYPE xsdboolean.
    temp9 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = page->shell( )->page(
        title          = 'abap2UI5 - P13N Dialog'
        navbuttonpress = client->_event( 'BACK' )
        shownavbutton = temp9
        class = 'sapUiContentPadding' ).

    page = page->vbox( ).

    DATA temp13 TYPE z2ui5_if_types=>ty_t_name_value.
    CLEAR temp13.
    DATA temp14 LIKE LINE OF temp13.
    temp14-n = `title`.
    temp14-v = `My Custom View Settings`.
    INSERT temp14 INTO TABLE temp13.
    temp14-n = `close`.
    temp14-v = `sap.z2ui5.updateData(${$parameters>/reason})`.
    INSERT temp14 INTO TABLE temp13.
    temp14-n = `id`.
    temp14-v = `p13nPopup`.
    INSERT temp14 INTO TABLE temp13.
    DATA temp1 TYPE z2ui5_if_types=>ty_t_name_value.
    CLEAR temp1.
    DATA temp2 LIKE LINE OF temp1.
    temp2-n = `id`.
    temp2-v = `columnsPanel`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `title`.
    temp2-v = `Columns`.
    INSERT temp2 INTO TABLE temp1.
    DATA temp3 TYPE z2ui5_if_types=>ty_t_name_value.
    CLEAR temp3.
    DATA temp4 LIKE LINE OF temp3.
    temp4-n = `id`.
    temp4-v = `sortPanel`.
    INSERT temp4 INTO TABLE temp3.
    temp4-n = `title`.
    temp4-v = `Sort`.
    INSERT temp4 INTO TABLE temp3.
    DATA temp5 TYPE z2ui5_if_types=>ty_t_name_value.
    CLEAR temp5.
    DATA temp6 LIKE LINE OF temp5.
    temp6-n = `id`.
    temp6-v = `filterPanel`.
    INSERT temp6 INTO TABLE temp5.
    temp6-n = `title`.
    temp6-v = `Filter`.
    INSERT temp6 INTO TABLE temp5.
    DATA temp7 TYPE z2ui5_if_types=>ty_t_name_value.
    CLEAR temp7.
    DATA temp8 LIKE LINE OF temp7.
    temp8-n = `id`.
    temp8-v = `groupPanel`.
    INSERT temp8 INTO TABLE temp7.
    temp8-n = `title`.
    temp8-v = `Group`.
    INSERT temp8 INTO TABLE temp7.
    page->_generic( name = `Popup` ns = `p13n`
                          t_prop = temp13
                         )->_generic( name = `panels` ns = `p13n`
                           )->_generic( name = `SelectionPanel` ns = `p13n`
                                        t_prop = temp1 )->get_parent(
                          )->_generic( name = `SortPanel` ns = `p13n`
                                       t_prop = temp3
                                                    )->get_parent(
                          )->_generic( name = `P13nFilterPanel` ns = ``
                                       t_prop = temp5
                                                    )->get_parent(
                         )->_generic( name = `GroupPanel` ns = `p13n`
                                      t_prop = temp7
                                      )->get_parent(  )->get_parent( )->get_parent(

                                    )->get_parent( )->get_parent( ).

    page->button( text = `Open P13N Dialog` press = client->_event( 'P13N_OPEN' ) class = `sapUiTinyMarginBeginEnd`
    )->button( text = `Open P13N.POPUP` press = `sap.z2ui5.setInitialData()` )->get_parent( )->get_parent( ).




    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_view_p13n.

    DATA p13n_dialog TYPE REF TO z2ui5_cl_xml_view.
    p13n_dialog = z2ui5_cl_xml_view=>factory_popup( ).

    DATA temp15 TYPE z2ui5_if_types=>ty_t_name_value.
    CLEAR temp15.
    DATA temp16 LIKE LINE OF temp15.
    temp16-n = `ok`.
    temp16-v = client->_event( `OK` ).
    INSERT temp16 INTO TABLE temp15.
    temp16-n = `cancel`.
    temp16-v = client->_event( `CANCEL` ).
    INSERT temp16 INTO TABLE temp15.
    temp16-n = `reset`.
    temp16-v = client->_event( `RESET` ).
    INSERT temp16 INTO TABLE temp15.
    temp16-n = `showReset`.
    temp16-v = `true`.
    INSERT temp16 INTO TABLE temp15.
    temp16-n = `initialVisiblePanelType`.
    temp16-v = `sort`.
    INSERT temp16 INTO TABLE temp15.
    DATA temp3 TYPE z2ui5_if_types=>ty_t_name_value.
    CLEAR temp3.
    DATA temp4 LIKE LINE OF temp3.
    temp4-n = `items`.
    temp4-v = `{path:'` && client->_bind_edit( val = mt_columns path = abap_true custom_mapper = z2ui5_cl_ajson_mapping=>create_lower_case( ) ) && `'}`.
    INSERT temp4 INTO TABLE temp3.
    temp4-n = `columnsItems`.
    temp4-v = `{path:'` && client->_bind_edit( val = mt_columns1 path = abap_true custom_mapper = z2ui5_cl_ajson_mapping=>create_lower_case( ) ) && `'}`.
    INSERT temp4 INTO TABLE temp3.
    DATA temp5 TYPE z2ui5_if_types=>ty_t_name_value.
    CLEAR temp5.
    DATA temp6 LIKE LINE OF temp5.
    temp6-n = `columnKey`.
    temp6-v = `{columnkey}`.
    INSERT temp6 INTO TABLE temp5.
    temp6-n = `text`.
    temp6-v = `{text}`.
    INSERT temp6 INTO TABLE temp5.
    DATA temp7 TYPE z2ui5_if_types=>ty_t_name_value.
    CLEAR temp7.
    DATA temp8 LIKE LINE OF temp7.
    temp8-n = `columnKey`.
    temp8-v = `{columnkey}`.
    INSERT temp8 INTO TABLE temp7.
    temp8-n = `visible`.
    temp8-v = `{visible}`.
    INSERT temp8 INTO TABLE temp7.
    temp8-n = `index`.
    temp8-v = `{index}`.
    INSERT temp8 INTO TABLE temp7.
    DATA temp9 TYPE z2ui5_if_types=>ty_t_name_value.
    CLEAR temp9.
    DATA temp10 LIKE LINE OF temp9.
    temp10-n = `groupItems`.
    temp10-v = `{path:'` && client->_bind_edit( val = mt_groups path = abap_true custom_mapper = z2ui5_cl_ajson_mapping=>create_lower_case( ) ) && `'}`.
    INSERT temp10 INTO TABLE temp9.
    DATA temp1 TYPE z2ui5_if_types=>ty_t_name_value.
    CLEAR temp1.
    DATA temp2 LIKE LINE OF temp1.
    temp2-n = `columnKey`.
    temp2-v = `{columnkey}`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `text`.
    temp2-v = `{text}`.
    INSERT temp2 INTO TABLE temp1.
    DATA temp11 TYPE z2ui5_if_types=>ty_t_name_value.
    CLEAR temp11.
    DATA temp12 LIKE LINE OF temp11.
    temp12-n = `columnKey`.
    temp12-v = `{columnkey}`.
    INSERT temp12 INTO TABLE temp11.
    temp12-n = `operation`.
    temp12-v = `{operation}`.
    INSERT temp12 INTO TABLE temp11.
    temp12-n = `showIfGrouped`.
    temp12-v = `{showifgrouped}`.
    INSERT temp12 INTO TABLE temp11.
    DATA p13n TYPE REF TO z2ui5_cl_xml_view.
    p13n = p13n_dialog->_generic( name = `P13nDialog`
    t_prop = temp15
    )->_generic( name = `panels`
     )->_generic( name = `P13nColumnsPanel`
     t_prop = temp3
     )->items(
         )->_generic( name = `P13nItem`
           t_prop = temp5 )->get_parent( )->get_parent(

         )->_generic( name = `columnsItems`
           )->_generic( name = `P13nColumnsItem`
               t_prop = temp7 )->get_parent( )->get_parent( )->get_parent(

     )->_generic( name = `P13nGroupPanel`
           t_prop = temp9
     )->items(
      )->_generic( name = `P13nItem`
           t_prop = temp1 )->get_parent( )->get_parent(

      )->_generic( name = `groupItems`
        )->_generic( name = `P13nGroupItem`
            t_prop = temp11 ).

    client->popup_display( p13n->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_view_p13n_popup.



    DATA p13n_popup TYPE REF TO z2ui5_cl_xml_view.
    p13n_popup = z2ui5_cl_xml_view=>factory( ).

    DATA temp17 TYPE z2ui5_if_types=>ty_t_name_value.
    CLEAR temp17.
    DATA temp18 LIKE LINE OF temp17.
    temp18-n = `title`.
    temp18-v = `My Custom View Settings`.
    INSERT temp18 INTO TABLE temp17.
    temp18-n = `id`.
    temp18-v = `p13nPopup`.
    INSERT temp18 INTO TABLE temp17.
    DATA temp5 TYPE z2ui5_if_types=>ty_t_name_value.
    CLEAR temp5.
    DATA temp6 LIKE LINE OF temp5.
    temp6-n = `id`.
    temp6-v = `columnsPanel`.
    INSERT temp6 INTO TABLE temp5.
    temp6-n = `title`.
    temp6-v = `Columns`.
    INSERT temp6 INTO TABLE temp5.
    DATA temp7 TYPE z2ui5_if_types=>ty_t_name_value.
    CLEAR temp7.
    DATA temp8 LIKE LINE OF temp7.
    temp8-n = `id`.
    temp8-v = `sortPanel`.
    INSERT temp8 INTO TABLE temp7.
    temp8-n = `title`.
    temp8-v = `Sort`.
    INSERT temp8 INTO TABLE temp7.
    DATA temp9 TYPE z2ui5_if_types=>ty_t_name_value.
    CLEAR temp9.
    DATA temp10 LIKE LINE OF temp9.
    temp10-n = `id`.
    temp10-v = `groupPanel`.
    INSERT temp10 INTO TABLE temp9.
    temp10-n = `title`.
    temp10-v = `Group`.
    INSERT temp10 INTO TABLE temp9.
    p13n_popup->_generic( name = `Popup` ns = `p13n`
                              t_prop = temp17
                             )->_generic( name = `panels` ns = `p13n`
                               )->_generic( name = `SelectionPanel` ns = `p13n`
                                            t_prop = temp5 )->get_parent(
                              )->_generic( name = `SortPanel` ns = `p13n`
                                           t_prop = temp7
                                                        )->get_parent(
                             )->_generic( name = `GroupPanel` ns = `p13n`
                                          t_prop = temp9
                                          )->get_parent(  )->get_parent( )->get_parent(
                                        ).

    client->view_display( p13n_popup->stringify( ) ).

  ENDMETHOD.
ENDCLASS.

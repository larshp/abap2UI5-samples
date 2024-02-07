*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


CLASS lcl_demo_app_125 DEFINITION
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA mo_parent_view   TYPE REF TO z2ui5_cl_xml_view.

    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_value,
             val_1  TYPE string,
             val_2  TYPE string,
             val_3  TYPE string,
             val_4  TYPE string,
             val_5  TYPE string,
             val_6  TYPE string,
             val_7  TYPE string,
             val_8  TYPE string,
             val_9  TYPE string,
             val_10 TYPE string,
           END OF ty_s_value.

    TYPES:
      BEGIN OF ty_s_dfies,
        rollname  TYPE string,
        scrtext_s TYPE string,
        fieldname TYPE string,
        keyflag   TYPE string,
        scrtext_m TYPE string,
      END OF ty_s_dfies.
    DATA mv_search_value  TYPE string.
    DATA mt_table         TYPE REF TO data.
    DATA mt_comp          TYPE abap_component_tab.
    DATA mt_table_del     TYPE REF TO data.
    DATA ms_value         TYPE ty_s_value.
    DATA mv_table         TYPE string VALUE `USR01`.
    TYPES temp1_81391d1d57 TYPE STANDARD TABLE OF ty_s_dfies.
DATA mt_dfies         TYPE temp1_81391d1d57.
    DATA mv_activ_row     TYPE string.
    DATA mv_edit          TYPE abap_bool.

    METHODS get_xml
      RETURNING VALUE(result) TYPE REF TO z2ui5_cl_xml_view.
    METHODS set_xml
      IMPORTING
        !xml TYPE REF TO z2ui5_cl_xml_view.
    METHODS set_table
      IMPORTING
        !table TYPE string.

  PROTECTED SECTION.

    DATA client            TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS on_init.
    METHODS on_event.
    METHODS search.
    METHODS render_popup.
    METHODS get_data.
    METHODS set_row_id.
    METHODS popup_add_add.
    METHODS row_action_delete.
    METHODS get_dfies.
    METHODS row_action_edit.
    METHODS render_main.

  PRIVATE SECTION.

    METHODS data_to_table
      CHANGING
        row TYPE any.

    METHODS popup_add_edit.

    METHODS button_save.

    METHODS hlp_get_uuid
      RETURNING
        VALUE(result) TYPE string.

ENDCLASS.

CLASS lcl_demo_app_125 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      on_init( ).

    ENDIF.

    on_event( ).

    render_main( ).

  ENDMETHOD.


  METHOD on_event.


    CASE client->get( )-event.

      WHEN 'BACK'.

        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN 'BUTTON_REFRESH'.

        get_data( ).
        client->view_model_update( ).

      WHEN 'BUTTON_SEARCH'.

        get_data( ).
        search( ).
        client->view_model_update( ).

      WHEN 'BUTTON_SAVE'.

        button_save( ).

      WHEN 'BUTTON_ADD'.

        mv_edit = abap_false.

        render_popup(  ).

        client->view_model_update( ).

      WHEN 'POPUP_ADD_ADD'.

        popup_add_add( ).

      WHEN 'POPUP_ADD_EDIT'.

        popup_add_edit( ).

      WHEN 'POPUP_INPUT_SCREEN'.

        if mv_edit = abap_false.
        return.
        endif.

      WHEN 'POPUP_ADD_CLOSE'.

        client->popup_destroy( ).


      WHEN 'ROW_ACTION_DELETE'.

        row_action_delete( ).

      WHEN 'ROW_ACTION_EDIT'.

        row_action_edit( ).

    ENDCASE.

  ENDMETHOD.


  METHOD button_save.

*    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
*    ASSIGN mt_table->* TO <tab>.
*    FIELD-SYMBOLS <del> TYPE STANDARD TABLE.
*    ASSIGN mt_table_del->* TO <del>.
*
*
*    TRY.
*
*        DATA(type_desc) = cl_abap_typedescr=>describe_by_name( mv_table ).
*        DATA(struct_desc) = CAST cl_abap_structdescr( type_desc ).
*
*        DATA(table_desc) = cl_abap_tabledescr=>create(
*          p_line_type  = struct_desc
*          p_table_kind = cl_abap_tabledescr=>tablekind_std ).
*
*        DATA: o_table TYPE REF TO data.
*        CREATE DATA o_table TYPE HANDLE table_desc.
*
*        FIELD-SYMBOLS <table> TYPE ANY TABLE.
*        ASSIGN o_table->* TO <table>.
*
*        MOVE-CORRESPONDING <del> TO <table>.
*
*        IF <del> IS NOT INITIAL.
*
*          DELETE (mv_table) FROM TABLE <table>.
*          IF sy-subrc = 0.
*            COMMIT WORK AND WAIT.
*            CLEAR: mt_table_del.
*          ENDIF.
*        ENDIF.
*
*        MOVE-CORRESPONDING <tab> TO <table>.
*
*        MODIFY (mv_table) FROM TABLE <table>.
*        IF sy-subrc = 0.
*          COMMIT WORK AND WAIT.
*
*          client->message_toast_display( `message toast message` ).
*        ENDIF.
*
*        client->view_model_update( ).
*
*      CATCH cx_root.
*    ENDTRY.

  ENDMETHOD.


  METHOD popup_add_edit.

*    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
*    ASSIGN mt_table->* TO <tab>.
*
*    READ TABLE <tab> ASSIGNING FIELD-SYMBOL(<row>) INDEX mv_activ_row.
*
*    data_to_table( CHANGING row = <row> ).

  ENDMETHOD.


  METHOD data_to_table.

*    DATA index TYPE int4.
*
*    LOOP AT mt_dfies INTO DATA(dfies).
*
*      ASSIGN COMPONENT dfies-fieldname OF STRUCTURE row TO FIELD-SYMBOL(<value>).
*
*      index = index + 1.
*
*      DATA(val) = 'MS_VALUE-VAL_' && index.
*
*      ASSIGN (val) TO FIELD-SYMBOL(<val>).
*
*      IF <val> IS ASSIGNED AND <value> IS ASSIGNED.
*        <value> = <val>.
*      ENDIF.
*
*    ENDLOOP.
*
*    CLEAR: ms_value.
*
*    set_row_id( ).
*    client->popup_destroy( ).
*    client->view_model_update( ).

  ENDMETHOD.


  METHOD row_action_edit.

*    mv_edit = abap_true.
*
*    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
*    ASSIGN mt_table->* TO <tab>.
*
*    DATA(lt_arg) = client->get( )-t_event_arg.
*    READ TABLE lt_arg INTO DATA(ls_arg) INDEX 1.
*    IF sy-subrc = 0.
*
*      READ TABLE <tab> ASSIGNING FIELD-SYMBOL(<row>) INDEX ls_arg.
*      IF sy-subrc = 0.
*
*        mv_activ_row = ls_arg.
*
*        LOOP AT mt_dfies INTO DATA(dfies).
*
*          ASSIGN COMPONENT dfies-fieldname OF STRUCTURE <row> TO FIELD-SYMBOL(<value>).
*
*          DATA(val) = 'MS_VALUE-VAL_' && sy-tabix.
*
*          ASSIGN (val) TO FIELD-SYMBOL(<val>).
*
*          IF <val> IS ASSIGNED AND <value> IS ASSIGNED.
*            <val> = <value>.
*          ENDIF.
*
*        ENDLOOP.
*
*        render_popup(  ).
*
*        client->view_model_update( ).
*
*      ENDIF.
*    ENDIF.

  ENDMETHOD.


  METHOD row_action_delete.

    DATA index TYPE int4.

    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
    ASSIGN mt_table->* TO <tab>.

    FIELD-SYMBOLS <del> TYPE STANDARD TABLE.
    ASSIGN mt_table_del->* TO <del>.

    DATA t_arg TYPE string_table.
    t_arg = client->get( )-t_event_arg.
    DATA ls_arg TYPE string.
    READ TABLE t_arg INTO ls_arg INDEX 1.
    IF sy-subrc = 0.

      FIELD-SYMBOLS <line> LIKE LINE OF <tab>.
      LOOP AT <tab> ASSIGNING <line>.

        index = index + 1.

        CHECK index = ls_arg.

        APPEND <line> TO <del>.
        DELETE <tab>.

      ENDLOOP.

      set_row_id(  ).
      client->view_model_update( ).

    ENDIF.

  ENDMETHOD.


  METHOD popup_add_add.

*    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
*    ASSIGN mt_table->* TO <tab>.
*
*    APPEND INITIAL LINE TO <tab> ASSIGNING FIELD-SYMBOL(<row>).
*
*    data_to_table( CHANGING row = <row> ).


  ENDMETHOD.


  METHOD on_init.

    get_data(  ).

    get_dfies( ).

    set_row_id(  ).


  ENDMETHOD.


  METHOD render_main.

    IF mo_parent_view IS INITIAL.

      DATA view TYPE REF TO z2ui5_cl_xml_view.
      view = z2ui5_cl_xml_view=>factory( )->shell( ).


      DATA page TYPE REF TO z2ui5_cl_xml_view.
      DATA temp3 TYPE xsdboolean.
      temp3 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
      page = view->page( title          =  mv_table
                               navbuttonpress = client->_event( 'BACK' )
                               shownavbutton = temp3
                               class          = 'sapUiContentPadding' ).

    ELSE.

      page = mo_parent_view->get( `Page` ).

    ENDIF.

    page->header_content( )->scroll_container( height = '70%' vertical = abap_true ).

    FIELD-SYMBOLS <tab> TYPE any.
    ASSIGN mt_table->* TO <tab>.

    DATA columns TYPE REF TO z2ui5_cl_xml_view.
    columns = page->table(
                   growing    ='true'
                   width      ='auto'
                   items      = client->_bind( val = <tab> )
                   headertext = mv_table
                )->header_toolbar(
                )->overflow_toolbar(
                )->title(   level ='H1'
                            text = mv_table
                )->toolbar_spacer(
                )->search_field(
                                 value  = client->_bind_edit( mv_search_value )
                                 search = client->_event( 'BUTTON_SEARCH' )
                                 change = client->_event( 'BUTTON_SEARCH' )
                                 id     = `SEARCH`
                                 width  = '17.5rem'
                )->get_parent( )->get_parent(
                )->columns( ).


    DATA temp2 LIKE LINE OF mt_comp.
    DATA comp LIKE REF TO temp2.
    LOOP AT mt_comp REFERENCE INTO comp.

      CHECK comp->name <> `MANDT`.



      DATA dfies TYPE ty_s_dfies.
      READ TABLE mt_dfies INTO dfies WITH KEY fieldname = comp->name.

      DATA width TYPE c LENGTH 4.
      DATA temp1 LIKE width.
      IF comp->name = 'ROW_ID'.
        temp1 = '2rem'.
      ELSE.
        temp1 = ''.
      ENDIF.
      width = temp1.

      columns->column( width = width )->text( dfies-scrtext_s ).

    ENDLOOP.


    DATA temp4 TYPE string_table.
    CLEAR temp4.
    INSERT `${ROW_ID}` INTO TABLE temp4.
    DATA cells TYPE REF TO z2ui5_cl_xml_view.
    cells = columns->get_parent( )->items(
                                       )->column_list_item( valign = 'Middle'
                                                            type ='Navigation'
                                                            press = client->_event( val = 'ROW_ACTION_EDIT'
                                                                            t_arg = temp4 )
                                       )->cells( ).

    LOOP AT mt_comp REFERENCE INTO comp.


      CHECK comp->name <> `MANDT`.

      READ TABLE mt_dfies INTO dfies WITH KEY fieldname = comp->name.

      DATA temp6 TYPE string.
      IF dfies-keyflag = abap_false.
        temp6 = '{' && comp->name && '}'.
      ELSE.
        temp6 = ''.
      ENDIF.
      DATA text LIKE temp6.
      text = temp6.
      DATA temp7 TYPE string.
      IF dfies-keyflag = abap_true.
        temp7 = '{' && comp->name && '}'.
      ELSE.
        temp7 = ''.
      ENDIF.
      DATA title LIKE temp7.
      title = temp7.


      cells->object_identifier( text  = text
                                title = title ).


    ENDLOOP.

    page->footer( )->overflow_toolbar(
                    )->toolbar_spacer(
                    )->button(
                        icon    = 'sap-icon://add'
                        text    =   'RSLPO_GUI_ADDPART'
                        press   = client->_event( 'BUTTON_ADD' )
                        type    = 'Default'
                     )->button(
                        icon    = 'sap-icon://refresh'
                        text    = '/SCMB/LOC_REFRESH'
                        press   = client->_event( 'BUTTON_REFRESH' )
                        type    = 'Default'
                     )->button(
                        text    = '/SCWM/DE_LM_LOGSAVE'
                        press   = client->_event( 'BUTTON_SAVE' )
                        type    = 'Success' ).

    IF mo_parent_view IS INITIAL.

      client->view_display( view->stringify( ) ).

    ENDIF.

  ENDMETHOD.

  METHOD hlp_get_uuid.

    DATA uuid TYPE sysuuid_c32.

    TRY.

        CALL METHOD ('CL_SYSTEM_UUID')=>create_uuid_c32_static
          RECEIVING
            uuid = uuid.

      CATCH cx_sy_dyn_call_illegal_class.

        DATA lv_fm TYPE c LENGTH 11.
        lv_fm = 'GUID_CREATE'.

        CALL FUNCTION lv_fm
          IMPORTING
            ev_guid_32 = uuid.

    ENDTRY.

    result = uuid.

  ENDMETHOD.

  METHOD search.


    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
    ASSIGN mt_table->* TO <tab>.


    IF mv_search_value IS NOT INITIAL.

      FIELD-SYMBOLS <f_row> LIKE LINE OF <tab>.
      LOOP AT <tab> ASSIGNING <f_row>.
        DATA lv_row TYPE string.
        lv_row = ``.
        DATA lv_index TYPE i.
        lv_index = 1.
        DO.
          FIELD-SYMBOLS <field> TYPE any.
          ASSIGN COMPONENT lv_index OF STRUCTURE <f_row> TO <field>.
          IF sy-subrc <> 0.
            EXIT.
          ENDIF.
          lv_row = lv_row && <field>.
          lv_index = lv_index + 1.
        ENDDO.

        IF lv_row NS mv_search_value.
          DELETE <tab>.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD get_data.

    DATA lo_struct          TYPE REF TO cl_abap_structdescr.
    DATA lo_tab             TYPE REF TO cl_abap_tabledescr.
    DATA selkz              TYPE boolean.
    DATA index              TYPE i.
    FIELD-SYMBOLS: <fs_tab> TYPE ANY TABLE.

    DATA o_type_desc TYPE REF TO cl_abap_typedescr.
    o_type_desc = cl_abap_typedescr=>describe_by_name( mv_table ).
    DATA temp8 TYPE REF TO cl_abap_structdescr.
    temp8 ?= o_type_desc.
    DATA o_struct_desc LIKE temp8.
    o_struct_desc = temp8.
    DATA comp TYPE abap_component_tab.
    comp = o_struct_desc->get_components( ).

    TRY.

        DATA temp9 TYPE cl_abap_structdescr=>component_table.
        CLEAR temp9.
        DATA temp10 LIKE LINE OF temp9.
        temp10-name = 'ROW_ID'.
        DATA temp2 TYPE REF TO cl_abap_datadescr.
        temp2 ?= cl_abap_datadescr=>describe_by_data( index ).
        temp10-type = temp2.
        INSERT temp10 INTO TABLE temp9.
        mt_comp = temp9.

        APPEND LINES OF comp TO mt_comp.

        DATA new_struct_desc TYPE REF TO cl_abap_structdescr.
        new_struct_desc = cl_abap_structdescr=>create( mt_comp ).

        DATA new_table_desc TYPE REF TO cl_abap_tabledescr.
        new_table_desc = cl_abap_tabledescr=>create(
          p_line_type  = new_struct_desc
          p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        DATA: o_table TYPE REF TO data.
        CREATE DATA o_table TYPE HANDLE new_table_desc.

        FIELD-SYMBOLS <table> TYPE ANY TABLE.
        ASSIGN o_table->* TO <table>.

        SELECT * FROM (mv_table) INTO CORRESPONDING FIELDS OF TABLE <table>.


        lo_tab ?= cl_abap_tabledescr=>describe_by_data( <table> ).
        CREATE DATA mt_table TYPE HANDLE lo_tab.
        ASSIGN mt_table->* TO <fs_tab>.
        <fs_tab> = <table>.


      CATCH cx_root.

    ENDTRY.

    set_row_id( ).


  ENDMETHOD.

  METHOD get_dfies.

*    DATA dfies TYPE STANDARD TABLE OF dfies.
*
*    " alle Texte zu der Tabelle lesen
*    CALL FUNCTION 'DDIF_FIELDINFO_GET'
*      EXPORTING
*        tabname        = CONV ddobjname( mv_table )
*        langu          = sy-langu
*      TABLES
*        dfies_tab      = mt_DFIES
*      EXCEPTIONS
*        not_found      = 1
*        internal_error = 2
*        OTHERS         = 3.
*    IF sy-subrc <> 0.
*    ENDIF.
*
*    " Notfall - Englishtexte dazulesen
*    CALL FUNCTION 'DDIF_FIELDINFO_GET'
*      EXPORTING
*        tabname        = CONV ddobjname( mv_table )
*        langu          = 'E'
*      TABLES
*        dfies_tab      = dfies
*      EXCEPTIONS
*        not_found      = 1
*        internal_error = 2
*        OTHERS         = 3.
*    IF sy-subrc <> 0.
*    ENDIF.


*    DATA: lcl_abap_structdescr TYPE REF TO cl_abap_structdescr.
*          lt_ddic_info         TYPE ddfields.

*    FIELD-SYMBOLS: <ddic_info> TYPE LINE OF ddfields.

*    lcl_abap_structdescr ?= cl_abap_structdescr=>describe_by_name(  mv_table ).

*    data(lt_ddic_info) = lcl_abap_structdescr->get_ddic_field_list( ).



*    LOOP AT mt_dfies REFERENCE INTO DATA(d).
*
*      READ TABLE lt_ddic_info REFERENCE INTO DATA(f) WITH KEY rollname = d->rollname.
*
*      IF d->scrtext_s IS INITIAL.
*        d->scrtext_s = f->scrtext_s.
*      ENDIF.
*      IF d->scrtext_m IS INITIAL.
*        d->scrtext_m = f->scrtext_m.
*      ENDIF.
*      IF d->scrtext_l IS INITIAL.
*        d->scrtext_l = f->scrtext_l.
*      ENDIF.
*      IF d->reptext IS INITIAL.
*        d->reptext   = f->reptext.
*      ENDIF.
*
*    ENDLOOP.

  ENDMETHOD.


  METHOD set_row_id.


    FIELD-SYMBOLS <line> TYPE any.
    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
    ASSIGN mt_table->* TO <tab>.

    LOOP AT <tab> ASSIGNING <line>.

      FIELD-SYMBOLS <row> TYPE any.
      ASSIGN COMPONENT 'ROW_ID' OF STRUCTURE <line> TO <row>.
      IF <row> IS ASSIGNED.
        <row> = sy-tabix.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD render_popup.

    DATA index TYPE int4.

    DATA popup TYPE REF TO z2ui5_cl_xml_view.
    popup = z2ui5_cl_xml_view=>factory_popup( ).

    DATA title TYPE c LENGTH 14.
    DATA temp3 LIKE title.
    IF mv_edit = abap_true.
      temp3 = 'CRMST_UIU_EDIT'.
    ELSE.
      temp3 = 'RSLPO_GUI_ADDPART'.
    ENDIF.
    title = temp3.

    DATA simple_form TYPE REF TO z2ui5_cl_xml_view.
    simple_form =  popup->dialog( title = title contentwidth = '40%'
          )->simple_form(
          title     = ''
          layout    = 'ResponsiveGridLayout'
          editable  = abap_true
          )->content( ns = 'form'
          ).

    " Gehe über alle Comps wenn wir im Edit sind dann sind keyfelder nicht eingabebereit.
    DATA temp12 LIKE LINE OF mt_comp.
    DATA comp LIKE REF TO temp12.
    LOOP AT mt_comp REFERENCE INTO comp.

      DATA dfies TYPE ty_s_dfies.
      READ TABLE mt_dfies INTO dfies WITH KEY fieldname = comp->name.
      IF sy-subrc <> 0.
        dfies-scrtext_m = comp->name.
      ENDIF.

      CASE comp->name.
        WHEN 'SELKZ' OR 'ROW_ID'.

        WHEN OTHERS.

          index = index + 1.

*          DATA(enabled) = COND #( WHEN dfies-keyflag = abap_true AND mv_edit = abap_true THEN abap_false ELSE abap_true ).
          DATA enabled TYPE abap_bool.
          DATA temp4 TYPE xsdboolean.
          temp4 = boolc( dfies-keyflag = abap_false or mv_edit = abap_false ).
          enabled = temp4. " THEN abap_false ELSE abap_true ).
*          DATA(visible) = COND #( WHEN dfies-fieldname = 'MANDT' THEN abap_false ELSE abap_true ).
          DATA visible TYPE abap_bool.
          DATA temp5 TYPE xsdboolean.
          temp5 = boolc( dfies-fieldname <> 'MANDT' ).
          visible = temp5. "  THEN abap_false ELSE abap_true ).

          FIELD-SYMBOLS <val> TYPE any.
          ASSIGN COMPONENT index OF STRUCTURE ms_value TO <val>.

          CHECK sy-subrc = 0.

          simple_form->label( text = dfies-scrtext_m
         )->input(
              value            = client->_bind_edit( <val> )
              showvaluehelp    = abap_false
              enabled          = enabled
              visible          = visible ).

      ENDCASE.

      CLEAR: dfies.

    ENDLOOP.

    DATA temp13 TYPE string.
    IF mv_edit = abap_true.
      temp13 = `POPUP_ADD_EDIT`.
    ELSE.
      temp13 = `POPUP_ADD_ADD`.
    ENDIF.
    DATA event LIKE temp13.
    event = temp13.


    DATA toolbar TYPE REF TO z2ui5_cl_xml_view.
    toolbar = simple_form->get_root( )->get_child(
         )->footer(
         )->overflow_toolbar( ).
    toolbar->toolbar_spacer(
     ).

    toolbar->button(
      text  = 'BRF_TERMINATE_PS'
      press = client->_event( 'POPUP_ADD_CLOSE' )
    ).

    IF mv_edit = abap_true.
      DATA temp14 TYPE string_table.
      CLEAR temp14.
      INSERT mv_activ_row INTO TABLE temp14.
      toolbar->button(
        text  =  'MLCCS_D_XDELETE'
        type  = 'Reject'
        icon  = 'sap-icon://delete'
        press = client->_event( val = 'ROW_ACTION_DELETE' t_arg = temp14 ) ).
    ENDIF.

    toolbar->button(
      text  = 'FB_TEXT_PROC_STATUS_SUCCSS_ALV'
      press = client->_event( event )
      type  = 'Emphasized'
*     enabled = `{= $` && client->_bind_edit( mv_screen_name ) && ` !== '' && $` && client->_bind_edit( mv_screen_descr ) && ` !== '' }`
    ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD get_xml.

    result = mo_parent_view.

  ENDMETHOD.

  METHOD set_xml.

    mo_parent_view = xml.

  ENDMETHOD.

  METHOD set_table.

    mv_table = table.

  ENDMETHOD.

ENDCLASS.


CLASS lcl_demo_app_126 DEFINITION
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_selectedkey     TYPE string.
    DATA mv_selectedkey_tmp TYPE string.
    DATA mo_app_simple_view TYPE REF TO lcl_demo_app_125.
    DATA mo_app_test        TYPE REF TO z2ui5_cl_demo_app_130 .


  PROTECTED SECTION.

    DATA client            TYPE REF TO z2ui5_if_client .
    DATA check_initialized TYPE abap_bool .
    DATA mo_main_page      TYPE REF TO z2ui5_cl_xml_view.

    METHODS on_init.
    METHODS on_event.
    METHODS render_main.

    METHODS get_count
      IMPORTING
        !tabname      TYPE string
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.

ENDCLASS.



CLASS lcl_demo_app_126 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.



    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      on_init( ).

      CREATE OBJECT mo_app_simple_view.


    ENDIF.


    on_event( ).


    CASE mv_selectedkey.

      WHEN space.

        render_main( ).

      WHEN 'TEST'.

        IF mv_selectedkey <> mv_selectedkey_tmp.

          CREATE OBJECT mo_app_test TYPE z2ui5_cl_demo_app_130.

        ENDIF.

        render_main( ).

        mo_app_test->mo_parent_view = mo_main_page.

        mo_app_test->z2ui5_if_app~main( client = me->client ).

        mv_selectedkey_tmp = mv_selectedkey.



      WHEN OTHERS.

        IF mv_selectedkey <> mv_selectedkey_tmp.

          CREATE OBJECT mo_app_simple_view.

        ENDIF.

        mo_app_simple_view->set_table( table = mv_selectedkey ).

        render_main( ).

        mo_app_simple_view->mo_parent_view = mo_main_page.

        mo_app_simple_view->z2ui5_if_app~main( client = me->client ).

        mv_selectedkey_tmp = mv_selectedkey.

    ENDCASE.

    client->view_display( mo_main_page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'ONSELECTICONTABBAR'.

        CASE mv_selectedkey.

          WHEN space.


          WHEN OTHERS.

        ENDCASE.

      WHEN 'BACK'.
*        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.

  METHOD on_init.

  ENDMETHOD.

  METHOD render_main.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( )->shell( ).

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp6 TYPE xsdboolean.
    temp6 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = view->page( id             = `page_main`
                             title          = 'Customizing'
                             navbuttonpress = client->_event( 'BACK' )
                             shownavbutton = temp6
                             class          = 'sapUiContentPadding' ).



    DATA lo_items TYPE REF TO z2ui5_cl_xml_view.
    lo_items = page->icon_tab_bar( class       = 'sapUiResponsiveContentPadding'
                                         selectedkey = client->_bind_edit( mv_selectedkey )
                                         select      = client->_event( val = 'ONSELECTICONTABBAR' )
                                                       )->items( ).



    lo_items->icon_tab_filter( icon      = 'sap-icon://along-stacked-chart'
                               iconcolor = 'Default'
                               count     = get_count( 'USR01' )
                               text      = 'User 01'
                               key       = 'USR01' ).

    lo_items->icon_tab_filter( icon      = 'sap-icon://popup-window'
                               iconcolor = 'Default'
                               count     = get_count( 'USR02' )
                               text      = 'User 02'
                               key       = 'USR02' ).

    lo_items->icon_tab_filter( icon      = 'sap-icon://filter-fields'
                               iconcolor = 'Default'
                               count     = get_count( 'USR03' )
                               text      = 'User 03'
                               key       = 'USR03' ).

    lo_items->icon_tab_filter( icon      = 'sap-icon://business-objects-mobile'
                               iconcolor = 'Default'
                               count     = get_count( 'USR04' )
                               text      = 'User 04'
                               key       = 'USR04' ).

    lo_items->icon_tab_filter( icon      = 'sap-icon://business-objects-mobile'
                               iconcolor = 'Default'
                               count     = get_count( 'USR04' )
                               text      = 'TEST'
                               key       = 'TEST' ).


    mo_main_page = lo_items.

  ENDMETHOD.

  METHOD get_count.

    DATA o_type_desc TYPE REF TO cl_abap_typedescr.
    o_type_desc = cl_abap_typedescr=>describe_by_name( tabname ).
    DATA temp16 TYPE REF TO cl_abap_structdescr.
    temp16 ?= o_type_desc.
    DATA o_struct_desc LIKE temp16.
    o_struct_desc = temp16.

    DATA new_table_desc TYPE REF TO cl_abap_tabledescr.
    new_table_desc = cl_abap_tabledescr=>create(
      p_line_type  = o_struct_desc
      p_table_kind = cl_abap_tabledescr=>tablekind_std ).

    DATA: o_table TYPE REF TO data.
    CREATE DATA o_table TYPE HANDLE new_table_desc.

    FIELD-SYMBOLS <table> TYPE ANY TABLE.
    ASSIGN o_table->* TO <table>.

    SELECT * FROM (tabname) INTO CORRESPONDING FIELDS OF TABLE <table>.

    result = lines( <table> ).

  ENDMETHOD.

ENDCLASS.

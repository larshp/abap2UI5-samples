CLASS Z2UI5_CL_DEMO_APP_063 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    DATA check_initialized TYPE abap_bool.
    DATA client TYPE REF TO Z2UI5_if_client.

    DATA:
      BEGIN OF ms_popup_input,
        name TYPE string,
        user TYPE string,
      END OF ms_popup_input.

    DATA:
      BEGIN OF ms_popup_start,
        name TYPE string,
        user TYPE string,
      END OF ms_popup_start.

    TYPES:
      BEGIN OF ty_s_game,
        selkz TYPE abap_bool,
        game  TYPE string,
      END OF ty_S_game.

    DATA mt_data TYPE STANDARD TABLE OF ty_S_game WITH DEFAULT KEY.

    METHODS popup_display.
    METHODS popup_display_start.

  PROTECTED SECTION.

    METHODS Z2UI5_on_rendering
      IMPORTING
        client TYPE REF TO Z2UI5_if_client.
    METHODS Z2UI5_on_event
      IMPORTING
        client TYPE REF TO Z2UI5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_063 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

    ENDIF.

    IF client->get( )-check_on_navigated = abap_true.
      Z2UI5_on_rendering( client ).
    ENDIF.

    Z2UI5_on_event( client ).

    SELECT * FROM Z2UI5_t_demo_01

        WHERE name = 'TEST02'
        INTO CORRESPONDING FIELDS OF TABLE mt_data.

  ENDMETHOD.


  METHOD Z2UI5_on_event.

    CASE client->get( )-event.

      WHEN 'BUTTON_CANCEL'.
        client->popup_destroy( ).

      WHEN 'BUTTON_CONFIRM'.
        client->popup_destroy( ).

        DATA game TYPE REF TO Z2UI5_CL_DEMO_APP_064.
        CREATE OBJECT game TYPE Z2UI5_CL_DEMO_APP_064.
        game->mv_user = ms_popup_input-user.
        game->mv_game = ms_popup_input-name.
        client->nav_app_call( game ).
*        MODIFY Z2UI5_t_demo_01 FROM @( VALUE #(
*           name = 'TEST02' game = ms_popup_input-name uuid = cast Z2UI5_if_app( game )->id ) ).
*        COMMIT WORK.


      WHEN 'BUTTON_ADD'.
        popup_display( ).

      WHEN 'BUTTON_DELETE'.
        DATA lt_entry LIKE mt_data.
        lt_entry = mt_data.
        DELETE lt_entry WHERE selkz = abap_false.

        DATA ls_entry LIKE LINE OF lt_entry.
        LOOP AT lt_entry INTO ls_entry.
          DELETE FROM Z2UI5_t_demo_01 WHERE
              game = ls_entry-game.
        ENDLOOP.
        COMMIT WORK AND WAIT.

      WHEN 'JOIN'.
        DATA lt_arg TYPE string_table.
        lt_arg = client->get( )-t_event_arg.
        DATA temp1 LIKE LINE OF lt_arg.
        DATA temp2 LIKE sy-tabix.
        temp2 = sy-tabix.
        READ TABLE lt_arg INDEX 1 INTO temp1.
        sy-tabix = temp2.
        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE cx_sy_itab_line_not_found.
        ENDIF.
        ms_popup_start-name = temp1.
        popup_display_start( ).
        client->popup_destroy( ).

      WHEN 'BUTTON_START'.
        client->popup_destroy( ).

        DATA ls_data TYPE Z2UI5_t_demo_01.
        SELECT * SINGLE FROM Z2UI5_t_demo_01

        WHERE
            name = 'TEST02' AND
          game = ms_popup_start-name
        INTO ls_data.

        DATA temp3 TYPE undefined.
        temp3 ?= client->get_app( ls_data-uuid ).
        game = temp3.
        game->mv_user = ms_popup_start-user.
        client->nav_app_call( game ).
        RETURN.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_on_rendering.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Games'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true ).

    page->header_content(
             )->link( text = 'Demo'    target = '_blank'    href = `https://twitter.com/abap2UI5/status/1628701535222865922`
             )->link( text = 'Source_Code'  target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
         )->get_parent( ).

    DATA grid TYPE REF TO z2ui5_cl_xml_view.
    grid = page->grid( 'L6 M12 S12'
        )->content( 'layout' ).

    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    tab = grid->table(
            items = client->_bind_edit( mt_data )
            mode  = 'MultiSelect'
        )->header_toolbar(
            )->overflow_toolbar(
                )->title( 'Active Games:'
                )->toolbar_spacer(
                )->button(
                    icon  = 'sap-icon://delete'
                    text  = 'Delete'
                    press = client->_event( 'BUTTON_DELETE' )
                )->button(
                    icon  = 'sap-icon://add'
                    text  = 'New'
                    press = client->_event( 'BUTTON_ADD' )
        )->get_parent( )->get_parent( ).

    tab->columns(
        )->column(
            )->text( 'Name' )->get_parent(
          )->column(
            )->text( 'UUID' )->get_parent(
             )->column(
            )->text( 'Action' )->get_parent(
     ).

    DATA temp4 TYPE string_table.
    CLEAR temp4.
    INSERT `${GAME}` INTO TABLE temp4.
    tab->items( )->column_list_item( selected = '{SELKZ}'
      )->cells(
          )->text( text = '{GAME}'
          )->text( text = '{UUID}'
          )->button( text = 'Join' press = client->_event( val = `JOIN` t_arg = temp4  )

           ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD popup_display.

    DATA popup TYPE REF TO z2ui5_cl_xml_view.
    popup = Z2UI5_cl_xml_view=>factory_popup( )->dialog(
          contentheight = '500px'
          contentwidth  = '500px'
          title = 'Title'
          )->content(
              )->simple_form(
                  )->label( 'Name Game'
                  )->input( client->_bind_edit( ms_popup_input-name )
                  )->label( 'Name User'
                  )->input( client->_bind_edit( ms_popup_input-user )
                  )->label( 'Checkbox'
          )->get_parent( )->get_parent(
          )->footer( )->overflow_toolbar(
              )->toolbar_spacer(
              )->button(
                  text  = 'Cancel'
                  press = client->_event( 'BUTTON_CANCEL' )
              )->button(
                  text  = 'Confirm'
                  press = client->_event( 'BUTTON_CONFIRM' )
                  type  = 'Emphasized' ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD popup_display_start.

    DATA popup TYPE REF TO z2ui5_cl_xml_view.
    popup = Z2UI5_cl_xml_view=>factory_popup( )->dialog(
          contentheight = '500px'
          contentwidth  = '500px'
          title = 'Title'
          )->content(
              )->simple_form(
                  )->label( 'Name Session'
                  )->input( value = client->_bind_edit( ms_popup_start-name ) enabled = abap_false
                  )->label( 'Name User'
                  )->input( client->_bind_edit( ms_popup_start-user )
                  )->label( 'Checkbox'
          )->get_parent( )->get_parent(
          )->footer( )->overflow_toolbar(
              )->toolbar_spacer(
              )->button(
                  text  = 'Cancel'
                  press = client->_event( 'BUTTON_CANCEL' )
              )->button(
                  text  = 'Go'
                  press = client->_event( 'BUTTON_START' )
                  type  = 'Emphasized' ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.
ENDCLASS.

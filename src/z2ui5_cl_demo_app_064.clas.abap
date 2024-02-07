CLASS Z2UI5_CL_DEMO_APP_064 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    DATA mv_user TYPE string.
    DATA mv_game TYPE string.

    DATA mv_message TYPE string.
    DATA check_db_load TYPE abap_bool.

    TYPES:
      BEGIN OF ty_row,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        selected TYPE abap_bool,
        checkbox TYPE abap_bool,
      END OF ty_row.

    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH DEFAULT KEY.
    DATA client TYPE REF TO Z2UI5_if_client.

    METHODS call_newest_state
      IMPORTING
                i_client      TYPE REF TO Z2UI5_if_client
      RETURNING VALUE(result) TYPE abap_bool.

  PROTECTED SECTION.

    METHODS Z2UI5_on_rendering
      IMPORTING
        client TYPE REF TO Z2UI5_if_client.


  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_064 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    me->client = client.

    CASE client->get( )-event.

      WHEN 'REFRESH' OR 'SEND'.

        IF check_db_load = abap_true and call_newest_state( client ) IS NOT INITIAL.
            RETURN.
        ENDIF.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

    Z2UI5_on_rendering( client ).

    check_db_load = abap_true.
    DATA temp1 LIKE DATA(temp1).
    CLEAR temp1.
    temp1-uuid = client->get( )-s_draft-id.
    temp1-name = 'TEST02'.
    temp1-game = mv_game.
    DATA temp1 LIKE temp1.
    temp1 = temp1.
MODIFY Z2UI5_t_demo_01 FROM temp1.
    COMMIT WORK.

  ENDMETHOD.


  METHOD Z2UI5_on_rendering.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Game Example'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true ).

    page->header_content(
             )->link( text = 'Demo'    target = '_blank'    href = `https://twitter.com/abap2UI5/status/1628701535222865922`
             )->link( text = 'Source_Code'  target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
         )->get_parent( ).

    DATA grid TYPE REF TO z2ui5_cl_xml_view.
    grid = page->grid( 'L6 M12 S12'
        )->content( 'layout' ).


    grid->simple_form( 'Input'
        )->content( 'form'
            )->button( text = 'refresh' press = client->_event( `REFRESH` )
            )->label( 'Input with value help'
            )->input( value = client->_bind_edit( mv_message )
             )->button( text = 'send' press = client->_event( `SEND` )
            ).

    grid->list(
        headertext      = 'List Ouput'
        items           = client->_bind_edit( t_tab )
*          mode            = `SingleSelectMaster`
*          selectionchange = client->_event( 'SELCHANGE' )
        )->standard_list_item(
            title       = '{TITLE}'
            description = '{DESCR}'
*              icon        = '{ICON}'
*              info        = '{INFO}'
*              press       = client->_event( 'TEST' )
*              selected    = `{SELECTED}`
       ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD call_newest_state.

    DATA ls_data TYPE Z2UI5_t_demo_01.
    SELECT * SINGLE FROM Z2UI5_t_demo_01

          WHERE name = 'TEST02' AND
                game = mv_game
          INTO ls_data.

    IF sy-subrc = 0 AND ls_data-uuid <> client->get( )-s_draft-id.
      DATA ls_draft TYPE Z2UI5_t_fw_01.
      SELECT * SINGLE FROM Z2UI5_t_fw_01

      WHERE id = ls_data-uuid
     INTO ls_draft.

      IF sy-subrc = 0.
        DATA temp2 TYPE REF TO z2ui5_cl_demo_app_064.
        temp2 ?= i_client->get_app( ls_draft-id ).
        DATA app LIKE temp2.
        app = temp2.
        app->mv_user = mv_user.

        IF mv_message IS NOT INITIAL and client->get( )-event = 'SEND'.
          DATA temp3 TYPE ty_row.
          CLEAR temp3.
          temp3-title = mv_user.
          temp3-descr = mv_message.
          INSERT temp3 INTO TABLE app->t_tab.
        ENDIF.
        app->check_db_load = abap_false.
        i_client->nav_app_leave(  app ).
        result = abap_true.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.

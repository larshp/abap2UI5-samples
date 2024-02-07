CLASS Z2UI5_CL_DEMO_APP_062 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    DATA:
      BEGIN OF screen,
        check_is_active TYPE abap_bool,
        colour          TYPE string,
      END OF screen.

    DATA check_initialized TYPE abap_bool.
    DATA client TYPE REF TO Z2UI5_if_client.

  PROTECTED SECTION.

    METHODS Z2UI5_on_rendering
      IMPORTING
        client TYPE REF TO Z2UI5_if_client.
    METHODS Z2UI5_on_event
      IMPORTING
        client TYPE REF TO Z2UI5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_062 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      DATA ls_data TYPE Z2UI5_t_demo_01.
      SELECT * SINGLE FROM Z2UI5_t_demo_01

        WHERE name = 'TEST01'
        INTO ls_data.

      IF sy-subrc = 0.
        DATA ls_draft TYPE Z2UI5_t_fw_01.
        SELECT * SINGLE FROM Z2UI5_t_fw_01

        WHERE id = ls_data-uuid
       INTO ls_draft.

        IF sy-subrc = 0.
          client->nav_app_leave( client->get_app( ls_draft-id ) ).
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.

    Z2UI5_on_event( client ).
    Z2UI5_on_rendering( client ).

    DATA temp1 LIKE DATA(temp1).
    CLEAR temp1.
    temp1-uuid = client->get( )-s_draft-id.
    temp1-name = 'TEST01'.
    DATA temp1 LIKE temp1.
    temp1 = temp1.
MODIFY Z2UI5_t_demo_01 FROM temp1.
    COMMIT WORK.

  ENDMETHOD.


  METHOD Z2UI5_on_event.

    CASE client->get( )-event.

*      WHEN 'BUTTON_SEND'.
*        client->message_box_display( 'success - values send to the server' ).
*      WHEN 'BUTTON_CLEAR'.
*        CLEAR screen.
*        client->message_toast_display( 'View initialized' ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_on_rendering.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Start app with values Demo'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true ).

    page->header_content(
             )->link( text = 'Demo'    target = '_blank'    href = `https://twitter.com/abap2UI5/status/1628701535222865922`
             )->link( text = 'Source_Code'  target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
         )->get_parent( ).

    DATA grid TYPE REF TO z2ui5_cl_xml_view.
    grid = page->grid( 'L6 M12 S12'
        )->content( 'layout' ).

    grid->simple_form( editable = abap_true title = 'Input'
        )->content( 'form'
*            )->button( press = client->_event( `test` )
            )->label( 'Make an input here and restart the app'
            )->input(
                    value           = client->_bind_edit( screen-colour )
                    placeholder     = 'fill in your favorite colour'  ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.

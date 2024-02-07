CLASS Z2UI5_CL_DEMO_APP_060 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    TYPES temp1_4b9cee307e TYPE STANDARD TABLE OF I_CurrencyText.
DATA mt_suggestion TYPE temp1_4b9cee307e.
    DATA input TYPE string.

  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS Z2UI5_on_event.
    METHODS Z2UI5_view_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_060 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      Z2UI5_view_display( ).
    ENDIF.

    IF client->get( )-event IS NOT INITIAL.
      Z2UI5_on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD Z2UI5_on_event.

    CASE client->get( )-event.

      WHEN 'ON_SUGGEST'.

        TYPES temp3 TYPE RANGE OF string.
DATA lt_range TYPE temp3.
        DATA temp1 LIKE lt_range.
        CLEAR temp1.
        DATA temp2 LIKE LINE OF temp1.
        temp2-sign = 'I'.
        temp2-option = 'CP'.
        temp2-low = `*` && input && `*`.
        INSERT temp2 INTO TABLE temp1.
        lt_range = temp1.

        SELECT * FROM I_CurrencyText

          WHERE CurrencyName IN lt_range
          AND  Language = 'E'
          INTO CORRESPONDING FIELDS OF TABLE mt_suggestion.

       client->view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_view_display.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = z2ui5_cl_xml_view=>factory( )->shell( )->page(
       title          = 'abap2UI5 - Live Suggestion Event'
       navbuttonpress = client->_event( 'BACK' )
       shownavbutton = temp1 ).

    page->header_content(
             )->link( text = 'Demo'        target = '_blank' href = `https://twitter.com/abap2UI5/status/1675074394710765568`
             )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
         )->get_parent( ).

    DATA grid TYPE REF TO z2ui5_cl_xml_view.
    grid = page->grid( 'L6 M12 S12'
        )->content( 'layout' ).

    DATA input TYPE REF TO z2ui5_cl_xml_view.
    input = grid->simple_form( 'Input'
        )->content( 'form'
            )->label( 'Input with value help'
            )->input(
                    value           = client->_bind_edit( input )
                    suggest         = client->_event( 'ON_SUGGEST' )
                    showTableSuggestionValueHelp = abap_false
                    suggestionrows  = client->_bind( mt_suggestion )
                    showsuggestion  = abap_true
                    valueLiveUpdate = abap_true
                    autocomplete    = abap_false
                 )->get( ).

    input->suggestion_columns(
        )->Column(  )->label( text = 'Name' )->get_parent(
        )->Column(  )->label( text = 'Currency' ).

    input->suggestion_rows(
        )->column_list_item(
            )->label( text = '{CURRENCYNAME}'
            )->label( text = '{CURRENCY}' ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.

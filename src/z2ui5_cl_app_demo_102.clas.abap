class Z2UI5_CL_APP_DEMO_102 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  types:
    BEGIN OF ts_shlp_fields,
        mc_name1 TYPE  bu_mcname1,
        mc_name2 TYPE  bu_mcname2,
        bu_sort1 TYPE  bu_sort1,
        bu_sort2 TYPE  bu_sort2,
        partner  TYPE  bu_partner,
        type     TYPE  bu_type,
        valdt    TYPE  bu_valdt_s,
      END OF ts_shlp_fields .

  data MV_CHECK_INITIALIZED type ABAP_BOOL .
  data:
    BEGIN OF ms_screen,
        selfield TYPE stringval,
      END OF ms_screen .
  data MS_SHLP_FIELDS type TS_SHLP_FIELDS .
  data:
    mt_shlp_result TYPE STANDARD TABLE OF TS_SHLP_fields WITH EMPTY KEY .

  class-methods GENERATE_DDIC_SHLP
    importing
      !IR_PARENT type ref to Z2UI5_CL_XML_VIEW
      !IR_CLIENT type ref to Z2UI5_IF_CLIENT
      !IR_CONTROLLER type ref to OBJECT
      !IV_SHLP_ID type CHAR30
      !IV_RESULT_ITAB_NAME type CLIKE
      !IV_RESULT_ITAB_EVENT type CLIKE
      !IV_SHLP_FIELDS_STRUC_NAME type CLIKE .
  class-methods SELECT_DDIC_SHLP
    importing
      !IR_CONTROLLER type ref to OBJECT
      !IV_SHLP_ID type CHAR30
      !IV_RESULT_ITAB_NAME type CLIKE
      !IV_SHLP_FIELDS_STRUC_NAME type CLIKE
      !IV_MAXROWS type I default 150 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_APP_DEMO_102 IMPLEMENTATION.


  METHOD generate_ddic_shlp.
*----------------------------------------------------------------------*
* LOCAL DATA DEFINITION
*----------------------------------------------------------------------*
    DATA: ls_shlp             TYPE  shlp_descr,
          lv_grid_form_no     TYPE i,
          lt_arg              TYPE TABLE OF stringval,
          lv_arg_fieldname    TYPE stringval,
          lv_cell_fieldname   TYPE stringval,
          lv_path_result_itab TYPE stringval,
          lv_path_shlp_fields TYPE stringval.

    FIELD-SYMBOLS: <ls_fielddescr>  TYPE dfies,
                   <ls_fieldprop>   TYPE ddshfprop,
                   <lt_result_itab> TYPE ANY TABLE,
                   <ls_shlp_fields> TYPE any,
                   <lv_field>       TYPE any.

* ---------- Get result itab reference ------------------------------------------------------------
    lv_path_result_itab = 'IR_CONTROLLER->' && iv_result_itab_name.
    ASSIGN (lv_path_result_itab) TO <lt_result_itab>.

* ---------- Get searchhelp input fields structure reference --------------------------------------
    lv_path_shlp_fields = 'IR_CONTROLLER->' && iv_shlp_fields_struc_name.
    ASSIGN (lv_path_shlp_fields) TO <ls_shlp_fields>.

    IF <lt_result_itab> IS NOT ASSIGNED OR
      <ls_shlp_fields> IS NOT ASSIGNED.
      RETURN.
    ENDIF.

* -------------------------------------------------------------------------------------------------
* Searchfield Grid
* -------------------------------------------------------------------------------------------------
    DATA(lr_grid_shlp) = ir_parent->grid( 'L3 M3 S3' )->content( 'layout' ).

* ---------- Create 4 forms (grid columns) --------------------------------------------------------
    DATA(lr_form_shlp_1) = lr_grid_shlp->simple_form( )->content( 'form' ).
    DATA(lr_form_shlp_2) = lr_grid_shlp->simple_form( )->content( 'form' ).
    DATA(lr_form_shlp_3) = lr_grid_shlp->simple_form( )->content( 'form' ).
    DATA(lr_form_shlp_4) = lr_grid_shlp->simple_form( )->content( 'form' ).

* ---------- Get searchhelp description -----------------------------------------------------------
    CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
      EXPORTING
        shlpname = iv_shlp_id
      IMPORTING
        shlp     = ls_shlp.

    LOOP AT ls_shlp-fielddescr ASSIGNING <ls_fielddescr>.
* ---------- Init loop data -----------------------------------------------------------------------
      UNASSIGN: <lv_field>.

* ---------- Get field reference ------------------------------------------------------------------
      ASSIGN COMPONENT <ls_fielddescr>-fieldname OF STRUCTURE <ls_shlp_fields> TO <lv_field>.
      IF <lv_field> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

* ---------- Determine grid form number -----------------------------------------------------------
      IF lv_grid_form_no IS INITIAL.
        lv_grid_form_no = 1.
      ELSEIF lv_grid_form_no = 4.
        lv_grid_form_no = 1.
      ELSE.
        lv_grid_form_no = lv_grid_form_no + 1.
      ENDIF.

      CASE lv_grid_form_no.
        WHEN 1.
* ---------- Grid 1--------------------------------------------------------------------------------
* ---------- Set field label ----------------------------------------------------------------------
          lr_form_shlp_1->label( <ls_fielddescr>-scrtext_l ).

* ---------- Set input field ----------------------------------------------------------------------
          CASE <ls_fielddescr>-datatype.
            WHEN 'DATS'.
              lr_form_shlp_1->date_picker( value  = ir_client->_bind_edit( <lv_field> ) ).
            WHEN 'TIMS'.
              lr_form_shlp_1->time_picker( value  = ir_client->_bind_edit( <lv_field> ) ).
            WHEN OTHERS.
              lr_form_shlp_1->input( value = ir_client->_bind_edit( <lv_field> ) ).
          ENDCASE.

        WHEN 2.
* ---------- Grid 2--------------------------------------------------------------------------------
* ---------- Set field label ----------------------------------------------------------------------
          lr_form_shlp_2->label( zcl_gu=>get_data_element_labels( iv_data_element = <ls_fielddescr>-rollname ) ).

* ---------- Set input field ----------------------------------------------------------------------
          CASE <ls_fielddescr>-datatype.
            WHEN 'DATS'.
              lr_form_shlp_2->date_picker( value  = ir_client->_bind_edit( <lv_field> ) ).
            WHEN 'TIMS'.
              lr_form_shlp_2->time_picker( value  = ir_client->_bind_edit( <lv_field> ) ).
            WHEN OTHERS.
              lr_form_shlp_2->input( value = ir_client->_bind_edit( <lv_field> ) ).
          ENDCASE.

        WHEN 3.
* ---------- Grid 3--------------------------------------------------------------------------------
* ---------- Set field label ----------------------------------------------------------------------
          lr_form_shlp_3->label( zcl_gu=>get_data_element_labels( iv_data_element = <ls_fielddescr>-rollname ) ).

* ---------- Set input field ----------------------------------------------------------------------
          CASE <ls_fielddescr>-datatype.
            WHEN 'DATS'.
              lr_form_shlp_3->date_picker( value  = ir_client->_bind_edit( <lv_field> ) ).
            WHEN 'TIMS'.
              lr_form_shlp_3->time_picker( value  = ir_client->_bind_edit( <lv_field> ) ).
            WHEN OTHERS.
              lr_form_shlp_3->input( value = ir_client->_bind_edit( <lv_field> ) ).
          ENDCASE.

        WHEN 4.
* ---------- Grid 4--------------------------------------------------------------------------------
* ---------- Set field label ----------------------------------------------------------------------
          lr_form_shlp_4->label( zcl_gu=>get_data_element_labels( iv_data_element = <ls_fielddescr>-rollname ) ).

* ---------- Set input field ----------------------------------------------------------------------
          CASE <ls_fielddescr>-datatype.
            WHEN 'DATS'.
              lr_form_shlp_4->date_picker( value  = ir_client->_bind_edit( <lv_field> ) ).
            WHEN 'TIMS'.
              lr_form_shlp_4->time_picker( value  = ir_client->_bind_edit( <lv_field> ) ).
            WHEN OTHERS.
              lr_form_shlp_4->input( value = ir_client->_bind_edit( <lv_field> ) ).
          ENDCASE.

      ENDCASE.
    ENDLOOP.

* ---------- Create table -------------------------------------------------------------------------
    DATA(lr_table) = ir_parent->table( items = ir_client->_bind_edit( <lt_result_itab> ) ).
* ---------- Create Columns -----------------------------------------------------------------------
    DATA(lr_columns) = lr_table->columns( ).

* ---------- Set column ---------------------------------------------------------------------------
    LOOP AT ls_shlp-fielddescr ASSIGNING <ls_fielddescr>.
      lr_columns->column( )->text( zcl_gu=>get_data_element_labels( iv_data_element = <ls_fielddescr>-rollname ) ).
    ENDLOOP.

* ---------- Build export parameter list ----------------------------------------------------------
    LOOP AT ls_shlp-fieldprop ASSIGNING <ls_FIELDPROP> WHERE shlpoutput = abap_true.
* ---------- Init loop data -----------------------------------------------------------------------
      CLEAR: lv_arg_fieldname.

* ---------- Build parameter name -----------------------------------------------------------------
      lv_arg_fieldname = `${` && <ls_FIELDPROP>-fieldname && `}`.

* ---------- Collect output fields ----------------------------------------------------------------
      APPEND lv_arg_fieldname TO lt_arg.
    ENDLOOP.

    DATA(lr_item) = lr_table->items(
        )->column_list_item( type = 'Navigation'  press = ir_client->_event( val    = iv_result_itab_event
                                                                             t_arg  = lt_arg ) ).

* ---------- Set cell content ---------------------------------------------------------------------
    LOOP AT ls_shlp-fielddescr ASSIGNING <ls_fielddescr>.
* ---------- Init loop data -----------------------------------------------------------------------
      CLEAR: lv_cell_fieldname.

* ---------- Build cell name ----------------------------------------------------------------------
      lv_cell_fieldname = `{` && <ls_fielddescr>-fieldname && `}`.
      lr_item->cells( )->text( lv_cell_fieldname ).
    ENDLOOP.
  ENDMETHOD.


  METHOD select_ddic_shlp.
*----------------------------------------------------------------------*
* LOCAL DATA DEFINITION
*----------------------------------------------------------------------*
    DATA: ls_shlp             TYPE shlp_descr,
          lv_path_result_itab TYPE stringval,
          lv_path_shlp_fields TYPE stringval,
          lt_RETURN_VALUES    TYPE TABLE OF ddshretval,
          lt_record_tab       TYPE TABLE OF seahlpres,
          lv_convexit_name    TYPE rs38l_fnam.

    FIELD-SYMBOLS: <ls_fielddescr>  TYPE dfies,
                   <ls_record_tab>  TYPE seahlpres,
                   <lt_result>      TYPE STANDARD TABLE,
                   <ls_result>      TYPE any,
                   <ls_shlp_fields> TYPE any,
                   <lv_field>       TYPE any.

* ---------- Get result itab reference ------------------------------------------------------------
    lv_path_result_itab = 'IR_CONTROLLER->' && iv_result_itab_name.
    ASSIGN (lv_path_result_itab) TO <lt_result>.

* ---------- Get searchhelp input fields structure reference --------------------------------------
    lv_path_shlp_fields = 'IR_CONTROLLER->' && iv_shlp_fields_struc_name.
    ASSIGN (lv_path_shlp_fields) TO <ls_shlp_fields>.

    IF <lt_result> IS NOT ASSIGNED OR
      <ls_shlp_fields> IS NOT ASSIGNED.
      RETURN.
    ENDIF.

* ---------- Get searchhelp description -----------------------------------------------------------
    CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
      EXPORTING
        shlpname = iv_shlp_id
      IMPORTING
        shlp     = ls_shlp.

* ---------- Set filter criteria ------------------------------------------------------------------
    LOOP AT ls_shlp-fielddescr ASSIGNING <ls_fielddescr>.
* ---------- Init loop data -----------------------------------------------------------------------
      UNASSIGN <lv_field>.

* ---------- Get reference of given fieldname -----------------------------------------------------
      ASSIGN COMPONENT <ls_fielddescr>-fieldname OF STRUCTURE <ls_shlp_fields> TO <lv_field>.

* ---------- In case no field found or the field is initial -> leave ------------------------------
      IF <lv_field> IS NOT ASSIGNED OR
         <lv_field> IS INITIAL.
        CONTINUE.
      ENDIF.

* ---------- Set filter criteria for given fieldname ----------------------------------------------
      APPEND VALUE #( shlpname = ls_shlp-shlpname shlpfield = <ls_fielddescr>-fieldname sign = 'I' option = 'CP' low = <lv_field> ) TO ls_shlp-selopt.
    ENDLOOP.

* ---------- Fetch data from searchhelp -----------------------------------------------------------
    CALL FUNCTION 'F4IF_SELECT_VALUES'
      EXPORTING
        shlp           = ls_shlp
        maxrows        = iv_MAXROWS
        call_shlp_exit = abap_true
      TABLES
        record_tab     = lt_record_tab
        return_tab     = lt_return_values.

* ---------- Map string into structure ------------------------------------------------------------
    LOOP AT lt_record_tab ASSIGNING <ls_record_tab>.
      APPEND INITIAL LINE TO <lt_result> ASSIGNING <ls_result>.
      <ls_result> = <ls_record_tab>-string.

      LOOP AT ls_shlp-fielddescr ASSIGNING <ls_fielddescr>.
* ---------- Init loop data ------------------------------------------------------------------------
        CLEAR: lv_convexit_name.
        UNASSIGN: <lv_field>.

        ASSIGN COMPONENT <ls_fielddescr>-fieldname OF STRUCTURE <ls_result> TO <lv_field>.

        IF <lv_field> IS NOT ASSIGNED OR
          <lv_field> IS INITIAL.
          CONTINUE.
        ENDIF.

* ---------- Set intial values for date and time (if needed) ---------------------------------------
        CASE <ls_fielddescr>-datatype.
          WHEN 'DATS'.
            IF <lv_field> = space.
              <lv_field> = '00000000'.
            ENDIF.
          WHEN 'TIMS'.
            IF <lv_field> = space.
              <lv_field> = '000000'.
            ENDIF.
        ENDCASE.

* ---------- Perform conversion exit ---------------------------------------------------------------
        IF <ls_fielddescr>-convexit IS NOT INITIAL.
* ---------- Build conversion exit name ------------------------------------------------------------
          lv_convexit_name = 'CONVERSION_EXIT_' && <ls_fielddescr>-convexit && '_OUTPUT'.

* ---------- Check if conversion exit function module exists ---------------------------------------
          CALL FUNCTION 'FUNCTION_EXISTS'
            EXPORTING
              funcname           = lv_convexit_name
            EXCEPTIONS
              function_not_exist = 1
              OTHERS             = 2.
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

* ---------- Execute conversion exit ---------------------------------------------------------------
          CALL FUNCTION lv_convexit_name
            EXPORTING
              input  = <lv_field>
            IMPORTING
              output = <lv_field>.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


  METHOD z2ui5_if_app~main.
* -------------------------------------------------------------------------------------------------
* INITIALIZATION
* -------------------------------------------------------------------------------------------------
    IF me->mv_check_initialized = abap_false.
      me->mv_check_initialized = abap_true.


* -------------------------------------------------------------------------------------------------
* RENDERING
* -------------------------------------------------------------------------------------------------
* ---------- Set view -----------------------------------------------------------------------------
      DATA(lr_view) = z2ui5_cl_xml_view=>factory( client = client ).

      DATA(lr_page) = lr_view->page(
            title          = 'abap2UI5 - DDIC Searchhelp generator'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true ).

      DATA(lr_grid) = lr_page->grid( 'L6 M12 S12'
              )->content( 'layout' ).

      lr_grid->simple_form( 'Input'
          )->content( 'form'
              )->label( 'Input with value help'
              )->input( value = client->_bind_edit( me->ms_screen-selfield )
                      showvaluehelp    = abap_true
                      valuehelprequest = client->_event( 'F4_POPUP_OPEN' ) ).

* ---------- Set View -----------------------------------------------------------------------------
      client->view_display( lr_view->stringify( ) ).
    ENDIF.

* -------------------------------------------------------------------------------------------------
* EVENTS
* -------------------------------------------------------------------------------------------------
    CASE client->get( )-event.
      WHEN 'F4_POPUP_OPEN'.
* ---------- Create Popup -------------------------------------------------------------------------
        DATA(lr_popup) = z2ui5_cl_xml_view=>factory_popup( client ).

* ---------- Create Dialog ------------------------------------------------------------------------
        DATA(lr_dialog) = lr_popup->dialog( title     = 'DDIC SHLP Generator'
                                            resizable = abap_true ).

* ---------- Create Popup content -----------------------------------------------------------------
        DATA(lr_dialog_content) = lr_dialog->content( ).

* ---------- Create "Go" button -------------------------------------------------------------------
        DATA(lr_toolbar) = lr_dialog_content->toolbar( ).
        lr_toolbar->toolbar_spacer( ).
        lr_toolbar->button(
                      text    = 'Go'
                      type    = 'Emphasized'
                      press   = client->_event( 'F4_POPUP_GO' ) ).

* -------------------------------------------------------------------------------------------------
* Generate DDIC Searchfields
* -------------------------------------------------------------------------------------------------
        generate_ddic_shlp( ir_parent                 = lr_dialog_content
                            ir_client                 = client
                            ir_controller             = me
                            iv_shlp_id                = 'BUPAP'
                            iv_result_itab_name       = 'MT_SHLP_RESULT'
                            iv_result_itab_event      = 'F4_POPUP_CLOSE'
                            iv_shlp_fields_struc_name = 'MS_SHLP_FIELDS' ).

* ---------- Create Button ------------------------------------------------------------------------
        lr_dialog->buttons( )->button(
                      text    = 'Close'
                      press   = client->_event( 'F4_POPUP_CLOSE' ) ).

* ---------- Display popup window -----------------------------------------------------------------
        client->popup_display( lr_popup->stringify( ) ).

      WHEN 'F4_POPUP_CLOSE'.
* ---------- Retrieve the event parameter ---------------------------------------------------------
        DATA(lt_arg) = client->get( )-t_event_arg.

* ---------- Set search field value ---------------------------------------------------------------
        IF line_exists( lt_arg[ 1 ] ).
          me->ms_screen-selfield = lt_arg[ 1 ].
          client->view_model_update( ).
        ENDIF.

        client->popup_destroy( ).

      WHEN 'F4_POPUP_GO'.
        CLEAR: me->mt_shlp_result.
* ---------- Fetch searchhelp result ----------------------------------------------------------
        select_ddic_shlp( ir_controller             = me
                          iv_shlp_id                = 'BUPAP'
                          iv_result_itab_name       = 'MT_SHLP_RESULT'
                          iv_shlp_fields_struc_name = 'MS_SHLP_FIELDS' ).

* ---------- Update popup model binding -----------------------------------------------------------
        client->popup_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

CLASS z2ui5_cl_demo_app_147 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA check_initialized TYPE abap_bool .
    DATA ms_chartjs_config_bar TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_bar2 TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_hbar TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_line TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_area TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_pie TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_bubble TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_polar TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_doughnut TYPE z2ui5_cl_cc_chartjs=>ty_chart.
  PROTECTED SECTION.

    METHODS z2ui5_on_rendering.
    METHODS z2ui5_on_event.
    METHODS z2ui5_on_init.

  PRIVATE SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_147 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).

      client->view_display( z2ui5_cl_xml_view=>factory(
        )->_z2ui5( )->timer( finished = client->_event( `START` ) delayms = `0`
          )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>load_js( datalabels = abap_true
                                                                                                   autocolors = abap_true
                                                                                                   deferred   = abap_false
                                                                                                  )
        )->stringify( ) ).


    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'START'.
        z2ui5_on_rendering( ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    DATA ls_dataset TYPE z2ui5_cl_cc_chartjs=>ty_dataset.

    ms_chartjs_config_bar-type = 'bar'.
    DATA temp1 TYPE string_table.
    CLEAR temp1.
    INSERT `Red` INTO TABLE temp1.
    INSERT `Blue` INTO TABLE temp1.
    INSERT `Yellow` INTO TABLE temp1.
    INSERT `Green` INTO TABLE temp1.
    INSERT `Purple` INTO TABLE temp1.
    INSERT `Orange` INTO TABLE temp1.
    ms_chartjs_config_bar-data-labels = temp1.

    ls_dataset-border_width = 1.
    ls_dataset-label = `# of Votes`.
    ls_dataset-rtl = abap_true.
    DATA temp3 TYPE string_table.
    CLEAR temp3.
    INSERT `1` INTO TABLE temp3.
    INSERT `12` INTO TABLE temp3.
    INSERT `19` INTO TABLE temp3.
    INSERT `3` INTO TABLE temp3.
    INSERT `5` INTO TABLE temp3.
    INSERT `2` INTO TABLE temp3.
    INSERT `3` INTO TABLE temp3.
    ls_dataset-data = temp3.
    APPEND ls_dataset TO ms_chartjs_config_bar-data-datasets.

    ms_chartjs_config_bar-options-plugins-autocolors-mode = 'data'.
    ms_chartjs_config_bar-options-plugins-datalabels-text_align = `center`.
    ms_chartjs_config_bar-options-scales-y-begin_at_zero = abap_true.

    ms_chartjs_config_bar2-type = 'bar'.
    DATA temp5 TYPE string_table.
    CLEAR temp5.
    INSERT `Jan` INTO TABLE temp5.
    INSERT `Feb` INTO TABLE temp5.
    INSERT `Mar` INTO TABLE temp5.
    INSERT `Apr` INTO TABLE temp5.
    INSERT `May` INTO TABLE temp5.
    INSERT `Jun` INTO TABLE temp5.
    ms_chartjs_config_bar2-data-labels = temp5.

    CLEAR ls_dataset.
    ls_dataset-label = 'Fully Rounded'.
    ls_dataset-border_width = 2.
    ls_dataset-border_radius = 200.
    ls_dataset-border_skipped = abap_false.
    DATA temp7 TYPE string_table.
    CLEAR temp7.
    INSERT `1` INTO TABLE temp7.
    INSERT `-12` INTO TABLE temp7.
    INSERT `19` INTO TABLE temp7.
    INSERT `3` INTO TABLE temp7.
    INSERT `5` INTO TABLE temp7.
    INSERT `-2` INTO TABLE temp7.
    INSERT `3` INTO TABLE temp7.
    ls_dataset-data = temp7.
    APPEND ls_dataset TO ms_chartjs_config_bar2-data-datasets.

    CLEAR ls_dataset.
    ls_dataset-label = 'Small Radius'.
    ls_dataset-border_width = 2.
    ls_dataset-border_radius = 5.
    ls_dataset-border_skipped = abap_false.
    DATA temp9 TYPE string_table.
    CLEAR temp9.
    INSERT `11` INTO TABLE temp9.
    INSERT `2` INTO TABLE temp9.
    INSERT `-3` INTO TABLE temp9.
    INSERT `13` INTO TABLE temp9.
    INSERT `-9` INTO TABLE temp9.
    INSERT `7` INTO TABLE temp9.
    INSERT `-4` INTO TABLE temp9.
    ls_dataset-data = temp9.
    APPEND ls_dataset TO ms_chartjs_config_bar2-data-datasets.

    ms_chartjs_config_bar2-options-responsive = abap_true.
    ms_chartjs_config_bar2-options-plugins-legend-position = `top`.
    ms_chartjs_config_bar2-options-plugins-title-display = abap_true.
    ms_chartjs_config_bar2-options-plugins-title-text = `Bar Chart`.

    ms_chartjs_config_bar2-options-plugins-autocolors-offset = 11.
    ms_chartjs_config_bar2-options-plugins-autocolors-mode = 'dataset'.
    ms_chartjs_config_bar2-options-plugins-datalabels-text_align = `center`.
    ms_chartjs_config_bar2-options-plugins-datalabels-color = `white`.



    ms_chartjs_config_hbar-type = 'bar'.
    DATA temp11 TYPE string_table.
    CLEAR temp11.
    INSERT `Jan` INTO TABLE temp11.
    INSERT `Feb` INTO TABLE temp11.
    INSERT `Mar` INTO TABLE temp11.
    INSERT `Apr` INTO TABLE temp11.
    INSERT `May` INTO TABLE temp11.
    INSERT `Jun` INTO TABLE temp11.
    ms_chartjs_config_hbar-data-labels = temp11.

    CLEAR ls_dataset.
    ls_dataset-label = 'Dataset 1'.
    ls_dataset-background_color = `#ffb1c1`.
    ls_dataset-border_color = `#ff7894`.
    DATA temp13 TYPE string_table.
    CLEAR temp13.
    INSERT `5` INTO TABLE temp13.
    INSERT `-12` INTO TABLE temp13.
    INSERT `19` INTO TABLE temp13.
    INSERT `3` INTO TABLE temp13.
    INSERT `5` INTO TABLE temp13.
    INSERT `-2` INTO TABLE temp13.
    INSERT `3` INTO TABLE temp13.
    ls_dataset-data = temp13.
    APPEND ls_dataset TO ms_chartjs_config_hbar-data-datasets.

    CLEAR ls_dataset.
    ls_dataset-label = 'Dataset 2'.
    ls_dataset-background_color = `#9ad0f5`.
    ls_dataset-border_color = `#40a6ec`.
    DATA temp15 TYPE string_table.
    CLEAR temp15.
    INSERT `11` INTO TABLE temp15.
    INSERT `2` INTO TABLE temp15.
    INSERT `-3` INTO TABLE temp15.
    INSERT `13` INTO TABLE temp15.
    INSERT `-9` INTO TABLE temp15.
    INSERT `7` INTO TABLE temp15.
    INSERT `-4` INTO TABLE temp15.
    ls_dataset-data = temp15.
    APPEND ls_dataset TO ms_chartjs_config_hbar-data-datasets.

    ms_chartjs_config_hbar-options-responsive = abap_true.
    ms_chartjs_config_hbar-options-index_axis = `y`.
    ms_chartjs_config_hbar-options-elements-bar-border_width = 2.
    ms_chartjs_config_hbar-options-plugins-legend-position = `right`.
    ms_chartjs_config_hbar-options-plugins-title-display = abap_true.
    ms_chartjs_config_hbar-options-plugins-title-text = `Horizontal Bar Chart`.


    ms_chartjs_config_hbar-options-plugins-datalabels-text_align = `center`.
    ms_chartjs_config_hbar-options-plugins-datalabels-color = `white`.


    ms_chartjs_config_line-type = 'line'.
    DATA temp17 TYPE string_table.
    CLEAR temp17.
    INSERT `Jan` INTO TABLE temp17.
    INSERT `Feb` INTO TABLE temp17.
    INSERT `Mar` INTO TABLE temp17.
    INSERT `Apr` INTO TABLE temp17.
    INSERT `May` INTO TABLE temp17.
    INSERT `Jun` INTO TABLE temp17.
    ms_chartjs_config_line-data-labels = temp17.

    CLEAR ls_dataset.
    ls_dataset-label = 'Dataset 1'.
    ls_dataset-background_color = `#ffb1c1`.
    ls_dataset-border_color = `#ff7894`.
    DATA temp19 TYPE string_table.
    CLEAR temp19.
    INSERT `5` INTO TABLE temp19.
    INSERT `-12` INTO TABLE temp19.
    INSERT `19` INTO TABLE temp19.
    INSERT `3` INTO TABLE temp19.
    INSERT `5` INTO TABLE temp19.
    INSERT `-2` INTO TABLE temp19.
    INSERT `3` INTO TABLE temp19.
    ls_dataset-data = temp19.
    APPEND ls_dataset TO ms_chartjs_config_line-data-datasets.

    CLEAR ls_dataset.
    ls_dataset-label = 'Dataset 2'.
    ls_dataset-point_style = 'circle'.
    ls_dataset-point_hover_radius = 10.
    ls_dataset-background_color = `#9ad0f5`.
    ls_dataset-border_color = `#40a6ec`.
    DATA temp21 TYPE string_table.
    CLEAR temp21.
    INSERT `11` INTO TABLE temp21.
    INSERT `2` INTO TABLE temp21.
    INSERT `-3` INTO TABLE temp21.
    INSERT `13` INTO TABLE temp21.
    INSERT `-9` INTO TABLE temp21.
    INSERT `7` INTO TABLE temp21.
    INSERT `-4` INTO TABLE temp21.
    ls_dataset-data = temp21.
    APPEND ls_dataset TO ms_chartjs_config_line-data-datasets.

    ms_chartjs_config_line-options-responsive = abap_true.
    ms_chartjs_config_line-options-plugins-legend-position = `top`.
    ms_chartjs_config_line-options-plugins-title-display = abap_true.
    ms_chartjs_config_line-options-plugins-title-text = `Line Chart`.
    ms_chartjs_config_line-options-plugins-datalabels-font-size = `10`.
    ms_chartjs_config_line-options-plugins-datalabels-font-weight = `bold`.
    ms_chartjs_config_line-options-plugins-datalabels-text_align = 'start'.
    ms_chartjs_config_line-options-plugins-datalabels-offset = 90.
*    ms_chartjs_config_line-options-plugins-datalabels-offset = `6`.


    ms_chartjs_config_bubble-type = 'bubble'.

    CLEAR ls_dataset.
    ls_dataset-label = 'Dataset 1'.
    DATA temp23 LIKE ls_dataset-data_x_y_r.
    CLEAR temp23.
    DATA temp24 LIKE LINE OF temp23.
    temp24-x = `100`.
    temp24-y = `0`.
    temp24-r = `8`.
    INSERT temp24 INTO TABLE temp23.
    temp24-x = `60`.
    temp24-y = `30`.
    temp24-r = `15`.
    INSERT temp24 INTO TABLE temp23.
    temp24-x = `40`.
    temp24-y = `60`.
    temp24-r = `8`.
    INSERT temp24 INTO TABLE temp23.
    temp24-x = `80`.
    temp24-y = `80`.
    temp24-r = `23`.
    INSERT temp24 INTO TABLE temp23.
    temp24-x = `20`.
    temp24-y = `30`.
    temp24-r = `8`.
    INSERT temp24 INTO TABLE temp23.
    temp24-x = `0`.
    temp24-y = `100`.
    temp24-r = `9`.
    INSERT temp24 INTO TABLE temp23.
    ls_dataset-data_x_y_r = temp23.
    ls_dataset-background_color = `#ffb1c1`.
    ls_dataset-border_color = `#ff7894`.
    APPEND ls_dataset TO ms_chartjs_config_bubble-data-datasets.

    CLEAR ls_dataset.
    ls_dataset-label = 'Dataset 2'.
    ls_dataset-background_color = `#9ad0f5`.
    ls_dataset-border_color = `#40a6ec`.
    DATA temp25 LIKE ls_dataset-data_x_y_r.
    CLEAR temp25.
    DATA temp26 LIKE LINE OF temp25.
    temp26-x = `0`.
    temp26-y = `0`.
    temp26-r = `8`.
    INSERT temp26 INTO TABLE temp25.
    temp26-x = `20`.
    temp26-y = `15`.
    temp26-r = `15`.
    INSERT temp26 INTO TABLE temp25.
    temp26-x = `80`.
    temp26-y = `40`.
    temp26-r = `8`.
    INSERT temp26 INTO TABLE temp25.
    temp26-x = `20`.
    temp26-y = `66`.
    temp26-r = `23`.
    INSERT temp26 INTO TABLE temp25.
    temp26-x = `10`.
    temp26-y = `15`.
    temp26-r = `8`.
    INSERT temp26 INTO TABLE temp25.
    temp26-x = `80`.
    temp26-y = `5`.
    temp26-r = `9`.
    INSERT temp26 INTO TABLE temp25.
    ls_dataset-data_x_y_r = temp25.
    APPEND ls_dataset TO ms_chartjs_config_bubble-data-datasets.

    ms_chartjs_config_bubble-options-responsive = abap_true.
    ms_chartjs_config_bubble-options-plugins-legend-position = `top`.
    ms_chartjs_config_bubble-options-plugins-title-display = '-'.
    ms_chartjs_config_bubble-options-plugins-title-text = `Bubble Chart`.
    ms_chartjs_config_bubble-options-plugins-datalabels-display = '-'.


    ms_chartjs_config_doughnut-type = 'doughnut'.
    DATA temp27 TYPE string_table.
    CLEAR temp27.
    INSERT `Red` INTO TABLE temp27.
    INSERT `Blue` INTO TABLE temp27.
    INSERT `Teal` INTO TABLE temp27.
    INSERT `Green` INTO TABLE temp27.
    INSERT `Purple` INTO TABLE temp27.
    INSERT `Orange` INTO TABLE temp27.
    ms_chartjs_config_doughnut-data-labels = temp27.

    CLEAR ls_dataset.
    ls_dataset-label = `Dataset 1`.
    DATA temp29 TYPE z2ui5_cl_cc_chartjs=>ty_bg_color.
    CLEAR temp29.
    INSERT `red` INTO TABLE temp29.
    INSERT `blue` INTO TABLE temp29.
    INSERT `#118ab2` INTO TABLE temp29.
    INSERT `green` INTO TABLE temp29.
    INSERT `purple` INTO TABLE temp29.
    INSERT `orange` INTO TABLE temp29.
    ls_dataset-background_color_t = temp29.
    DATA temp31 TYPE string_table.
    CLEAR temp31.
    INSERT `1` INTO TABLE temp31.
    INSERT `12` INTO TABLE temp31.
    INSERT `19` INTO TABLE temp31.
    INSERT `3` INTO TABLE temp31.
    INSERT `5` INTO TABLE temp31.
    INSERT `2` INTO TABLE temp31.
    ls_dataset-data = temp31.
    ls_dataset-hover_offset = 5.
    APPEND ls_dataset TO ms_chartjs_config_doughnut-data-datasets.

    ms_chartjs_config_doughnut-options-plugins-autocolors-enabled = '-'.
    ms_chartjs_config_doughnut-options-plugins-datalabels-text_align = 'center'.
    ms_chartjs_config_doughnut-options-plugins-datalabels-color = 'white'.
    ms_chartjs_config_doughnut-options-plugins-title-text = `Doughnut Chart`.
    ms_chartjs_config_doughnut-options-plugins-title-display = abap_true.
    ms_chartjs_config_doughnut-options-plugins-legend-position = 'right'.


    ms_chartjs_config_pie-type = 'pie'.
    DATA temp33 TYPE string_table.
    CLEAR temp33.
    INSERT `Red` INTO TABLE temp33.
    INSERT `Blue` INTO TABLE temp33.
    INSERT `Teal` INTO TABLE temp33.
    INSERT `Green` INTO TABLE temp33.
    INSERT `Purple` INTO TABLE temp33.
    INSERT `Orange` INTO TABLE temp33.
    ms_chartjs_config_pie-data-labels = temp33.

    CLEAR ls_dataset.
    ls_dataset-label = `Dataset 1'`.
    DATA temp35 TYPE z2ui5_cl_cc_chartjs=>ty_bg_color.
    CLEAR temp35.
    INSERT `red` INTO TABLE temp35.
    INSERT `blue` INTO TABLE temp35.
    INSERT `#118ab2` INTO TABLE temp35.
    INSERT `green` INTO TABLE temp35.
    INSERT `purple` INTO TABLE temp35.
    INSERT `orange` INTO TABLE temp35.
    ls_dataset-background_color_t = temp35.
    DATA temp37 TYPE string_table.
    CLEAR temp37.
    INSERT `1` INTO TABLE temp37.
    INSERT `12` INTO TABLE temp37.
    INSERT `19` INTO TABLE temp37.
    INSERT `3` INTO TABLE temp37.
    INSERT `5` INTO TABLE temp37.
    INSERT `2` INTO TABLE temp37.
    ls_dataset-data = temp37.
    ls_dataset-hover_offset = 5.
    APPEND ls_dataset TO ms_chartjs_config_pie-data-datasets.

    ms_chartjs_config_pie-options-plugins-autocolors-enabled = '-'.
    ms_chartjs_config_pie-options-plugins-datalabels-text_align = 'center'.
    ms_chartjs_config_pie-options-plugins-datalabels-color = 'white'.
    ms_chartjs_config_pie-options-plugins-title-text = `Pie Chart`.
    ms_chartjs_config_pie-options-plugins-title-display = abap_true.
    ms_chartjs_config_pie-options-plugins-legend-position = 'left'.


    ms_chartjs_config_polar-type = 'polarArea'.
    DATA temp39 TYPE string_table.
    CLEAR temp39.
    INSERT `Red` INTO TABLE temp39.
    INSERT `Blue` INTO TABLE temp39.
    INSERT `Teal` INTO TABLE temp39.
    INSERT `Green` INTO TABLE temp39.
    INSERT `Purple` INTO TABLE temp39.
    INSERT `Orange` INTO TABLE temp39.
    ms_chartjs_config_polar-data-labels = temp39.

    CLEAR ls_dataset.
    ls_dataset-label = `Dataset 1`.
    DATA temp41 TYPE z2ui5_cl_cc_chartjs=>ty_bg_color.
    CLEAR temp41.
    INSERT `red` INTO TABLE temp41.
    INSERT `blue` INTO TABLE temp41.
    INSERT `#118ab2` INTO TABLE temp41.
    INSERT `green` INTO TABLE temp41.
    INSERT `purple` INTO TABLE temp41.
    INSERT `orange` INTO TABLE temp41.
    ls_dataset-background_color_t = temp41.
    DATA temp43 TYPE string_table.
    CLEAR temp43.
    INSERT `10` INTO TABLE temp43.
    INSERT `12` INTO TABLE temp43.
    INSERT `19` INTO TABLE temp43.
    INSERT `8` INTO TABLE temp43.
    INSERT `5` INTO TABLE temp43.
    INSERT `9` INTO TABLE temp43.
    ls_dataset-data = temp43.
    APPEND ls_dataset TO ms_chartjs_config_polar-data-datasets.

    ms_chartjs_config_polar-options-plugins-autocolors-enabled = '-'.
    ms_chartjs_config_polar-options-plugins-datalabels-text_align = 'center'.
    ms_chartjs_config_polar-options-plugins-datalabels-color = 'white'.
    ms_chartjs_config_polar-options-plugins-title-text = `Polar Area Chart`.
    ms_chartjs_config_polar-options-plugins-title-display = abap_true.
    ms_chartjs_config_polar-options-plugins-legend-position = 'left'.

  ENDMETHOD.


  METHOD z2ui5_on_rendering.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    temp1 = boolc( abap_false = client->get( )-check_launchpad_active ).
    page = view->shell(
         )->page(
          showheader       = temp1
            title          = 'abap2UI5 - ChartJS demo'
            navbuttonpress = client->_event( 'BACK' )
            enablescrolling = abap_false
              shownavbutton = abap_true ).

    page->header_content(
             )->link( text = 'Demo'        target = '_blank' href = `https://twitter.com/abap2UI5/status/1628701535222865922`
             )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
         )->get_parent( ).


*    DATA(vbox) = page->vbox( justifycontent = `Center`  ).
    DATA car TYPE REF TO z2ui5_cl_xml_view.
    car = page->carousel( class = `sapUiContentPadding` ).
    DATA vl1 TYPE REF TO z2ui5_cl_xml_view.
    vl1 = car->vertical_layout( width = `100%` ).
    DATA fb1 TYPE REF TO z2ui5_cl_xml_view.
    fb1 = vl1->flex_box( width = `100%` height = `50%` justifycontent = `SpaceAround` ).
    DATA fb2 TYPE REF TO z2ui5_cl_xml_view.
    fb2 = vl1->flex_box( width = `100%` height = `50%` justifycontent = `SpaceAround` ).
    fb1->vbox( justifycontent = `Center` )->html_canvas( id = `bar`  height = `300` width = `400` ).
    fb1->vbox( justifycontent = `Center` )->html_canvas( id = `bar2` height = `300` width = `400` ).
    fb2->vbox( justifycontent = `Center` )->html_canvas( id = `hbar` height = `300` width = `400` ).
    fb2->vbox( justifycontent = `Center` )->html_canvas( id = `line`  height = `300` width = `400` ).

    DATA vl2 TYPE REF TO z2ui5_cl_xml_view.
    vl2 = car->vertical_layout( width = `100%` ).
    DATA fb3 TYPE REF TO z2ui5_cl_xml_view.
    fb3 = vl2->flex_box( width = `100%` height = `50%` justifycontent = `SpaceAround` ).
    DATA fb4 TYPE REF TO z2ui5_cl_xml_view.
    fb4 = vl2->flex_box( width = `100%` height = `50%` justifycontent = `SpaceAround` ).
    fb3->vbox( justifycontent = `Center` )->html_canvas( id = `bubble`  height = `300` width = `315 ` ).
    fb3->vbox( justifycontent = `Center` )->html_canvas( id = `doughnut`  height = `300` width = `315` ).
    fb4->vbox( justifycontent = `Center` )->html_canvas( id = `pie`  height = `300` width = `315` ).
    fb4->vbox( justifycontent = `Center` )->html_canvas( id = `polar`  height = `300` width = `315` ).


*    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>set_js_config( canvas_id = 'bar'
*                                                                                                      is_config = ms_chartjs_config_bar
*                                                                                                      view = client->cs_view-main ) ).
*    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>set_js_config( canvas_id = 'bar2'
*                                                                                                      is_config = ms_chartjs_config_bar2
*                                                                                                      view = client->cs_view-main ) ).
*    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>set_js_config( canvas_id = 'hbar'
*                                                                                                      is_config = ms_chartjs_config_hbar
*                                                                                                      view = client->cs_view-main ) ).
*    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>set_js_config( canvas_id = 'line'
*                                                                                                      is_config = ms_chartjs_config_line
*                                                                                                      view = client->cs_view-main ) ).
*    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>set_js_config( canvas_id = 'bubble'
*                                                                                                      is_config = ms_chartjs_config_bubble
*                                                                                                      view = client->cs_view-main ) ).
*    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>set_js_config( canvas_id = 'doughnut'
*                                                                                                      is_config = ms_chartjs_config_doughnut
*                                                                                                      view = client->cs_view-main ) ).
*    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>set_js_config( canvas_id = 'pie'
*                                                                                                      is_config = ms_chartjs_config_pie
*                                                                                                      view = client->cs_view-main ) ).
*    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>set_js_config( canvas_id = 'polar'
*                                                                                                      is_config = ms_chartjs_config_polar
*                                                                                                      view = client->cs_view-main ) ).
    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.

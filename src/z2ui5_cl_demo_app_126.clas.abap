CLASS z2ui5_cl_demo_app_126 DEFINITION
 PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.


  PRIVATE SECTION.

ENDCLASS.


CLASS z2ui5_cl_demo_app_126 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    DATA temp1 TYPE REF TO lcl_demo_app_126.
    CREATE OBJECT temp1 TYPE lcl_demo_app_126.
    client->nav_app_leave( temp1 ).

  ENDMETHOD.

ENDCLASS.


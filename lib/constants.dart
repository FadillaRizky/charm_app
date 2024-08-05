import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static Color primaryColor = Color.fromARGB(1000, 57, 124, 254);
  static TextStyle textbutton1 = TextStyle(fontSize: 20);
  static TextStyle textbutton2 = TextStyle(
      color: Colors.blueAccent,
      fontSize: 10,
      fontWeight: FontWeight.w500);
  static TextStyle textbutton3 = TextStyle(
      fontSize: 20,
      color: Colors.black54,
      fontWeight: FontWeight.bold);
  static TextStyle textbutton4 = TextStyle(
    fontSize: 20,
  );
  static TextStyle subtitle1 = GoogleFonts.roboto(fontSize:10, color: Colors.blueAccent);
  static TextStyle subtitle2 = TextStyle(fontSize: 17);
  static TextStyle subtitle3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );
  static TextStyle headline1 = GoogleFonts.roboto(
      fontSize: 10, color: Colors.blueAccent, fontWeight: FontWeight.w500);
  static TextStyle headline2 = TextStyle(
      fontSize: 10,
      color: Colors.blue,
      fontWeight: FontWeight.bold);





  ///Button STYLE
  static ButtonStyle buttonStyle1 = ButtonStyle(
      padding: MaterialStateProperty.all(
          EdgeInsets.all(
              5)),
      backgroundColor: MaterialStateProperty.all(Colors.grey),
      shape: MaterialStateProperty.all<
          RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(50),
          )));
// static TextStyle title =
//     GoogleFonts.roboto(fontSize: 20, color: Colors.black);
// static TextStyle title2 = GoogleFonts.roboto(
//   fontSize: 20,
//   color: Colors.black,
//   fontWeight: FontWeight.bold,
// );
// static TextStyle title3 =
//     GoogleFonts.roboto(fontSize: 17, color: Colors.black);
// static TextStyle titleItemProfile =
//     GoogleFonts.openSans(fontSize: 15, color: Colors.black);
// static TextStyle titleActivity = GoogleFonts.roboto(
//     fontSize: 25, color: Colors.blueAccent, fontWeight: FontWeight.w500);
// static TextStyle subtitleActivity =
//     GoogleFonts.roboto(fontSize: 12, color: Colors.blueAccent);

}

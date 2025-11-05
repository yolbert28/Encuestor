import 'package:encuestor/core/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  static final TextStyle title = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: GoogleFonts.bricolageGrotesque().fontFamily,
    color: AppColor.textDark,
  );


  static final TextStyle subtitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: GoogleFonts.bricolageGrotesque().fontFamily,
    color: AppColor.textDark,
  );

  static final TextStyle body = TextStyle(fontSize: 16,
    fontFamily: GoogleFonts.bricolageGrotesque().fontFamily, color: AppColor.white);

  static final TextStyle buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: GoogleFonts.bricolageGrotesque().fontFamily,
    color: AppColor.white,
  );

  static final TextStyle titleSurvey = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: GoogleFonts.bricolageGrotesque().fontFamily,
    color: AppColor.white,
  );

}

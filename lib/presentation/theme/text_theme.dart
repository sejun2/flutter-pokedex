import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextTheme extends TextTheme {
  const CustomTextTheme();

  @override
  TextStyle? get titleLarge =>
      GoogleFonts.poppins().copyWith(fontSize: 32, fontWeight: FontWeight.w600);

  @override
  TextStyle? get titleMedium =>
      GoogleFonts.poppins().copyWith(fontSize: 21, fontWeight: FontWeight.w600);

  @override
  TextStyle? get titleSmall =>
      GoogleFonts.poppins().copyWith(fontSize: 12, fontWeight: FontWeight.w600);

  @override
  TextStyle? get labelLarge =>
      GoogleFonts.poppins().copyWith(fontSize: 16, fontWeight: FontWeight.w600);

  @override
  TextStyle? get labelMedium =>
      GoogleFonts.poppins().copyWith(fontSize: 14, fontWeight: FontWeight.w600);

  @override
  TextStyle? get labelSmall =>
      GoogleFonts.poppins().copyWith(fontSize: 12, fontWeight: FontWeight.w500);
}

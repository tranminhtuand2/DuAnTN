import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

final lightTheme = ThemeData(
  fontFamily: GoogleFonts.interTight().fontFamily,
  useMaterial3: true,
  colorScheme: TAppTheme.lightColorScheme,
  textTheme: TAppTextTheme.lightTextTheme,
);
final darkTheme = ThemeData(
  fontFamily: GoogleFonts.interTight().fontFamily,
  useMaterial3: true,
  colorScheme: TAppTheme.darkColorScheme,
  textTheme: TAppTextTheme.darkTextTheme,
);

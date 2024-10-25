import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFEB3B), // Colors/Brand/Yellow
    onPrimary: Color(0xFFFFFFFF), // Colors/mainColors/primary
    secondary: Color(0xFF808080), // Colors/mainColors/secondary
    onSecondary: Color(0xFFFFFFFF), // Assuming onSecondary is white
    error: Color(0xFFFF0000), // Red for errors
    onError: Color(0xFFFFFFFF), // White for onError

    surface: Color(0xFF131313), // Colors/Brand/blackish
    onSurface: Color(0xFFFFFFFF), // White text on surface
  ),
  brightness: Brightness.dark,
  scaffoldBackgroundColor:const Color(0xFF000000), // Colors/Background/Black
//textTheme: GoogleFonts.interTextTheme(),
  // Additional properties
  appBarTheme: AppBarTheme(
    color: Color(0xFF131313), // Colors/Brand/blackish
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFFFEB3B), // Colors/Brand/Yellow
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xFF131313), // Colors/Brand/blackish
  ),
  // Add other theme properties as needed
);

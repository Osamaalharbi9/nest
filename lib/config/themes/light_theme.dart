import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFFFEB3B), // Colors/Brand/Yellow
    onPrimary: Color(0xFF000000), // Black text on yellow primary color
    secondary: Color(0xFF808080), // Colors/mainColors/secondary
    onSecondary: Color(0xFF000000), // Black text on secondary color
    error: Color(0xFFFF0000), // Red for errors
    onError: Color(0xFFFFFFFF), // White text on error color

    surface: Color(0xFFFFFFFF), // White surface
    onSurface: Color(0xFF000000), // Black text on surface
    background: Color(0xFFFFFFFF), // White background
    onBackground: Color(0xFF000000), // Black text on background
  ),
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFFFFFFF), // Colors/Background/White

  // Font and text styling
  textTheme: GoogleFonts.interTextTheme(), // Apply Inter font

  // Additional properties
  appBarTheme: const AppBarTheme(
    color: Color(0xFFFFFFFF), // White app bar color
    iconTheme: IconThemeData(color: Color(0xFF000000)), // Black icons
    titleTextStyle: TextStyle(color: Color(0xFF000000), fontSize: 20), // Black text
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFFFEB3B), // Colors/Brand/Yellow
    foregroundColor: Color(0xFF000000), // Black icon on FAB
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFFFFEB3B), // Yellow button color
    textTheme: ButtonTextTheme.primary, // White text on buttons
  ),
  // Add other theme properties as needed
);

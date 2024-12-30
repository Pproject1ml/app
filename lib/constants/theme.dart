// import 'package:chat_location/constants/colors.dart';
// import 'package:flutter/material.dart';

// const ThemeData theme = ThemeData(
//   primaryColor: TTColors.ttPurple,
//   accentColor:

// );

import 'package:flutter/material.dart';

class TTTextTheme {
  static const TextTheme lightTextTheme = TextTheme(
      labelLarge: TextStyle(
          fontSize: 16,
          color: Colors.black,
          letterSpacing: -0.4,
          fontWeight: FontWeight.normal),
      labelMedium: TextStyle(
          fontSize: 14,
          color: Colors.black,
          letterSpacing: -0.4,
          fontWeight: FontWeight.normal),
      labelSmall: TextStyle(
          fontSize: 12,
          color: Colors.black,
          letterSpacing: -0.4,
          fontWeight: FontWeight.normal),
      titleLarge: TextStyle(
          fontSize: 22,
          color: Colors.black,
          letterSpacing: 0,
          fontWeight: FontWeight.normal),
      titleMedium: TextStyle(
          fontSize: 20,
          color: Colors.black,
          letterSpacing: 0,
          fontWeight: FontWeight.normal),
      titleSmall: TextStyle(
          fontSize: 18,
          color: Colors.black,
          letterSpacing: 0,
          fontWeight: FontWeight.normal),
      headlineMedium: TextStyle(
          fontSize: 24,
          color: Colors.black,
          letterSpacing: 0,
          fontWeight: FontWeight.bold));

  static const TextTheme darkTextTheme = TextTheme(
      labelLarge: TextStyle(
          fontSize: 16,
          color: Colors.white,
          letterSpacing: -0.4,
          fontWeight: FontWeight.normal),
      labelMedium: TextStyle(
          fontSize: 14,
          color: Colors.white,
          letterSpacing: -0.4,
          fontWeight: FontWeight.normal),
      labelSmall: TextStyle(
          fontSize: 12,
          color: Colors.white,
          letterSpacing: -0.4,
          fontWeight: FontWeight.normal),
      titleLarge: TextStyle(
          fontSize: 22,
          color: Colors.white,
          letterSpacing: 0,
          fontWeight: FontWeight.normal),
      titleMedium: TextStyle(
          fontSize: 20,
          color: Colors.white,
          letterSpacing: 0,
          fontWeight: FontWeight.normal),
      titleSmall: TextStyle(
          fontSize: 18,
          color: Colors.white,
          letterSpacing: 0,
          fontWeight: FontWeight.normal),
      headlineMedium: TextStyle(
          fontSize: 24,
          color: Colors.white,
          letterSpacing: -0.4,
          fontWeight: FontWeight.bold));
}

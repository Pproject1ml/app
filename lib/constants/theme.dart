import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:flutter/material.dart';

const Color textLightColor = TTColors.black;
const Color textDarkColor = TTColors.white;

const Color cardLightColor = TTColors.white;
const Color cardDarkColor = TTColors.black;

const Color appbarLightColor = TTColors.white;
const Color appbarDarkColor = TTColors.black;

const Color scaffoldBackgroundLightColor = TTColors.gray100;
const Color scaffoldBackgroundDarkColor = TTColors.black;

const Color bottomNavBarBackgroundLightColor = TTColors.white;
const Color bottomNavBarBackgroundDartColor = TTColors.black;

const Color indicatorLightColor = TTColors.ttPurple;
const Color indicatorDartColor = TTColors.white;

const Color primarayLightColor = TTColors.ttPurple;
const Color primarayDarkColor = TTColors.ttPurple;

const Color drawerLightColor = TTColors.white;
const Color drawerDarkColor = Colors.black87;
ThemeData LIGHT_THEME = ThemeData(
  primaryColor: primarayLightColor,
  fontFamily: 'Pretendard',
  brightness: Brightness.light,
  cardTheme: const CardTheme(
    color: cardLightColor,
  ),
  cardColor: cardLightColor,
  indicatorColor: indicatorLightColor,
  progressIndicatorTheme: const ProgressIndicatorThemeData(
      circularTrackColor: indicatorLightColor,
      color: TTColors.purple100,
      refreshBackgroundColor: TTColors.white),
  textTheme: lightTextTheme,
  scaffoldBackgroundColor: scaffoldBackgroundLightColor,
  appBarTheme: const AppBarTheme(
    color: appbarLightColor,
    centerTitle: true,
  ),
  drawerTheme: const DrawerThemeData(backgroundColor: drawerLightColor),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: bottomNavBarBackgroundLightColor,
      selectedIconTheme:
          const IconThemeData(size: 24, color: primarayLightColor),
      unselectedIconTheme:
          const IconThemeData(size: 24, color: TTColors.gray400),
      selectedLabelStyle:
          TTTextStyle.captionMedium12.copyWith(color: primarayLightColor),
      unselectedLabelStyle:
          TTTextStyle.captionMedium12.copyWith(color: TTColors.gray400)),
  navigationBarTheme:
      const NavigationBarThemeData(backgroundColor: Colors.white),
  dialogBackgroundColor: cardLightColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        backgroundColor: primarayLightColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: TTColors.gray200),
  ),
);
ThemeData Dark_THEME = ThemeData(
  primaryColor: primarayLightColor,
  fontFamily: 'Pretendard',
  brightness: Brightness.dark,
  cardTheme: const CardTheme(color: cardDarkColor),
  cardColor: cardDarkColor,
  indicatorColor: indicatorDartColor,
  progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: indicatorDartColor, refreshBackgroundColor: TTColors.black),
  textTheme: darkTextTheme,
  scaffoldBackgroundColor: scaffoldBackgroundDarkColor,
  appBarTheme: const AppBarTheme(color: appbarDarkColor, centerTitle: true),
  drawerTheme: const DrawerThemeData(backgroundColor: drawerDarkColor),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: bottomNavBarBackgroundDartColor,
      selectedIconTheme: const IconThemeData(
        size: 24,
        color: primarayDarkColor,
      ),
      unselectedIconTheme:
          const IconThemeData(size: 24, color: TTColors.gray400),
      selectedLabelStyle:
          TTTextStyle.captionMedium12.copyWith(color: primarayDarkColor),
      unselectedLabelStyle:
          TTTextStyle.captionMedium12.copyWith(color: TTColors.gray400)),
  navigationBarTheme:
      const NavigationBarThemeData(backgroundColor: Colors.black),
  dialogBackgroundColor: cardDarkColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        backgroundColor: primarayDarkColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: TTColors.gray200),
  ),
);

const TextTheme lightTextTheme = TextTheme(
  displayLarge: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 30,
    color: textLightColor,
  ),
  displayMedium: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 28,
    color: textLightColor,
  ),
  displaySmall: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 26,
    color: textLightColor,
  ),
  headlineLarge: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 26,
    color: textLightColor,
  ),
  headlineMedium: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 14,
    color: textLightColor,
  ),
  headlineSmall: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 22,
    color: textLightColor,
  ),
  titleLarge: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 22,
    color: textLightColor,
  ),
  titleMedium: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 20,
    color: textLightColor,
  ),
  titleSmall: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 18,
    color: textLightColor,
  ),
  bodyLarge: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 16,
    color: textLightColor,
  ),
  bodyMedium: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 14,
    color: textLightColor,
  ),
  bodySmall: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 12,
    color: textLightColor,
  ),
  labelLarge: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 12,
    color: textLightColor,
  ),
  labelMedium: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 10,
    color: textLightColor,
  ),
  labelSmall: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 8,
    color: textLightColor,
  ),
);

const TextTheme darkTextTheme = TextTheme(
  displayLarge: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 30,
    color: textDarkColor,
  ),
  displayMedium: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 28,
    color: textDarkColor,
  ),
  displaySmall: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 26,
    color: textDarkColor,
  ),
  headlineLarge: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 26,
    color: textDarkColor,
  ),
  headlineMedium: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 14,
    color: textDarkColor,
  ),
  headlineSmall: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 22,
    color: textDarkColor,
  ),
  titleLarge: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 22,
    color: textDarkColor,
  ),
  titleMedium: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 20,
    color: textDarkColor,
  ),
  titleSmall: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 18,
    color: textDarkColor,
  ),
  bodyLarge: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 16,
    color: textDarkColor,
  ),
  bodyMedium: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 14,
    color: textDarkColor,
  ),
  bodySmall: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 12,
    color: textDarkColor,
  ),
  labelLarge: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 12,
    color: textDarkColor,
  ),
  labelMedium: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 10,
    color: textDarkColor,
  ),
  labelSmall: TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 8,
    color: textDarkColor,
  ),
);

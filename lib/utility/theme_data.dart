import 'package:flutter/material.dart';

final themeDATA = ThemeData(
    primarySwatch: const MaterialColor(0xFFef6c36, color),
    primaryColor: const Color(0xFFef6c36),
    fontFamily: 'Noto Sans',
    // textTheme: TEXT_THEME,
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      labelStyle: const TextStyle(
        fontSize: 16,
      ),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      // border: InputBorder.none,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            // primary: Colors.white,
            // elevation: 3,
            // padding: EdgeInsets
            )));
const Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

// const TEXT_THEME = TextTheme(
    // subtitle1: TextStyle(fontSize: 18),
    // headline1: TextStyle(fontSize: 62.0, fontWeight: FontWeight.bold),
    // headline5: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w500),
    // headline6: TextStyle(fontSize: 32.0),
    // bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    // );
// const CARD_TITLE_TEXT = TextStyle(fontSize: )

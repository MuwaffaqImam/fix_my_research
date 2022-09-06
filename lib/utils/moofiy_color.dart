import 'package:flutter/material.dart';

class MoofiyColors {
  static const Color colorPrimaryRedCaramelDark = Color(0xFF7A370B);
  static const Color colorPrimaryRedCaramel = Color(0xFF864921);
  static const Color colorSecondaryGreenPlant = Color(0xFF4D6658);
  static const Color colorSurfaceSmoothGreenPlant = Color(0xFFFBFDF7);
  static const Color colorPrimaryLightRedCaramel = Color(0xFFF2EEE1);
  static const Color colorSecondaryLightGreenPlant = Color(0xFFE9F1E8);
  static const Color colorTextSmoothBlack = Color(0xFF49454F);
  static final themeData = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFF2EEE1),
    primaryColor: const Color(0xFF864921),
    primaryColorDark: const Color(0xFF7A370B),
    primaryColorLight: const Color(0xFFF2EEE1),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF2EEE1),
      titleTextStyle: TextStyle(
          color: Color(0xFF864921), fontSize: 50, fontFamily: 'Eczar'),
    ),
    hintColor: const Color(0xFF7A370B),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          onPrimary: const Color(0xFFE9F1E8),
          primary: const Color(0xFF864921),
          textStyle: const TextStyle(fontFamily: 'Eczar')),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFFFBFDF7), //0xFFF2EEE1
      filled: true,
      floatingLabelStyle: TextStyle(color: Color(0xFF864921)),
    ),
  );
}

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AppColors {
  // 32-bit integer
  static const red = Color(0xFFDB3022);
  // static const black = Color(0xFF222222);
  static const black = Color(0xFF414449);

  static const lightGray = Color(0xFF9B9B9B);
  static const darkGray = Color(0xFF979797);
  static const white = Color(0xFFFFFFFF);
  // static const background = Color(0xFFFFFFF0);
  static const background = Color(0xFFFBCEB1);

  static const backgroundLight = Color(0xFFF9F9F9);
  static const transparent = Color(0x00000000);
  static const success = Color(0xFF2AA952);
  static const green = Color(0xFF2AA952);
  // static const theme_color =Color(0xFFFF8D2F);
  // static const light_theme_color =Color(0xFFFFF0E3);
  // static const bs_teal= Color(0xFF198754);
  static const blue=Color(0xFF2661FA);
  static const redish_brown=Color(0xFFCC0000);
  static const waterDrops= Color(0xFF0066FF);

  static const theme_color =Color(0xFF2F539B);
  static const light_theme_color =Color(0xFF14A3C7);
  static const bs_teal= Color(0xFFC73814);

}
class AppSizes {
  static const int splashScreenTitleFontSize = 48;
  static const int titleFontSize = 34;
  static const double sidePadding = 15;
  static const double widgetSidePadding = 20;
  static const double buttonRadius = 25;
  static const double imageRadius = 8;
  static const double linePadding = 4;
  static const double widgetBorderRadius = 34;
  static const double textFieldRadius = 4.0;
  static const EdgeInsets bottomSheetPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 10);
  static const app_bar_size = 56.0;
  static const app_bar_expanded_size = 180.0;
  static const tile_width = 148.0;
  static const tile_height = 276.0;
}
class CustomerPortalTheme {
  static ThemeData of(BuildContext context) {
    var theme = Theme.of(context);
    // var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // Define themeColorText style


    return theme.copyWith(
      primaryColor: AppColors.black,
      primaryColorLight: AppColors.lightGray,
      bottomAppBarColor: AppColors.lightGray,
      backgroundColor: AppColors.background,
      dialogBackgroundColor: AppColors.backgroundLight,
      errorColor: AppColors.red,
      dividerColor: Colors.transparent,
      appBarTheme: theme.appBarTheme.copyWith(
        color: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.black),
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 20 ,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
        headline2: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 18 ,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        headline3: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 16 ,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        headline4: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 12 ,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        headline5: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 10 ,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        headline6: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 10 ,
          fontWeight: FontWeight.normal,
          color: AppColors.lightGray,
        ),
        subtitle1: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 14 ,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          color: AppColors.lightGray,
        ),
        subtitle2: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 10 ,
          fontWeight: FontWeight.normal,
          color: AppColors.black,
        ),

        bodyText1: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.theme_color,
        ),
        bodyText2: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 16 ,
          fontWeight: FontWeight.w500,
          color: AppColors.theme_color,
        ),
        button: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 14 ,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        ),
        caption: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 34 ,
          fontWeight: FontWeight.w700,
          color: AppColors.black,
        ),
      ),
      buttonTheme: theme.buttonTheme.copyWith(
        minWidth: 50 ,
        buttonColor: AppColors.red,
      ),
    );
  }
}

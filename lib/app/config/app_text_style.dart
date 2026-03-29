// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract class AppTextStyles {
  AppTextStyles._();

  static TextStyle customText({
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = 0,
    double fontSize = 12,
    double? height,
    String? fontFamily, // added
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static textStyleTextBotton({bool? isUnderline = true, String? fontFamily}) {
    return TextStyle(
      decoration: (isUnderline ?? true) ? TextDecoration.underline : null,
      color: AppColors.white.withOpacity(0.5),
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: 'Inter-Regular',
    );
  }

  static TextStyle customText10({
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = 0,
    double? height,
    String? fontFamily, // added
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 10,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle customText12({
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = 0,
    double? height,
    String? fontFamily, // added
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 12,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle customText14({
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = 0,
    double height = 1,
    TextDecoration decoration = TextDecoration.none,
    Color? decorationColor,
    String? fontFamily, // added
  }) {
    return GoogleFonts.plusJakartaSans(
      height: height,
      fontSize: 14,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  static TextStyle customText16({
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = 0,
    double? height,
    TextDecoration decoration = TextDecoration.none,
    Color? decorationColor,
    String? fontFamily, // added
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 16,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      decoration: decoration,
      height: height,
      decorationColor: decorationColor,
    );
  }

  static TextStyle customText32({
    List<Shadow>? shadow,
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = 0,
    TextDecoration decoration = TextDecoration.none,
    double? height,
    String? fontFamily, // added
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 32,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      decoration: decoration,
      height: height,
      shadows: shadow,
    );
  }

  static TextStyle customText40({
    List<Shadow>? shadow,
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = 0,
    TextDecoration decoration = TextDecoration.none,
    double? height,
    String? fontFamily, // added
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 40,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      decoration: decoration,
      height: height,
      shadows: shadow,
    );
  }

  static TextStyle customText18({
    Color? color,
    double? height = 1,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = 0,
    String? fontFamily, // added
  }) {
    return GoogleFonts.plusJakartaSans(
      height: height,
      fontSize: 18,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle customText20({
    List<Shadow>? shadow,
    Color? color,
    double? height = 1,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = 0,
    String? fontFamily, // added
  }) {
    return GoogleFonts.plusJakartaSans(
      height: height,
      fontSize: 18,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      shadows: shadow,
    );
  }

  static TextStyle customText22({
    List<Shadow>? shadow,
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = 0,
    double? height,
    String? fontFamily, // added
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 22,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      shadows: shadow,
    );
  }

  static TextStyle customText24({
    List<Shadow>? shadow,
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = 0,
    String? fontFamily, // added
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 24,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      shadows: shadow,
    );
  }

  static TextStyle customText26({
    List<Shadow>? shadow,
    double? height,
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = 0,
    String? fontFamily, // added
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 26,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      shadows: shadow,
      height: height,
    );
  }

  static TextStyle customText28({
    List<Shadow>? shadow,
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = 0,
    String? fontFamily, // added
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 28,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      shadows: shadow,
    );
  }
}

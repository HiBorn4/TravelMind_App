// /// Defines navigation routes for the LayerX app.
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'app_colors.dart';
//
// abstract class AppTheme {
//   static const _primaryColor = AppColors.primary;
//   static const _secondaryColor = AppColors.secondaryWhite;
//   static const _borderRadius = 12.0;
//   static const _buttonPadding = EdgeInsets.symmetric(vertical: 12, horizontal: 20);
//
//   // Container colors for light and dark themes
//   static const Color _lightContainerColor = AppColors.secondaryWhite; // For light theme containers
//   static const Color _darkContainerColor = AppColors.darkBgColor; // For dark theme containers
//
//   static const Color _lightScaffoldColor = AppColors.secondaryWhite;
//   static const Color _darkScaffoldColor = Color(0xff1B1C1E);
//
//   static final ThemeData lightTheme = ThemeData(
//     fontFamily: "Poppins",
//
//     brightness: Brightness.light,
//     primaryColor: _primaryColor,
//     scaffoldBackgroundColor: _lightScaffoldColor,
//     colorScheme: ColorScheme.light(primary: _primaryColor, secondary: _secondaryColor),
//     appBarTheme: _appBarTheme(_primaryColor, AppColors.textDarkColor),
//     // textTheme: _lightTextTheme,
//     cardColor: _lightContainerColor, // Light theme container color
//       elevatedButtonTheme: _elevatedButtonTheme(Brightness.light),
//     inputDecorationTheme: _inputDecorationTheme(AppColors.secondaryBlack, AppColors.textLightBlack),
//     iconTheme: IconThemeData(color: _primaryColor),
//     floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: _primaryColor, foregroundColor: AppColors.secondaryWhite),
//     bottomNavigationBarTheme: _bottomNavigationBarTheme(AppColors.bgColor, _primaryColor, AppColors.textDarkColor),
//     // cardTheme: _cardTheme(_lightContainerColor, AppColors.borderGrey), // Light theme card color
//     switchTheme: _switchTheme(_primaryColor),
//     checkboxTheme: _checkboxTheme(_primaryColor),
//     sliderTheme: _sliderTheme(_primaryColor),
//     // tabBarTheme: _tabBarTheme(_primaryColor, AppColors.textDarkColor),
//     progressIndicatorTheme: ProgressIndicatorThemeData(color: _primaryColor),
//     dividerTheme: DividerThemeData(color: AppColors.textLightBlack, thickness: 1),
//     tooltipTheme: TooltipThemeData(decoration: BoxDecoration(color: _primaryColor, borderRadius: BorderRadius.circular(_borderRadius))),
//     popupMenuTheme: PopupMenuThemeData(color: AppColors.secondaryWhite, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius))),
//   );
//
//   static final ThemeData darkTheme = ThemeData(
//     fontFamily: "Poppins",
//     brightness: Brightness.dark,
//     primaryColor: _primaryColor,
//     scaffoldBackgroundColor: _darkScaffoldColor,
//     colorScheme: ColorScheme.dark(primary: _primaryColor, secondary: _secondaryColor),
//     appBarTheme: _appBarTheme(AppColors.secondaryBlack, AppColors.secondaryWhite),
//     // textTheme: _darkTextTheme,
//     cardColor: _darkContainerColor, // Dark theme container color
//     elevatedButtonTheme: _elevatedButtonTheme(Brightness.dark),
//     inputDecorationTheme: _inputDecorationTheme(AppColors.secondaryBlack, AppColors.textLightBlack),
//     iconTheme: IconThemeData(color: AppColors.secondaryWhite),
//     floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: _primaryColor, foregroundColor: AppColors.secondaryWhite),
//     bottomNavigationBarTheme: _bottomNavigationBarTheme(AppColors.secondaryBlack, _primaryColor, AppColors.secondaryWhite),
//     // cardTheme: _cardTheme(_darkContainerColor, AppColors.textLightBlack), // Dark theme card color
//     switchTheme: _switchTheme(_primaryColor),
//     checkboxTheme: _checkboxTheme(_primaryColor),
//     sliderTheme: _sliderTheme(_primaryColor),
//     // tabBarTheme: _tabBarTheme(_primaryColor, AppColors.secondaryWhite),
//     progressIndicatorTheme: ProgressIndicatorThemeData(color: _primaryColor),
//     dividerTheme: DividerThemeData(color: AppColors.textLightBlack, thickness: 1),
//     tooltipTheme: TooltipThemeData(decoration: BoxDecoration(color: _primaryColor, borderRadius: BorderRadius.circular(_borderRadius))),
//     popupMenuTheme: PopupMenuThemeData(color: AppColors.secondaryBlack, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius))),
//   );
//
//   static AppBarTheme _appBarTheme(Color bgColor, Color fgColor) => AppBarTheme(
//     backgroundColor: bgColor,
//     foregroundColor: fgColor,
//     elevation: 3,
//     titleTextStyle: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.bold, color: fgColor),
//   );
//
//   static BottomNavigationBarThemeData _bottomNavigationBarTheme(Color bgColor, Color selected, Color unselected) => BottomNavigationBarThemeData(
//     backgroundColor: bgColor,
//     selectedItemColor: selected,
//     unselectedItemColor: unselected,
//   );
//
//   static final TextTheme _lightTextTheme = TextTheme(
//     displayLarge: GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.bold, color: AppColors.textDarkColor),
//     displayMedium: GoogleFonts.poppins(fontSize: 22.sp, fontWeight: FontWeight.normal, color: AppColors.textDarkColor),
//     bodyLarge: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.normal, color: AppColors.textDarkColor),
//     bodyMedium: GoogleFonts.poppins(fontSize: 14.sp, color: AppColors.textLightBlack),
//   );
//
//   static final TextTheme _darkTextTheme = TextTheme(
//     displayLarge: GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.bold, color: AppColors.secondaryWhite),
//     displayMedium: GoogleFonts.poppins(fontSize: 22.sp, fontWeight: FontWeight.normal, color: AppColors.secondaryWhite),
//     bodyLarge: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.normal, color: AppColors.secondaryWhite),
//     bodyMedium: GoogleFonts.poppins(fontSize: 14.sp, color: AppColors.textLightBlack),
//   );
//
//   static ElevatedButtonThemeData _elevatedButtonTheme(Brightness brightness) {
//     return ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: brightness == Brightness.dark ? AppColors.borderGrey : _primaryColor,
//         foregroundColor: AppColors.secondaryWhite,
//         textStyle: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w600),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
//         padding: _buttonPadding,
//       ),
//     );
//   }
//
//   static InputDecorationTheme _inputDecorationTheme(Color fillColor, Color hintColor) => InputDecorationTheme(
//     filled: true,
//     fillColor: fillColor,
//     border: OutlineInputBorder(borderRadius: BorderRadius.circular(_borderRadius)),
//     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: _primaryColor, width: 2), borderRadius: BorderRadius.circular(_borderRadius)),
//     hintStyle: GoogleFonts.poppins(color: hintColor),
//   );
//
//   static CardTheme _cardTheme(Color bgColor, Color shadowColor) => CardTheme(
//     color: bgColor,
//     shadowColor: shadowColor,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
//     elevation: 4,
//   );
//
//   static SwitchThemeData _switchTheme(Color activeColor) => SwitchThemeData(
//     trackColor: MaterialStateProperty.resolveWith<Color>((states) => states.contains(MaterialState.selected) ? activeColor : Colors.grey),
//     thumbColor: MaterialStateProperty.all(AppColors.secondaryWhite),
//   );
//
//   static CheckboxThemeData _checkboxTheme(Color activeColor) => CheckboxThemeData(
//     checkColor: MaterialStateProperty.all(AppColors.secondaryWhite),
//     fillColor: MaterialStateProperty.all(activeColor),
//   );
//
//   static SliderThemeData _sliderTheme(Color activeColor) => SliderThemeData(
//     activeTrackColor: activeColor,
//     inactiveTrackColor: activeColor.withOpacity(0.5),
//     thumbColor: activeColor,
//     overlayColor: activeColor.withOpacity(0.2),
//     valueIndicatorColor: activeColor,
//   );
//
//   static TabBarTheme _tabBarTheme(Color indicatorColor, Color labelColor) => TabBarTheme(
//     indicator: BoxDecoration(border: Border(bottom: BorderSide(color: indicatorColor, width: 2))),
//     labelColor: labelColor,
//     unselectedLabelColor: AppColors.textLightBlack,
//   );
// }

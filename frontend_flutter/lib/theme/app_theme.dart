import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sistem Tema Aplikasi [AppTheme] yang mendefinisikan palet warna modern,
/// tipografi Google Fonts Inter, dan konfigurasi tema komponen Flutter.
class AppTheme {
  /// Warna utama aplikasi (Vibrant Automotive Orange)
  static const Color primaryColor = Color(0xFFFF5722);

  /// Warna sekunder aplikasi (Yamaha Racing Blue)
  static const Color secondaryColor = Color(0xFF2563EB);

  /// Warna latar belakang halaman (Clean White)
  static const Color backgroundColor = Color(0xFFFFFFFF);

  /// Warna permukaan kontainer/card (Soft Light Gray)
  static const Color surfaceColor = Color(0xFFF8F9FA);

  /// Warna teks utama (Slate Black)
  static const Color textDark = Color(0xFF0F172A);

  /// Warna teks sekunder/deskripsi (Slate Gray)
  static const Color textMuted = Color(0xFF64748B);

  /// Warna garis batas (Subtle Border)
  static const Color borderColor = Color(0xFFE2E8F0);

  /// Definisi [ThemeData] mode terang (Light Theme) yang digunakan di seluruh aplikasi.
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      onPrimary: Colors.white,
      onSurface: textDark,
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      headlineMedium: GoogleFonts.inter(
        color: textDark,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      titleLarge: GoogleFonts.inter(
        color: textDark,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
      bodyLarge: GoogleFonts.inter(
        color: textDark,
        fontSize: 15,
      ),
      bodyMedium: GoogleFonts.inter(
        color: textMuted,
        fontSize: 13,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: textDark),
      titleTextStyle: TextStyle(
        color: textDark,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: borderColor, width: 1),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      labelStyle: const TextStyle(color: textMuted),
      hintStyle: const TextStyle(color: textMuted),
    ),
  );
}

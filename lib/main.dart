import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(MaterialApp(
    title: 'Recipe Generator',
    theme: ThemeData(
      primaryColor: Color(0xFF37474F),
      scaffoldBackgroundColor: Color(0xFFF5F5DC),
      colorScheme: ColorScheme.light(
        primary: Color(0xFF37474F),
        secondary: Color(0xFF66BB6A),
        surface: Color(0xFFF5F5DC),
        onPrimary: Color(0xFFECEFF1),
        onSurface: Color(0xFF37474F),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFF7043),
          foregroundColor: Color(0xFFECEFF1),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Color(0xFF66BB6A),
          foregroundColor: Color(0xFFECEFF1),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF37474F)),
        bodyMedium: TextStyle(color: Color(0xFF37474F)),
      ),
    ),
    home: LoginPage(),
  ));
}

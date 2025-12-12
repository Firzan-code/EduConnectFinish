import 'package:flutter/material.dart';
import 'pages/splash_page.dart';
// import 'dart:io'; // Pastikan import ini ada
// import file lainnya...

const primaryColor = Color(0xFF6C5CE7);
const accentColor = Color(0xFF8E7BFF);

void main() {
  // HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Learning Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      ),
      home: const SplashPage(),
    );
  }
}

/// Fungsi animasi navigasi antar halaman
Route createRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 520),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, sec, child) {
      final tween = Tween(
        begin: const Offset(0, 0.08),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOut));
      final opacity = Tween<double>(begin: 0, end: 1).animate(animation);
      return FadeTransition(
        opacity: opacity,
        child: SlideTransition(position: animation.drive(tween), child: child),
      );
    },
  );
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

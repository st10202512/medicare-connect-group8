import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/web/web_home_screen.dart';
import 'screens/web/web_login_screen.dart';
import 'screens/web/web_about_screen.dart';
import 'screens/web/web_services_screen.dart';
import 'screens/web/web_contact_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MediCareWebApp());
}

class MediCareWebApp extends StatelessWidget {
  const MediCareWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediCare Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00897B)),
        useMaterial3: true,
        fontFamily: 'Segoe UI',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00897B),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WebHomeScreen(),
        '/login': (context) => const WebLoginScreen(),
        '/about': (context) => const WebAboutScreen(),
        '/services': (context) => const WebServicesScreen(),
        '/contact': (context) => const WebContactScreen(),
      },
    );
  }
}
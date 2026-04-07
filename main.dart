import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const NoveApp());
}

class NoveApp extends StatelessWidget {
  const NoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nove Fashion',

      home: SplashScreen(),
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1714), // Dark Background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gold Circle Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFC5A358), width: 1.5),
              ),
              child: const Center(
                child: Text(
                  'N',
                  style: TextStyle(
                    fontSize: 50,
                    color: Color(0xFFC5A358),
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'N O V E',
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                letterSpacing: 6,
              ),
            ),
            const Text(
              'CURATED FASHION',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 50),
            // Loading Bar
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: LinearProgressIndicator(
                backgroundColor: Color(0xFF212121),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC5A358)),
                minHeight: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

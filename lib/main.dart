import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'repositories/kaza_repository.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = KazaRepository();
  await repository.init();

  runApp(MainApp(repository: repository));
}

class MainApp extends StatelessWidget {
  final KazaRepository repository;

  const MainApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(
          0xFF111827,
        ), // Deep simplistic dark
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10B981), // Emerald
          brightness: Brightness.dark,
          surface: const Color(0xFF1F2937),
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      ),
      home: repository.isFirstRun
          ? OnboardingScreen(repository: repository)
          : HomeScreen(repository: repository),
    );
  }
}

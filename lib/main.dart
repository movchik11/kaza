import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'repositories/kaza_repository.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final repository = KazaRepository();
  await repository.init();

  final notificationService = NotificationService();
  await notificationService.init();
  // Request permissions immediately or let user do it in settings?
  // Good practice to do it when needed, but for MVP let's do it here or in settings.
  await notificationService.requestPermissions();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru'), Locale('tk')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MainApp(
        repository: repository,
        notificationService: notificationService,
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  final KazaRepository repository;
  final NotificationService notificationService;

  const MainApp({
    super.key,
    required this.repository,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
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
          ? OnboardingScreen(
              repository: repository,
              notificationService: notificationService,
            )
          : HomeScreen(
              repository: repository,
              notificationService: notificationService,
            ),
    );
  }
}

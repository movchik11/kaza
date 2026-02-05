import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ...context.localizationDelegates,
      ],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Modern deep slate
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10B981),
          brightness: Brightness.dark,
          surface: const Color(0xFF1E293B),
          primary: const Color(0xFF10B981),
          secondary: const Color(0xFF3B82F6),
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E293B),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
          ),
        ),
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

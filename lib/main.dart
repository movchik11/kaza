import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/kaza_repository.dart';
import 'services/notification_service.dart';
import 'services/content_service.dart';
import 'cubit/kaza_cubit.dart';
import 'cubit/kaza_state.dart';
import 'cubit/settings_cubit.dart';
import 'cubit/settings_state.dart';
import 'cubit/tasbih_cubit.dart';
import 'screens/home_screen.dart';
import 'screens/language_selection_screen.dart';
import 'widgets/lock_wrapper.dart';
import 'services/theme_service.dart';
import 'services/prayer_times_service.dart';
import 'package:adhan/adhan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final repository = KazaRepository();
  await repository.init();

  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermissions();

  await ContentService.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ru'), Locale('tk')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ru'),
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<KazaCubit>(
          create: (_) => KazaCubit(repository)..loadData(),
        ),
        BlocProvider<SettingsCubit>(
          create: (_) =>
              SettingsCubit(repository, notificationService)..loadSettings(),
        ),
        BlocProvider<TasbihCubit>(
          create: (_) => TasbihCubit(repository: repository),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return FutureBuilder<PrayerTimes?>(
            future: PrayerTimesService.getPrayerTimes(),
            builder: (context, snapshot) {
              ThemePreset lightPreset;
              ThemePreset darkPreset;

              if (settingsState.useDynamicTheme) {
                final dyn = ThemeService.getDynamicPreset(
                  DateTime.now(),
                  prayers: snapshot.data,
                );
                lightPreset = ThemePreset(
                  name: dyn.name,
                  primary: dyn.primary,
                  secondary: dyn.secondary,
                  brightness: Brightness.light,
                );
                darkPreset = ThemePreset(
                  name: dyn.name,
                  primary: dyn.primary,
                  secondary: dyn.secondary,
                  brightness: Brightness.dark,
                );
              } else {
                lightPreset = ThemePreset(
                  name: 'Light',
                  primary: Color(settingsState.seedColor),
                  secondary: const Color(0xFF3B82F6),
                  brightness: Brightness.light,
                );
                darkPreset = ThemePreset(
                  name: 'Dark',
                  primary: Color(settingsState.seedColor),
                  secondary: const Color(0xFF3B82F6),
                  brightness: Brightness.dark,
                );
              }

              final lightTheme = ThemeService.getThemeData(lightPreset);
              final darkTheme = ThemeService.getThemeData(darkPreset);

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                themeMode: settingsState.themeMode,
                theme: lightTheme.copyWith(
                  textTheme: GoogleFonts.outfitTextTheme(lightTheme.textTheme),
                ),
                darkTheme: darkTheme.copyWith(
                  textTheme: GoogleFonts.outfitTextTheme(darkTheme.textTheme),
                ),
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  FallbackLocalizationDelegate(),
                  ...context.localizationDelegates,
                ],
                localeResolutionCallback: (locale, supportedLocales) {
                  return locale;
                },
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: BlocBuilder<KazaCubit, KazaState>(
                  builder: (context, kazaState) {
                    final cubit = context.read<KazaCubit>();
                    if (cubit.isFirstRun) {
                      return LanguageSelectionScreen(
                        repository: repository,
                        notificationService: notificationService,
                      );
                    }
                    return LockWrapper(
                      child: HomeScreen(
                        repository: repository,
                        notificationService: notificationService,
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class FallbackLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  @override
  bool isSupported(Locale locale) => locale.languageCode == 'tk';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    return const DefaultMaterialLocalizations();
  }

  @override
  bool shouldReload(FallbackLocalizationDelegate old) => false;
}

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/interaction_utils.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../repositories/kaza_repository.dart';
import '../services/notification_service.dart';
import '../services/backup_service.dart';
import '../services/export_service.dart';
import '../cubit/kaza_cubit.dart';
import '../screens/shop_screen.dart';

class SettingsTab extends StatefulWidget {
  final KazaRepository repository;
  final NotificationService notificationService;
  const SettingsTab({
    super.key,
    required this.repository,
    required this.notificationService,
  });

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  late BackupService _backupService;

  @override
  void initState() {
    super.initState();
    _backupService = BackupService(widget.repository);
  }

  void _changeLanguage(Locale? locale) {
    if (locale != null) {
      InteractionUtils.haptic(context);
      context.setLocale(locale);
    }
  }

  Future<void> _pickTime(SettingsCubit cubit, SettingsState state) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: state.reminderHour,
        minute: state.reminderMinute,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.black,
              surface: const Color(0xFF1E293B),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (!mounted) return;
      InteractionUtils.haptic(context);
      await cubit.setReminderTime(picked.hour, picked.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  "settings.title".tr(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                // Theme Section
                _buildSection('settings.appearance'.tr(), [
                  _buildSettingTile(
                    icon: Icons.dark_mode_rounded,
                    title: 'settings.theme'.tr(),
                    subtitle: _getThemeName(state.themeMode),
                    onTap: () => _showThemeDialog(context, cubit, state),
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildSettingTile(
                    icon: Icons.storefront_rounded,
                    title: 'shop.title'.tr(),
                    subtitle: 'shop.subtitle'.tr(),
                    onTap: () {
                      InteractionUtils.haptic(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShopScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSettingTile(
                    icon: Icons.auto_awesome_rounded,
                    title: 'settings.dynamicTheme'.tr(),
                    subtitle: 'settings.dynamicThemeSubtitle'.tr(),
                    trailing: Switch(
                      value: state.useDynamicTheme,
                      onChanged: (value) {
                        InteractionUtils.haptic(context);
                        cubit.toggleDynamicTheme(value);
                      },
                      activeTrackColor: colorScheme.primary,
                      activeThumbColor: Colors.white,
                    ),
                  ),
                ]),
                const SizedBox(height: 24),

                // Profile Section
                _buildSection('settings.gender'.tr(), [
                  _buildSettingTile(
                    icon: Icons.person_outline_rounded,
                    title: 'onboarding.gender'.tr(),
                    subtitle: state.gender == 'female'
                        ? 'onboarding.female'.tr()
                        : (state.gender == 'male'
                              ? 'onboarding.male'.tr()
                              : '-'),
                    onTap: () => _showGenderDialog(context, cubit, state),
                  ),
                  _buildSettingTile(
                    icon: Icons.history_edu_rounded,
                    title: 'settings.ageStarted'.tr(),
                    subtitle: state.ageStartedPraying?.toString() ?? '-',
                    onTap: () => _showAgeDialog(context, cubit, state),
                  ),
                  _buildSettingTile(
                    icon: Icons.location_on_outlined,
                    title: 'settings.location'.tr(),
                    subtitle: state.locationName ?? 'common.noData'.tr(),
                    onTap: () => _showLocationDialog(context, cubit, state),
                  ),
                ]),
                const SizedBox(height: 24),

                // Language Section
                _buildSection('settings.language'.tr(), [
                  _buildLanguageDropdownTile(context),
                ]),
                const SizedBox(height: 24),

                // Reminders Section
                _buildSection('settings.reminders'.tr(), [
                  _buildSettingTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'settings.reminders'.tr(),
                    trailing: Switch(
                      value: state.notificationsEnabled,
                      onChanged: (value) {
                        InteractionUtils.haptic(context);
                        cubit.toggleNotifications(value);
                      },
                      activeTrackColor: colorScheme.primary,
                      activeThumbColor: Colors.white,
                    ),
                  ),
                  _buildSettingTile(
                    icon: Icons.access_time_rounded,
                    title: 'settings.reminderTime'.tr(),
                    subtitle: TimeOfDay(
                      hour: state.reminderHour,
                      minute: state.reminderMinute,
                    ).format(context),
                    onTap: () => _pickTime(cubit, state),
                    enabled: state.notificationsEnabled,
                  ),
                  _buildSettingTile(
                    icon: Icons.timer_outlined,
                    title: 'settings.reminderOffset'.tr(),
                    subtitle:
                        '${state.reminderOffset} ${"settings.minutes".tr()}',
                    onTap: () => _showOffsetDialog(context, cubit, state),
                    enabled: state.notificationsEnabled,
                  ),
                  _buildSettingTile(
                    icon: Icons.do_not_disturb_on_rounded,
                    title: 'settings.silentHours'.tr(),
                    subtitle:
                        '${state.silentHoursStart}:00 - ${state.silentHoursEnd}:00',
                    onTap: () => _showSilentHoursDialog(context, cubit, state),
                    enabled: state.notificationsEnabled,
                  ),
                ]),
                const SizedBox(height: 24),

                // Interaction Section
                _buildSection('settings.interaction'.tr(), [
                  _buildSettingTile(
                    icon: Icons.volume_up_rounded,
                    title: 'settings.sound'.tr(),
                    trailing: Switch(
                      value: state.soundEnabled,
                      onChanged: (value) {
                        InteractionUtils.haptic(context);
                        cubit.toggleSound(value);
                      },
                      activeTrackColor: colorScheme.primary,
                      activeThumbColor: Colors.white,
                    ),
                  ),
                  _buildSettingTile(
                    icon: Icons.vibration_rounded,
                    title: 'settings.vibration'.tr(),
                    trailing: Switch(
                      value: state.vibrationEnabled,
                      onChanged: (value) {
                        InteractionUtils.haptic(context);
                        cubit.toggleVibration(value);
                      },
                      activeTrackColor: colorScheme.primary,
                      activeThumbColor: Colors.white,
                    ),
                  ),
                ]),
                const SizedBox(height: 24),

                // Privacy Section
                _buildSection('privacy.title'.tr(), [
                  _buildSettingTile(
                    icon: Icons.fingerprint_rounded,
                    title: 'privacy.lock'.tr(),
                    subtitle: 'privacy.lockSubtitle'.tr(),
                    trailing: Switch(
                      value: state.biometricLockEnabled,
                      onChanged: (value) async {
                        InteractionUtils.haptic(context);
                        cubit.toggleBiometricLock(value);
                      },
                      activeTrackColor: colorScheme.primary,
                      activeThumbColor: Colors.white,
                    ),
                  ),
                ]),
                const SizedBox(height: 24),

                // Backup & Export Section
                _buildSection('settings.backup'.tr(), [
                  _buildSettingTile(
                    icon: Icons.picture_as_pdf_rounded,
                    title: 'settings.exportPdf'.tr(),
                    subtitle: 'settings.exportPdfSubtitle'.tr(),
                    onTap: () {
                      final data = context.read<KazaCubit>().state.data;
                      ExportService.exportPdf(data);
                    },
                  ),
                  _buildSettingTile(
                    icon: Icons.data_object_rounded,
                    title: 'settings.exportJson'.tr(),
                    subtitle: 'settings.exportJsonSubtitle'.tr(),
                    onTap: () {
                      final data = context.read<KazaCubit>().state.data;
                      ExportService.exportJson(data);
                    },
                  ),
                  _buildSettingTile(
                    icon: Icons.download_rounded,
                    title: 'settings.import'.tr(),
                    onTap: () async {
                      InteractionUtils.haptic(context);
                      final success = await _backupService.importData();
                      if (!context.mounted) return;
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("settings.importSuccess".tr()),
                          ),
                        );
                      }
                    },
                  ),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showThemeDialog(
    BuildContext context,
    SettingsCubit cubit,
    SettingsState state,
  ) {
    InteractionUtils.mediumImpact(context);
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'settings.theme'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildThemeOption(
                ctx,
                cubit,
                ThemeMode.light,
                'settings.lightTheme'.tr(),
                state,
              ),
              _buildThemeOption(
                ctx,
                cubit,
                ThemeMode.dark,
                'settings.darkTheme'.tr(),
                state,
              ),
              _buildThemeOption(
                ctx,
                cubit,
                ThemeMode.system,
                'settings.systemTheme'.tr(),
                state,
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    SettingsCubit cubit,
    ThemeMode mode,
    String label,
    SettingsState state,
  ) {
    final isSelected = state.themeMode == mode;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: () {
        InteractionUtils.haptic(context);
        cubit.toggleTheme(mode);
        Navigator.pop(context);
      },
      leading: Icon(
        mode == ThemeMode.light
            ? Icons.light_mode
            : mode == ThemeMode.dark
            ? Icons.dark_mode
            : Icons.brightness_auto,
        color: isSelected ? colorScheme.primary : null,
      ),
      title: Text(label),
      trailing: isSelected
          ? Icon(Icons.check, color: colorScheme.primary)
          : null,
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(children: children),
        ),
      ],
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool enabled = true,
  }) {
    return ListTile(
      enabled: enabled,
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing:
          trailing ??
          (onTap != null ? const Icon(Icons.chevron_right, size: 20) : null),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    );
  }

  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'settings.lightTheme'.tr();
      case ThemeMode.dark:
        return 'settings.darkTheme'.tr();
      case ThemeMode.system:
        return 'settings.systemTheme'.tr();
    }
  }

  Widget _buildLanguageDropdownTile(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentLocale = context.locale;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.language, color: colorScheme.primary, size: 20),
      ),
      title: Text(
        'settings.language'.tr(),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<Locale>(
          value: currentLocale,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          dropdownColor: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          items: [
            DropdownMenuItem(
              value: const Locale('ru'),
              child: Text(_getLangName(const Locale('ru'))),
            ),
            DropdownMenuItem(
              value: const Locale('tk'),
              child: Text(_getLangName(const Locale('tk'))),
            ),
          ],
          onChanged: _changeLanguage,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    );
  }

  void _showOffsetDialog(
    BuildContext context,
    SettingsCubit cubit,
    SettingsState state,
  ) {
    final offsets = [0, 5, 10, 15, 30, 45, 60];
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('settings.reminderOffset'.tr()),
        children: offsets
            .map(
              (o) => SimpleDialogOption(
                onPressed: () {
                  cubit.setReminderOffset(o);
                  Navigator.pop(context);
                },
                child: Text('$o ${"settings.minutes".tr()}'),
              ),
            )
            .toList(),
      ),
    );
  }

  void _showSilentHoursDialog(
    BuildContext context,
    SettingsCubit cubit,
    SettingsState state,
  ) {
    // Simplified: Just selecting hour for start/end
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('settings.silentHours'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Start'),
              trailing: Text('${state.silentHoursStart}:00'),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: state.silentHoursStart,
                    minute: 0,
                  ),
                );
                if (time != null) {
                  cubit.setSilentHours(time.hour, state.silentHoursEnd);
                }
              },
            ),
            ListTile(
              title: const Text('End'),
              trailing: Text('${state.silentHoursEnd}:00'),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: state.silentHoursEnd, minute: 0),
                );
                if (time != null) {
                  cubit.setSilentHours(state.silentHoursStart, time.hour);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showGenderDialog(
    BuildContext context,
    SettingsCubit cubit,
    SettingsState state,
  ) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('onboarding.gender'.tr()),
        children: [
          SimpleDialogOption(
            onPressed: () {
              cubit.saveProfile(gender: 'male');
              Navigator.pop(context);
            },
            child: Text('onboarding.male'.tr()),
          ),
          SimpleDialogOption(
            onPressed: () {
              cubit.saveProfile(gender: 'female');
              Navigator.pop(context);
            },
            child: Text('onboarding.female'.tr()),
          ),
        ],
      ),
    );
  }

  void _showAgeDialog(
    BuildContext context,
    SettingsCubit cubit,
    SettingsState state,
  ) {
    final controller = TextEditingController(
      text: state.ageStartedPraying?.toString() ?? '',
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('settings.ageStarted'.tr()),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'settings.ageStarted'.tr()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              final age = int.tryParse(controller.text);
              if (age != null) cubit.saveProfile(ageStartedPraying: age);
              Navigator.pop(context);
            },
            child: Text('common.save'.tr()),
          ),
        ],
      ),
    );
  }

  void _showLocationDialog(
    BuildContext context,
    SettingsCubit cubit,
    SettingsState state,
  ) {
    final controller = TextEditingController(text: state.locationName ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('settings.location'.tr()),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'settings.location'.tr()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              cubit.saveProfile(
                locationName: controller.text.trim().isEmpty
                    ? null
                    : controller.text.trim(),
              );
              Navigator.pop(context);
            },
            child: Text('common.save'.tr()),
          ),
        ],
      ),
    );
  }

  String _getLangName(Locale locale) {
    switch (locale.languageCode) {
      case 'ru':
        return 'Русский';
      case 'tk':
        return 'Türkmen';
      default:
        return 'Русский';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../repositories/kaza_repository.dart';
import '../services/notification_service.dart';
import '../services/backup_service.dart';

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
  bool _notificationsEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);

  @override
  void initState() {
    super.initState();
    _backupService = BackupService(widget.repository);
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await widget.repository.getNotificationSettings();
    setState(() {
      _notificationsEnabled = settings['enabled'];
      _reminderTime = TimeOfDay(
        hour: settings['hour'],
        minute: settings['minute'],
      );
    });
  }

  void _toggleLanguage() {
    if (context.locale == const Locale('en')) {
      context.setLocale(const Locale('ru'));
    } else if (context.locale == const Locale('ru')) {
      context.setLocale(const Locale('tk'));
    } else {
      context.setLocale(const Locale('en'));
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
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
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
      if (_notificationsEnabled) {
        await widget.notificationService.scheduleDailyReminder(picked);
      }
      await widget.repository.saveNotificationSettings(
        _notificationsEnabled,
        picked.hour,
        picked.minute,
      );
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() {
      _notificationsEnabled = value;
    });
    if (value) {
      await widget.notificationService.scheduleDailyReminder(_reminderTime);
    } else {
      await widget.notificationService.cancelNotifications();
    }
    await widget.repository.saveNotificationSettings(
      value,
      _reminderTime.hour,
      _reminderTime.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              "settings.title".tr(),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            _buildSection('settings.language'.tr(), [
              _buildSettingTile(
                icon: Icons.language,
                title: _getLangName(context.locale),
                onTap: _toggleLanguage,
                trailing: const Icon(Icons.translate, size: 20),
              ),
            ]),
            const SizedBox(height: 24),

            _buildSection('settings.reminders'.tr(), [
              _buildSettingTile(
                icon: Icons.notifications_none_rounded,
                title: 'settings.reminders'.tr(),
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: _toggleNotifications,
                  activeTrackColor: colorScheme.primary,
                  activeThumbColor: Colors.white,
                ),
              ),
              _buildSettingTile(
                icon: Icons.access_time_rounded,
                title: 'settings.reminderTime'.tr(),
                subtitle: _reminderTime.format(context),
                onTap: _pickTime,
                enabled: _notificationsEnabled,
              ),
            ]),
            const SizedBox(height: 24),

            _buildSection('settings.backup'.tr(), [
              _buildSettingTile(
                icon: Icons.upload_rounded,
                title: 'settings.export'.tr(),
                onTap: _backupService.exportData,
              ),
              _buildSettingTile(
                icon: Icons.download_rounded,
                title: 'settings.import'.tr(),
                onTap: () async {
                  final success = await _backupService.importData();
                  if (!context.mounted) return;
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("settings.importSuccess".tr())),
                    );
                  }
                },
              ),
            ]),
          ],
        ),
      ),
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

  String _getLangName(Locale locale) {
    switch (locale.toString()) {
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      case 'tk':
        return 'Türkmen';
      default:
        return 'English';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
  bool _notificationsEnabled = false; // logic needed to persist this pref?
  // For now we assume enabled if we have scheduled something or just a local toggle.
  // Ideally use SharedPreferences or Hive.
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
              surface: const Color(0xFF1F2937),
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
              "nav.settings".tr(),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // Language
            _buildSectionHeader("Language"),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_getLangName(context.locale)),
              leading: Icon(Icons.language, color: colorScheme.primary),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: _toggleLanguage,
            ),
            const Divider(color: Colors.white10),

            const SizedBox(height: 24),

            // Notifications
            _buildSectionHeader("Reminders"),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Daily Reminder"),
              subtitle: Text(_reminderTime.format(context)),
              leading: Icon(
                Icons.notifications_active_outlined,
                color: colorScheme.primary,
              ),
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: _toggleNotifications,
                activeTrackColor: colorScheme.primary,
                activeColor: Colors
                    .white, // activeThumbColor not available in all versions, checking.
                // activeColor is for thumb. activeTrackColor for track.
                // Deprecation warning said activeColor -> activeThumbColor.
                // Let's rely on standard colors or ignore if needed, but attempt fix.
                // Use activeThumbColor?
              ),
              onTap: _pickTime,
            ),
            const Divider(color: Colors.white10),

            const SizedBox(height: 24),

            // Data
            _buildSectionHeader("Data"),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Export Data"),
              leading: Icon(Icons.upload_file, color: colorScheme.primary),
              onTap: _backupService.exportData,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Import Data"),
              leading: Icon(Icons.download, color: colorScheme.primary),
              onTap: () async {
                final success = await _backupService.importData();
                if (success) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Data imported successfully. Please restart app.",
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
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

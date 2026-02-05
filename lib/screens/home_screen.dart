import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../repositories/kaza_repository.dart';
import '../tabs/prayers_tab.dart';
import '../tabs/fasting_tab.dart';
import '../tabs/settings_tab.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  final KazaRepository repository;
  final NotificationService notificationService;
  const HomeScreen({
    super.key,
    required this.repository,
    required this.notificationService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      PrayersTab(repository: widget.repository),
      FastingTab(repository: widget.repository),
      SettingsTab(
        repository: widget.repository,
        notificationService: widget.notificationService,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _tabs),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) =>
              setState(() => _selectedIndex = index),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          indicatorColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.1),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 70,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.mosque_outlined, size: 24),
              selectedIcon: Icon(
                Icons.mosque,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              label: 'nav.prayers'.tr(),
            ),
            NavigationDestination(
              icon: const Icon(Icons.wb_sunny_outlined, size: 24),
              selectedIcon: Icon(
                Icons.wb_sunny,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              label: 'nav.fasting'.tr(),
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined, size: 24),
              selectedIcon: Icon(
                Icons.settings,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              label: 'nav.settings'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}

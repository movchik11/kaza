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
  int _currentIndex = 0;
  late final List<Widget> _tabs;

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
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.mosque_outlined),
            selectedIcon: const Icon(Icons.mosque),
            label: 'nav.prayers'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.wb_sunny_outlined),
            selectedIcon: const Icon(Icons.wb_sunny),
            label: 'nav.fasting'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: 'nav.settings'.tr(),
          ),
        ],
      ),
    );
  }
}

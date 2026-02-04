import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/kaza_model.dart';
import '../repositories/kaza_repository.dart';
import 'home_screen.dart';
import '../services/notification_service.dart';

class OnboardingScreen extends StatefulWidget {
  final KazaRepository repository;
  final NotificationService notificationService;
  const OnboardingScreen({
    super.key,
    required this.repository,
    required this.notificationService,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _yearsController = TextEditingController();
  final _fastingController = TextEditingController();
  DateTime? _pubertyDate;
  bool _isByDate = false;

  void _submit() async {
    int totalDays = 0;

    if (_isByDate) {
      if (_pubertyDate == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('error.selectDate'.tr())));
        return;
      }
      final now = DateTime.now();
      totalDays = now.difference(_pubertyDate!).inDays;
      if (totalDays < 0) totalDays = 0;
    } else {
      if (_yearsController.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('error.enterYears'.tr())));
        return;
      }
      final years =
          double.tryParse(_yearsController.text.replaceAll(',', '.')) ?? 0;
      totalDays = (years * 365.25).ceil();
    }

    final fastingYears =
        double.tryParse(_fastingController.text.replaceAll(',', '.')) ?? 0;
    final totalFasting = (fastingYears * 30).ceil(); // Approx 30 days per year

    // Create model
    final model = KazaModel(
      fajr: totalDays,
      dhuhr: totalDays,
      asr: totalDays,
      maghrib: totalDays,
      isha: totalDays,
      witr: totalDays,
      fasting: totalFasting,
      initialFasting: totalFasting,
    );

    await widget.repository.setInitialData(model);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            repository: widget.repository,
            notificationService: widget.notificationService,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'onboarding.bismillah'.tr(),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn().moveY(begin: -20, end: 0),

              const SizedBox(height: 16),

              Text(
                'onboarding.subtitle'.tr(),
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[400]),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 48),

              // Toggle
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isByDate = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isByDate
                                ? colorScheme.primary.withAlpha(51)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'onboarding.byYears'.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: !_isByDate
                                  ? colorScheme.primary
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isByDate = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isByDate
                                ? colorScheme.primary.withAlpha(51)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'onboarding.byDate'.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _isByDate
                                  ? colorScheme.primary
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 32),

              if (!_isByDate) ...[
                TextField(
                  controller: _yearsController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'onboarding.yearsHint'.tr(),
                    suffixText: 'e.g. Years',
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ).animate().scale(),

                const SizedBox(height: 16),

                TextField(
                  controller: _fastingController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'onboarding.fastingYears'.tr(),
                    hintText: '0',
                    suffixText: 'Years',
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ).animate().scale(delay: 100.ms),
              ] else ...[
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2010),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: colorScheme.primary,
                              onPrimary: Colors.black,
                              surface: const Color(0xFF1F2937),
                              onSurface: Colors.white,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (date != null) {
                      setState(() => _pubertyDate = date);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today, color: colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          _pubertyDate == null
                              ? 'onboarding.selectDate'.tr()
                              : DateFormat(
                                  'MMMM d, yyyy',
                                ).format(_pubertyDate!),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ).animate().scale(),
              ],

              const Spacer(),

              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'onboarding.start'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms).moveY(begin: 20, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

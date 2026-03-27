import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/kaza_model.dart';
import '../repositories/kaza_repository.dart';
import '../cubit/settings_cubit.dart';
import 'home_screen.dart';
import '../services/notification_service.dart';
import '../services/interaction_service.dart';

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
  final _currentAgeController = TextEditingController();
  final _startedAgeController = TextEditingController(text: '12');
  String _gender = 'male';

  void _submit() async {
    InteractionService.tap();
    final currentAge = int.tryParse(_currentAgeController.text) ?? 0;
    final startedAge = int.tryParse(_startedAgeController.text) ?? 0;

    if (currentAge == 0 || startedAge == 0 || currentAge <= startedAge) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('onboarding.invalidAge'.tr())));
      return;
    }

    final missedYears = currentAge - startedAge;
    int totalDays = (missedYears * 365.25).ceil();
    int totalFasting = (missedYears * 30).ceil();

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

    final settingsCubit = context.read<SettingsCubit>();

    await widget.repository.setInitialData(model);

    if (!mounted) return;

    await settingsCubit.saveProfile(
      gender: _gender,
      ageStartedPraying: startedAge,
    );

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          repository: widget.repository,
          notificationService: widget.notificationService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withValues(alpha: 0.15),
              const Color(0xFF0B1120),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28.0),
            child: SizedBox(
              height:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  56,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  Text(
                    'onboarding.bismillah'.tr(),
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn().scale(delay: 200.ms),
                  const SizedBox(height: 12),
                  Text(
                    'onboarding.subtitle'.tr(),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 400.ms),
                  const Spacer(flex: 3),
                  _buildGenderSelect(colorScheme),
                  const SizedBox(height: 24),
                  _buildInputs(colorScheme),
                  const Spacer(flex: 4),
                  _buildSubmitButton(colorScheme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelect(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'onboarding.gender'.tr(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildToggleButton(
                  'onboarding.male'.tr(),
                  _gender == 'male',
                  () {
                    InteractionService.tap();
                    setState(() {
                      _gender = 'male';
                      if (_startedAgeController.text == '9') {
                        _startedAgeController.text = '12';
                      }
                    });
                  },
                  colorScheme,
                ),
              ),
              Expanded(
                child: _buildToggleButton(
                  'onboarding.female'.tr(),
                  _gender == 'female',
                  () {
                    InteractionService.tap();
                    setState(() {
                      _gender = 'female';
                      if (_startedAgeController.text == '12') {
                        _startedAgeController.text = '9';
                      }
                    });
                  },
                  colorScheme,
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildToggleButton(
    String label,
    bool isSelected,
    VoidCallback onTap,
    ColorScheme colorScheme,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 10,
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected
                ? Colors.black
                : Colors.white.withValues(alpha: 0.5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInputs(ColorScheme colorScheme) {
    return Column(
      children: [
        _buildTextField(
          controller: _currentAgeController,
          label: 'onboarding.currentAge'.tr(),
          icon: Icons.person_outline,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _startedAgeController,
          label: 'onboarding.ageStarted'.tr(),
          icon: Icons.history_edu,
          colorScheme: colorScheme,
        ),
      ],
    ).animate().fadeIn().slideX(begin: 0.1, end: 0);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ColorScheme colorScheme,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: colorScheme.primary),
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        child: Text(
          'onboarding.start'.tr(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    ).animate().fadeIn(delay: 800.ms).moveY(begin: 20, end: 0);
  }
}

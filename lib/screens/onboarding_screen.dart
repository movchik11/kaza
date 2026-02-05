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
    final totalFasting = (fastingYears * 30).ceil();

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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withValues(alpha: 0.1),
              const Color(0xFF0F172A),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
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
                const SizedBox(height: 60),
                _buildToggle(colorScheme),
                const SizedBox(height: 32),
                _buildInputs(colorScheme),
                const Spacer(),
                _buildSubmitButton(colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggle(ColorScheme colorScheme) {
    return Container(
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
              'onboarding.byYears'.tr(),
              !_isByDate,
              () => setState(() => _isByDate = false),
              colorScheme,
            ),
          ),
          Expanded(
            child: _buildToggleButton(
              'onboarding.byDate'.tr(),
              _isByDate,
              () => setState(() => _isByDate = true),
              colorScheme,
            ),
          ),
        ],
      ),
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
    if (!_isByDate) {
      return Column(
        children: [
          _buildTextField(
            controller: _yearsController,
            label: 'onboarding.yearsHint'.tr(),
            icon: Icons.history_rounded,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _fastingController,
            label: 'onboarding.fastingYears'.tr(),
            icon: Icons.wb_sunny_outlined,
            colorScheme: colorScheme,
          ),
        ],
      ).animate().fadeIn().slideX(begin: 0.1, end: 0);
    } else {
      return InkWell(
        onTap: _pickPubertyDate,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today_rounded, color: colorScheme.primary),
              const SizedBox(width: 16),
              Text(
                _pubertyDate == null
                    ? 'onboarding.selectDate'.tr()
                    : DateFormat('MMMM d, yyyy').format(_pubertyDate!),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn().slideX(begin: -0.1, end: 0);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ColorScheme colorScheme,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
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

  Future<void> _pickPubertyDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2010),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.black,
              surface: const Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) setState(() => _pubertyDate = date);
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

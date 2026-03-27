import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/kaza_cubit.dart';
import '../cubit/settings_cubit.dart';
import '../utils/interaction_utils.dart';

class ThemeItem {
  final String nameKey;
  final int colorValue;
  final int cost;

  const ThemeItem(this.nameKey, this.colorValue, this.cost);
}

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  static const List<ThemeItem> premiumThemes = [
    ThemeItem('theme.emerald', 0xFF10B981, 0), // Default, free
    ThemeItem('theme.sapphire', 0xFF3B82F6, 100),
    ThemeItem('theme.gold', 0xFFF59E0B, 250),
    ThemeItem('theme.ruby', 0xFFEF4444, 500),
    ThemeItem('theme.amethyst', 0xFF8B5CF6, 1000),
    ThemeItem('theme.rose', 0xFFEC4899, 2000),
    ThemeItem('theme.obsidian', 0xFF121212, 5000),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final kazaState = context.watch<KazaCubit>().state;
    final virtualCoins = kazaState.data.virtualCoins;
    final unlockedThemes = kazaState.data.unlockedThemes.isNotEmpty
        ? kazaState.data.unlockedThemes
        : [0xFF10B981];

    final currentSeedColor = context.watch<SettingsCubit>().state.seedColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'shop.title'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('shop.title'.tr()),
                  content: Text('confirmation.pointsInfo'.tr()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('common.ok'.tr()),
                    ),
                  ],
                ),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.monetization_on,
                  color: Colors.amber.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  virtualCoins.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ).animate().scale(),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: premiumThemes.length,
        itemBuilder: (context, index) {
          final theme = premiumThemes[index];
          final isUnlocked =
              unlockedThemes.contains(theme.colorValue) || theme.cost == 0;
          final isSelected = currentSeedColor == theme.colorValue;
          final canAfford = virtualCoins >= theme.cost;

          return _buildThemeCard(
            context,
            theme,
            isUnlocked,
            isSelected,
            canAfford,
            colorScheme,
          ).animate().fadeIn(delay: (index * 50).ms).moveX(begin: 20, end: 0);
        },
      ),
    );
  }

  Widget _buildThemeCard(
    BuildContext context,
    ThemeItem theme,
    bool isUnlocked,
    bool isSelected,
    bool canAfford,
    ColorScheme colorScheme,
  ) {
    final themeColor = Color(theme.colorValue);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? themeColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          InteractionUtils.haptic(context);
          if (isUnlocked) {
            context.read<SettingsCubit>().setThemeColor(theme.colorValue);
          } else if (canAfford) {
            _showPurchaseConfirmation(context, theme);
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('shop.notEnoughCoins'.tr())));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: themeColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: themeColor.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white)
                    : isUnlocked
                    ? const Icon(Icons.lock_open, color: Colors.white, size: 20)
                    : const Icon(Icons.lock, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      theme.nameKey.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    if (!isUnlocked)
                      Text(
                        'shop.tapToUnlock'.tr(),
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
              if (!isUnlocked)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: canAfford
                        ? themeColor.withValues(alpha: 0.2)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: canAfford ? Colors.amber.shade600 : Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        theme.cost.toString(),
                        style: TextStyle(
                          color: canAfford ? themeColor : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              if (isUnlocked && !isSelected)
                Text(
                  'shop.apply'.tr(),
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPurchaseConfirmation(BuildContext context, ThemeItem theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('shop.confirmPurchase'.tr()),
        content: Text(
          'shop.purchaseSubtitle'.tr(
            args: [theme.nameKey.tr(), theme.cost.toString()],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('common.cancel'.tr()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(theme.colorValue),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              context
                  .read<KazaCubit>()
                  .unlockTheme(theme.colorValue, theme.cost)
                  .then((success) {
                    if (success && context.mounted) {
                      context.read<SettingsCubit>().setThemeColor(
                        theme.colorValue,
                      );
                      Navigator.pop(ctx);
                    }
                  });
            },
            child: Text('shop.buy'.tr()),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../@core/theme/theme_provider.dart';

class ThemeChangeComponent extends ConsumerWidget {
  const ThemeChangeComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        ref.read(themeModeProvider.notifier).toggleTheme();
      },
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Icon(isDark ? Icons.light_mode : Icons.dark_mode, size: 28),
      ),
    );
  }
}

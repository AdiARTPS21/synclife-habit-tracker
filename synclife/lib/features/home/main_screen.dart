import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../settings/settings_screen.dart';
import '../statistics/statistics_screen.dart';
import 'dashboard_screen.dart';
import '../../core/constants/providers/theme_provider.dart';

// Provider untuk track index navigasi
class BottomNavIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void setIndex(int index) => state = index;
}

final bottomNavIndexProvider = NotifierProvider<BottomNavIndexNotifier, int>(BottomNavIndexNotifier.new);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  final List<Widget> _pages = const [
    DashboardScreen(),
    StatisticsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
    
    // Warna Utama
    const Color primaryBlue = Color(0xFF2B3A8C);
    
    // Warna Dinamis
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final iconColor = isDarkMode ? Colors.grey.shade600 : Colors.grey;
    final selectedIconColor = isDarkMode ? Colors.white : primaryBlue;
    final labelColor = isDarkMode ? Colors.grey.shade400 : Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: backgroundColor,
          elevation: 0,
          indicatorColor: primaryBlue.withValues(alpha: isDarkMode ? 0.3 : 0.1),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return GoogleFonts.inter(
                color: selectedIconColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              );
            }
            return GoogleFonts.inter(
              color: labelColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: selectedIconColor);
            }
            return IconThemeData(color: iconColor);
          }),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            ref.read(bottomNavIndexProvider.notifier).setIndex(index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.grid_view_rounded),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Statistik',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Pengaturan',
            ),
          ],
        ),
      ),
    );
  }
}
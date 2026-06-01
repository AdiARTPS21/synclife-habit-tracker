import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/providers/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Dummy state untuk toggle notifikasi
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
    
    // Palet Warna Dinamis
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFEEF2FF);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1E293B);
    final subtitleColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final iconBgColor = isDarkMode ? Colors.white12 : const Color(0xFF2B3A8C).withValues(alpha: 0.08);

    // Warna khusus untuk tombol Log Out
    final logoutColor = isDarkMode ? Colors.red.shade400 : Colors.red.shade700;
    final logoutBgColor = isDarkMode ? Colors.red.withValues(alpha: 0.1) : Colors.red.shade50;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Pengaturan',
          style: GoogleFonts.outfit(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. KARTU PROFIL
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2B3A8C), Color(0xFF5A72EA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2B3A8C).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'F', // Bisa diganti inisial user
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fathir',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tetap konsisten setiap hari!',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      size: 20,
                      color: isDarkMode ? Colors.white : const Color(0xFF2B3A8C),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            Text(
              'Preferensi',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            
            // 2. GRUP PENGATURAN PREFERENSI
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSwitchTile(
                    icon: Icons.dark_mode_rounded,
                    title: 'Tema Gelap',
                    subtitle: 'Sesuaikan dengan kondisi cahaya',
                    value: isDarkMode,
                    onChanged: (val) => ref.read(themeProvider.notifier).setTheme(val),
                    iconBgColor: iconBgColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    isDarkMode: isDarkMode,
                  ),
                  _buildDivider(isDarkMode),
                  _buildSwitchTile(
                    icon: Icons.notifications_active_rounded,
                    title: 'Notifikasi Pengingat',
                    subtitle: 'Jangan lewatkan habit harianmu',
                    value: _notificationsEnabled,
                    onChanged: (val) => setState(() => _notificationsEnabled = val),
                    iconBgColor: iconBgColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            Text(
              'Lainnya',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            
            // 3. GRUP PENGATURAN LAINNYA
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildActionTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Pusat Bantuan',
                    iconBgColor: iconBgColor,
                    textColor: textColor,
                    isDarkMode: isDarkMode,
                  ),
                  _buildDivider(isDarkMode),
                  _buildActionTile(
                    icon: Icons.info_outline_rounded,
                    title: 'Tentang Aplikasi',
                    iconBgColor: iconBgColor,
                    textColor: textColor,
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),

            // 4. TOMBOL LOG OUT
            InkWell(
              onTap: () {
                // TODO: Tambahkan logika fungsi Log Out di sini
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: logoutBgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: logoutColor.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      color: logoutColor,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Log Out',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: logoutColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget Helper: Garis Pemisah (Divider) yang rapi
  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDarkMode ? Colors.white10 : Colors.grey.shade100,
      indent: 76,
      endIndent: 24,
    );
  }

  // Widget Helper: Menu dengan Switch Toggle
  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required Color iconBgColor,
    required Color textColor,
    required Color subtitleColor,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: isDarkMode ? Colors.white : const Color(0xFF2B3A8C),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF2B3A8C),
            inactiveThumbColor: isDarkMode ? Colors.grey.shade400 : Colors.white,
            inactiveTrackColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  // Widget Helper: Menu Biasa dengan Panah
  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required Color iconBgColor,
    required Color textColor,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: () {}, // Tambahkan navigasi jika diperlukan
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: isDarkMode ? Colors.white : const Color(0xFF2B3A8C),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: isDarkMode ? Colors.white30 : Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
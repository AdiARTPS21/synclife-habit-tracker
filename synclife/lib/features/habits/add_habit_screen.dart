
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/habit_model.dart';
import 'habit_repository.dart';
import '../home/dashboard_screen.dart'; // For habitsFutureProvider
import '../../core/constants/providers/theme_provider.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  const AddHabitScreen({super.key});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  TimeOfDay? _selectedTime;
  String _selectedIcon = '🏃‍♂️';
  String _selectedColor = '#673AB7'; // Deep Purple default
  bool _isLoading = false;

  final List<String> _icons = ['🏃‍♂️', '💧', '📚', '🧘‍♀️', '🍎', '💻', '😴', '📝', '🎸', '🧹'];
  final List<String> _colors = [
    '#673AB7', // Deep Purple
    '#2196F3', // Blue
    '#4CAF50', // Green
    '#FF9800', // Orange
    '#F44336', // Red
    '#E91E63', // Pink
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih target waktu terlebih dahulu'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(habitRepositoryProvider);
      
      // Format time as HH:mm
      final timeString = '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';

      final newHabit = HabitModel(
        namaHabit: _nameController.text.trim(),
        ikon: _selectedIcon,
        targetWaktu: timeString,
        warnaTag: _selectedColor,
        createdAt: DateTime.now(),
      );

      await repo.createHabit(newHabit);

      // Invalidate dashboard provider so it fetches the new list
      ref.invalidate(habitsProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kebiasaan baru berhasil ditambahkan!', style: GoogleFonts.inter()),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF2B3A8C)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

@override
Widget build(BuildContext context) {
  final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
  
  // Variabel warna dinamis
  final backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
  final textColor = isDarkMode ? Colors.white : Colors.black87;
  final inputFillColor = isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50;
  final borderColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200;

  return Scaffold(
    backgroundColor: backgroundColor,
    appBar: AppBar(
      title: Text(
        'Tambah Kebiasaan',
        style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: textColor),
      ),
      backgroundColor: backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: textColor),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Kebiasaan
            Text('Nama Kebiasaan', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16, color: textColor)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Misal: Olahraga Pagi, Minum Air',
                hintStyle: TextStyle(color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400),
                filled: true,
                fillColor: inputFillColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF2B3A8C), width: 2)),
              ),
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
            ),
            
            const SizedBox(height: 28),
            
            // Pilih Ikon
            Text('Pilih Ikon', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16, color: textColor)),
            const SizedBox(height: 12),
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _icons.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final icon = _icons[index];
                  final isSelected = _selectedIcon == icon;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = icon),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 64,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF2B3A8C).withValues(alpha: 0.1) : inputFillColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSelected ? const Color(0xFF2B3A8C) : borderColor),
                      ),
                      alignment: Alignment.center,
                      child: Text(icon, style: const TextStyle(fontSize: 28)),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 28),

            // Target Waktu
            Text('Target Waktu', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16, color: textColor)),
            const SizedBox(height: 12),
            InkWell(
              onTap: _selectTime,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: inputFillColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time_rounded, color: Color(0xFF2B3A8C)),
                    const SizedBox(width: 12),
                    Text(
                      _selectedTime != null 
                          ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                          : 'Pilih waktu...',
                      style: GoogleFonts.inter(fontSize: 16, color: _selectedTime != null ? textColor : Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 28),

            // Warna Tag
            Text('Warna Tag', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16, color: textColor)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _colors.map((hex) {
                final isSelected = _selectedColor == hex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = hex),
                  child: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: _hexToColor(hex),
                      shape: BoxShape.circle,
                      border: isSelected ? Border.all(color: textColor, width: 3) : null,
                    ),
                    child: isSelected ? Icon(Icons.check, color: isDarkMode ? Colors.black : Colors.white, size: 20) : null,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 48),

            // Tombol Simpan
            SizedBox(
              width: double.infinity, height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B3A8C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(_isLoading ? 'Menyimpan...' : 'Simpan Kebiasaan', style: const TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
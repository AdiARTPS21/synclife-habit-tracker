import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/log_model.dart';
import 'log_repository.dart';
import '../statistics/statistics_screen.dart';
import '../home/dashboard_screen.dart';
import '../predictor/prediction_provider.dart';

class ContextBottomSheet extends ConsumerStatefulWidget {
  final String habitId;

  const ContextBottomSheet({super.key, required this.habitId});

  @override
  ConsumerState<ContextBottomSheet> createState() => _ContextBottomSheetState();
}

class _ContextBottomSheetState extends ConsumerState<ContextBottomSheet> {
  int _selectedMood = 3;
  int _selectedBusy = 2;
  bool _isLoading = false;

  void _submit() async {
    setState(() => _isLoading = true);

    try {
      final logRepo = ref.read(logRepositoryProvider);
      final logs = await logRepo.getLogs();
      final now = DateTime.now();

      // Cek duplikasi hari ini
      final hasLoggedToday = logs.any((l) =>
          l.idHabit == widget.habitId &&
          l.status == true &&
          l.timestamp?.year == now.year &&
          l.timestamp?.month == now.month &&
          l.timestamp?.day == now.day);

      if (hasLoggedToday) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Habit sudah diselesaikan hari ini!"),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      final newLog = LogModel(
        idHabit: widget.habitId,
        moodLevel: _selectedMood,
        busyLevel: _selectedBusy,
        status: true,
        timestamp: now,
      );

      await logRepo.createLog(newLog);

      // Update semua provider
      ref.invalidate(todayCompletedHabitsProvider);
      ref.invalidate(statisticsProvider);
      ref.invalidate(predictionProvider);
      
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 32,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Bagaimana perasaanmu?',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          // Emoji Selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              int moodValue = index + 1;
              bool isSelected = _selectedMood == moodValue;
              List<String> emojis = ['😢', '😕', '😐', '🙂', '😄'];
              return GestureDetector(
                onTap: () => setState(() => _selectedMood = moodValue),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2B3A8C).withValues(alpha: 0.1)
                        : Colors.grey.shade50,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF2B3A8C)
                          : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    emojis[index],
                    style: TextStyle(fontSize: isSelected ? 32 : 26),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 28),
          Text(
            'Tingkat Kesibukan',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          // Busy Level Selection
          Row(
            children: [
              _buildBusyButton(1, 'Santai'),
              const SizedBox(width: 8),
              _buildBusyButton(2, 'Sedang'),
              const SizedBox(width: 8),
              _buildBusyButton(3, 'Sangat\nSibuk'),
            ],
          ),
          const SizedBox(height: 28),
          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B3A8C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Simpan & Update Prediksi',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusyButton(int value, String label) {
    final isSelected = _selectedBusy == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedBusy = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2B3A8C) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? const Color(0xFF2B3A8C) : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: isSelected ? Colors.white : Colors.black87,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
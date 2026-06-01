import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.light;
  }

  void setTheme(bool darkMode) {
    state = darkMode ? ThemeMode.dark : ThemeMode.light;
  }
}

final themeProvider =
    NotifierProvider<ThemeNotifier, ThemeMode>(
      ThemeNotifier.new,
    );
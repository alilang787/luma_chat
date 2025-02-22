import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// enum themeMode {
//   dark,
//   light,
//   system,
// }

class themeSettingNotify extends StateNotifier<ThemeMode> {
  themeSettingNotify() : super(ThemeMode.system);

  void getSetting(int val) async {
    state = ThemeMode.values[val];
  }

  void changeTheme(ThemeMode mode) async {
    final ref = await SharedPreferences.getInstance();
    ref.setInt('themeOpt', mode.index);
    state = mode;
  }
}

final themeSetting =
    StateNotifierProvider<themeSettingNotify, ThemeMode>((ref) {
  return themeSettingNotify();
});

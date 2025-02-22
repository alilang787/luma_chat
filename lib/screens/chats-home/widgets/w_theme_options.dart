import '/providers/p_theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeOpts extends ConsumerStatefulWidget {
  ThemeOpts({super.key});

  @override
  ConsumerState<ThemeOpts> createState() => _ThemeOptsState();
}

class _ThemeOptsState extends ConsumerState<ThemeOpts> {
  late ThemeMode mode;
  // late int _currentOpt;
  @override
  Widget build(BuildContext context) {
    mode = ref.read(themeSetting);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadioListTile.adaptive(
          title: Text('Light'),
          value: ThemeMode.light,
          groupValue: mode,
          onChanged: (val) {
            ref.read(themeSetting.notifier).changeTheme(ThemeMode.light);
            setState(() {
              mode = val!;
            });
          },
        ),
        RadioListTile.adaptive(
          title: Text('Dark'),
          value: ThemeMode.dark,
          groupValue: mode,
          onChanged: (val) {
            ref.read(themeSetting.notifier).changeTheme(ThemeMode.dark);
            setState(() {
              mode = val!;
            });
          },
        ),
        RadioListTile.adaptive(
          title: Text('System'),
          value: ThemeMode.system,
          groupValue: mode,
          onChanged: (val) {
            ref.read(themeSetting.notifier).changeTheme(ThemeMode.system);
            setState(() {
              mode = val!;
            });
          },
        ),
      ],
    );
  }
}

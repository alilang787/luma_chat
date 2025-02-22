import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '/providers/p_personal_data.dart';

class DisplayName extends ConsumerWidget {
  const DisplayName({
    super.key,
    required bool isExpanded,
  }) : _isExpanded = isExpanded;

  final bool _isExpanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(personalData);
    final paintOutlined = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Color.fromARGB(255, 67, 138, 106).withOpacity(0.8);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(6),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(_isExpanded ? 12 : 0),
              decoration: BoxDecoration(
                  color: _isExpanded ? Colors.white54 : null,
                  borderRadius: BorderRadius.circular(16)),
              child: Text(
                userData.name!.toUpperCase(),
                style: TextStyle(
                  fontSize: _isExpanded ? 24 : 20,
                  fontWeight: _isExpanded ? FontWeight.w900 : FontWeight.normal,
                  color: _isExpanded
                      ? Color.fromARGB(255, 67, 138, 106)
                      : Colors.white,
                  // foreground: _isExpanded ? paintOutlined : null,
                ),
              ),
            ),
            if (!_isExpanded)
              Text(
                'online',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
          ],
        ),
        if (_isExpanded)
          IconButton(
            onPressed: () {},
            icon: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 67, 138, 106).withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit,
                size: 28,
                color: Colors.white,
              ),
            ),
          )
      ],
    );
  }
}

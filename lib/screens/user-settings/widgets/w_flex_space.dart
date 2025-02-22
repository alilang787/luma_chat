import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luma_chat/utils/utils.dart';
import '/providers/p_personal_data.dart';
import '/screens/user-settings/widgets/wfs_display_name.dart';

class FlexSpace extends ConsumerWidget {
  const FlexSpace({
    super.key,
    required bool isExpanded,
  }) : _isExpanded = isExpanded;

  final bool _isExpanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(personalData);
    printLog(v: userData.profileUrl);
    return Stack(
      children: [
        FlexibleSpaceBar(
          stretchModes: [
            StretchMode.blurBackground,
            StretchMode.zoomBackground,
          ],
          collapseMode: CollapseMode.none,
          background: CachedNetworkImage(
            imageUrl: userData.profileUrl!,
            cacheKey: userData.profileUrl,
            fit: BoxFit.cover,
          ),
          

          // expandedTitleScale: _isStretched ? 1.5 : 1.25,
        ),
        if (_isExpanded)
          Positioned(
            bottom: 10,
            left: 10,
            child: AnimatedOpacity(
              opacity: 1,
              duration: Duration(seconds: 2),
              key: ValueKey(_isExpanded),
              child: DisplayName(isExpanded: _isExpanded),
            ),
          ),
        if (_isExpanded)
          Positioned(
            bottom: 5,
            right: 5,
            child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/icons/chat-screen/edit-image.png',
                width: 40,
                height: 40,
              ),
            ),
          ),
      ],
    );
  }
}

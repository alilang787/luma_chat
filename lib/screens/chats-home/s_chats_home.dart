import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/p_personal_data.dart';
import '/screens/chats-home/widgets/w_drawer.dart';
import '/screens/chats-home/widgets/w_chat_preview.dart';
import 'package:flutter/material.dart';
import '/screens/chats-home/widgets/w_new_chat.dart';
import '/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatsHome extends ConsumerStatefulWidget {
  const ChatsHome({super.key});

  @override
  ConsumerState<ChatsHome> createState() => _ChatsHomeState();
}

class _ChatsHomeState extends ConsumerState<ChatsHome> {
  @override
  Widget build(BuildContext context) {
    ref.read(personalData.notifier).getData();
    final bool _isLightOn = Utils.isLightOn(context);
    return Scaffold(
      backgroundColor:
          _isLightOn ? Colors.white : Color.fromARGB(255, 16, 22, 26),
      appBar: AppBar(
        backgroundColor: _isLightOn
            ? const Color.fromARGB(255, 67, 138, 106)
            : Color.fromARGB(255, 34, 46, 53),
        title: Text('LumaChat'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateX(3.14)
                    ..rotateY(3.14),
                  child: SvgPicture.asset(
                    'assets/icons/menu.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      endDrawer: DrawerHome(),

      // -------------- body --------------
      //
      body: Stack(
        children: [
          ChatsPerview(),
          Positioned(
            right: 10,
            bottom: 10,
            child: NewChat(),
          ),
        ],
      ),
    );
  }
}


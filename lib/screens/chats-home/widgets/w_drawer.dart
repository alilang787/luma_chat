import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luma_chat/providers/p_chat_preview_data.dart';
import '/providers/p_personal_data.dart';
import '/screens/chats-home/widgets/w_theme_options.dart';
import '/screens/user-settings/s_user_settings.dart';
import '/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DrawerHome extends ConsumerWidget {
  DrawerHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _pData = ref.watch(personalData);
    return Drawer(
        backgroundColor: Utils.isLightOn(context)
            ? Colors.white
            : Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        width: MediaQuery.of(context).size.width * 0.7,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            return Column(
              children: [
                // -------------------- head ------------------

                Container(
                  width: width,
                  height: height * 0.3,
                  color: Utils.isLightOn(context)
                      ? Color.fromARGB(255, 67, 138, 106).withOpacity(0.8)
                      : Color.fromARGB(255, 34, 46, 53),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: width * 0.05),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              // width: width * 0.4,
                              // height: width * 0.4,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              clipBehavior: Clip.hardEdge,
                              child: CachedNetworkImage(
                                imageUrl: _pData.profileUrl!,
                                cacheKey: _pData.profileUrl!,
                              ),
                            ),
                          ),
                          Gap(4),
                          FittedBox(
                            child: Text(
                              _pData.name!,
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Gap(4),
                          FittedBox(
                            child: Text(
                              '@${_pData.username}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ------------------- body ----------------

                Container(
                  padding: EdgeInsets.all(width * .05),
                  height: height * 0.68,
                  child: Wrap(
                    runSpacing: 4,
                    children: [
                      ListTile(
                        onTap: () => Navigator.pop(context),
                        leading: Icon(Icons.home_outlined),
                        title: Text(
                          'Home',
                        ),
                      ),
                      ListTile(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return UserSettings();
                          },
                        )),
                        leading: Icon(Icons.settings_outlined),
                        title: Text(
                          'Settings',
                        ),
                      ),
                      ListTile(
                        onTap: () => Utils.showDialog(
                          context: context,
                          title: 'Choose theme',
                          content: ThemeOpts(),
                        ),
                        leading: Icon(Icons.brightness_6),
                        title: Text(
                          'Theme',
                        ),
                      ),
                      ListTile(
                        onTap:()=> _logOut(ref),
                        leading: Icon(Icons.logout),
                        title: Text(
                          'Log Out',
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }

  // ===================== M E T H O D S ========================

void _logOut(WidgetRef ref) async {
  try {
    ref.read(chatPreviewData.notifier).clearChatPreviews();
    await FirebaseFirestore.instance.terminate();
    await FirebaseFirestore.instance.clearPersistence();
    await Future.delayed(Duration(milliseconds: 500));
    await FirebaseAuth.instance.signOut();
    print("User logged out, persistence cleared.");
  } catch (e) {
    print("Logout Error: $e");
  }
}


}

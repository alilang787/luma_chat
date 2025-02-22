import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '/providers/p_chat_preview_data.dart';
import '/providers/p_personal_data.dart';
import '/screens/chat-screen/s_chat_screen.dart';
import 'package:flutter/material.dart';
import '/utils/utils.dart';

class ChatsPerview extends ConsumerStatefulWidget {
  ChatsPerview({super.key});

  @override
  ConsumerState<ChatsPerview> createState() => _ChatsPerviewState();
}

class _ChatsPerviewState extends ConsumerState<ChatsPerview> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    ref.read(chatPreviewData.notifier).loadChatPreviews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final previews = ref.watch(chatPreviewData);

    return previews == null
        ? CircularProgressIndicator()
        : previews.isEmpty
            ? Center(
                child: Text('No Chat here'),
              )
            : ListView.builder(
                itemCount: previews.length,
                itemBuilder: (context, index) {
                  final preview = previews[index];
                  return InkWell(
                    onTap: () {
                      print(preview.profilePicUrl);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return ChatScreen(
                            receiverUid: preview.uid,
                            recUname: preview.username,
                            recProfileName: preview.profileName,
                            recProfileUrl: preview.profilePicUrl!,
                          );
                        },
                      ));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                          foregroundImage: CachedNetworkImageProvider(
                        preview.profilePicUrl!,
                        cacheKey: preview.profilePicUrl!,
                      )),
                      title: Text(
                          preview.uid == FirebaseAuth.instance.currentUser!.uid
                              ? 'You'
                              : preview.profileName),
                      titleTextStyle: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Utils.isLightOn(context)
                            ? Colors.black
                            : Colors.white,
                      ),
                      subtitle: Text(preview.lastMessage),
                      subtitleTextStyle: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      trailing: Text(_formatTime(preview.createdAt)),
                    ),
                  );
                },
              );
  }

  //  ===================== M E T H O D S ====================
  String _formatTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inDays < 1) {
      // If within the last 24 hours, show time like 12:40 PM
      return DateFormat('h:mm a').format(dateTime);
    } else if (difference.inDays < 7) {
      // If within the last 7 days, show day name like Mon, Tue, etc.
      return DateFormat('E').format(dateTime);
    } else {
      // If more than 7 days ago, show month + day like Jan 01
      return DateFormat('MMM d').format(dateTime);
    }
  }
}

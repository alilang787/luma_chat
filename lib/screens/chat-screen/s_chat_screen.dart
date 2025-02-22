import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gap/gap.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '/models/m_chat_data.dart';
import '/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/p_chat_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/screens/chat-screen/widgets/w_chat_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String receiverUid;
  final String recUname;
  final String recProfileName;
  final String recProfileUrl;

  ChatScreen({
    super.key,
    required this.receiverUid,
    required this.recUname,
    required this.recProfileName,
    required this.recProfileUrl,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final FocusNode _focusNode = FocusNode();
  late TextEditingController _messageController;
  final ScrollController _scrollController = ScrollController();

  final currentUser = FirebaseAuth.instance.currentUser!;
  late String uniqueUid;
  late String currUname;
  @override
  void initState() {
    currUname = 'username';
    String rawUid = currentUser.uid + widget.receiverUid;
    uniqueUid = generateUniqueUid(rawUid);

    ref.read(chatDataProvider.notifier).loadMessages(
          uniqueUid,
          currentUser.uid,
        );
    _messageController = TextEditingController();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
          // ListView is at the top
        } else {
          // ListView is at the bottom
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    _messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _chats = ref.watch(chatDataProvider);
    final bool _isLightOn = Utils.isLightOn(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //
      // ---------------- App Bar --------------------

      appBar: AppBar(
        backgroundColor: _isLightOn
            ? const Color.fromARGB(255, 67, 138, 106)
            : Color.fromARGB(255, 7, 5, 12),
        // Theme.of(context).primaryColor,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            ref.read(chatDataProvider.notifier).clearData();
            Navigator.pop(context);
          },
        ),
        title: SafeArea(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  widget.recProfileUrl,
                  cacheKey: widget.recProfileUrl,
                ),
              ),
              Gap(8),
              Text(
                widget.recProfileName,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),

      // ---------------- body --------------------

      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    Utils.isLightOn(context)
                        ? 'assets/backgrounds/background-light.jpg'
                        : 'assets/backgrounds/background-dark.jpg',
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                //
                // ---------------- chats view --------------------

                Expanded(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemCount: _chats.length,
                      itemBuilder: (context, index) {
                        final chat = _chats[index];
                        bool _isMe = currentUser.uid == chat.senderUid;

                        bool? _isNextInSameDay;
                        if ((index + 1) < _chats.length) {
                          _isNextInSameDay = _isNextSmsInSameDay(
                              chat.createdAt, _chats[index + 1].createdAt);
                        }

                        // ------------ make sms as read --------------

                        if (chat.docRef != null && !_isMe && !chat.isRead) {
                          ref
                              .read(chatDataProvider.notifier)
                              .updateChatOjb(chat);
                          chat.docRef!.update({
                            'status': ChatStatus.Read.index,
                          });
                        }

                        return ChatBubble(
                          isMe: _isMe,
                          chatData: chat,
                          isNextInSameDay: _isNextInSameDay,
                          nextUid: index < _chats.length - 1
                              ? _chats[index + 1].senderUid
                              : null,
                        );
                      },
                    ),
                  ),
                ),
                //
                // ---------------- send message --------------------

                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isLightOn
                        ? Theme.of(context).colorScheme.surface
                        : Color.fromARGB(255, 7, 5, 12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            controller: _messageController,
                            minLines: 1,
                            maxLines: 4,
                            style: TextStyle(fontSize: 16),
                            cursorColor: _isLightOn
                                ? const Color.fromARGB(255, 67, 138, 106)
                                : Colors.white,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter message...',
                                hintStyle: TextStyle(
                                  color: _isLightOn
                                      ? Colors.grey
                                      : Colors.grey.shade300,
                                )),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _sendMessage,
                        icon: Icon(
                          Icons.send,
                          color: _isLightOn
                              ? const Color.fromARGB(255, 67, 138, 106)
                              : Colors.grey.shade300,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================  M E T H O D S  ===========================

  // -------------- sendMessage ---------------

  void _sendMessage() async {
    if (_messageController.text.isEmpty ||
        _messageController.text.trim().isEmpty) return;
    final _message = _messageController.text;
    _messageController.clear();
    ref.read(chatDataProvider.notifier).sendMessage(
          message: _message,
          uniqueUid: uniqueUid,
          currUname: currUname,
          receiverUid: widget.receiverUid,
          recUname: widget.recUname,
          recProfileName: widget.recProfileName,
          recProfileUrl: widget.recProfileUrl,
        );
  }

  // ------------ get unique uid ------------

  String generateUniqueUid(String input) {
    List<int> charCodes = List.from(input.codeUnits);
    charCodes.sort();
    String sortedInput = String.fromCharCodes(charCodes);

    var bytes = utf8.encode(sortedInput); // Convert sorted string to bytes
    var digest = sha256.convert(bytes); // Generate SHA-256 hash

    return '_${digest.toString()}'; // Convert the hash to a string
  }

  // ------------ check if next message is in same day ------------

  bool _isNextSmsInSameDay(Timestamp t1, Timestamp t2) {
    final time1 = t1.toDate();
    final time2 = t2.toDate();
    return time1.year == time2.year &&
        time1.month == time2.month &&
        time1.day == time2.day;
  }
}

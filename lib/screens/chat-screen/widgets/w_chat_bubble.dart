import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '/models/m_chat_data.dart';
import '/utils/utils.dart';

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final bool? isNextInSameDay;
  final ChatDataM chatData;
  final String? nextUid;

  const ChatBubble({
    super.key,
    required this.chatData,
    this.nextUid,
    required this.isMe,
    this.isNextInSameDay,
  });

  @override
  Widget build(BuildContext context) {
    final bool _isLightMode = Utils.isLightOn(context);
    final _date = chatData.createdAt.toDate();
    final _isNextUserSame = chatData.senderUid == nextUid;

    return Column(
      children: [
        // ------------  date bubble ----------

        if (isNextInSameDay == null || !isNextInSameDay!)
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Utils.isLightOn(context)
                  ? Colors.white
                  : const Color.fromARGB(255, 24, 24, 24),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              // chatData.createdAt.toDate().toString(),
              _formatTime(chatData.createdAt.toDate()),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        // ------------  message bubble ----------

        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            // ------------ bubble design -------------

            Container(
              margin: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width * .65,
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(
                      isMe
                          ? 12
                          : _isNextUserSame
                              ? 12
                              : 0,
                    ),
                    bottomRight: Radius.circular(
                      isMe
                          ? _isNextUserSame
                              ? 12
                              : 0
                          : 12,
                    ),
                  ),
                  gradient: LinearGradient(
                    colors: _isLightMode
                        //  ----------- Bg color for light theme ------------
                        ? [
                            !isMe
                                ? Colors.grey.shade100
                                : Color.fromARGB(255, 216, 248, 169),
                            !isMe
                                ? Colors.white
                                : Color.fromARGB(255, 207, 253, 186),
                          ]
                        //  ----------- Bg color for dark theme ------------
                        : [
                            !isMe
                                ? Colors.grey.shade800
                                : Colors.deepPurple.shade400,
                            !isMe
                                ? Theme.of(context).primaryColor
                                : Colors.deepPurple.shade900,
                          ],
                  ),
                ),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    // ------------ message -------------

                    Text(
                      chatData.message,
                      style: TextStyle(
                        fontSize: 17,
                        // color: Colors.white,
                      ),
                    ),

                    // ------------ message time -------------

                    Transform.translate(
                      offset: Offset(0, 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '    ${DateFormat('h:mm a').format(_date)}',
                            style: TextStyle(
                              color: _isLightMode
                                  ? isMe
                                      ? Colors.green.shade300
                                      : Colors.green.shade300
                                  : isMe
                                      ? Colors.grey.shade200
                                      : Colors.grey,
                            ),
                          ),
                          if (isMe) Gap(4),

                          // ---------- message status -----------

                          if (isMe)
                            Icon(
                              getStatusIcon(chatData.status),
                              size: 16,
                              color: chatData.status == ChatStatus.Read
                                  ? _isLightMode
                                      ? Colors.green.shade800
                                      : Color.fromARGB(255, 93, 227, 200)
                                  : _isLightMode
                                      ? Colors.green.shade300
                                      : Colors.grey.shade200,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================== M E T H O D S ========================

  IconData getStatusIcon(ChatStatus status) {
    switch (status) {
      case ChatStatus.Sending:
        return Icons.schedule;
      case ChatStatus.Uploaded:
        return Icons.check;
      case ChatStatus.Delivered:
        return Icons.done_all;
      case ChatStatus.Read:
        return Icons.done_all;
      default:
        return Icons.error;
    }
  }

  //  -------------- format time ----------------
  String _formatTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inDays == 0 && now.day == dateTime.day) {
      return 'Today';
    } else if ((difference.inDays == 0 && now.day != dateTime.day)) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE')
          .format(dateTime); // Full day name like Monday, Tuesday, etc.
    } else {
      return DateFormat('d MMMM yyyy')
          .format(dateTime); // Full date like 11 June 2024
    }
  }
}

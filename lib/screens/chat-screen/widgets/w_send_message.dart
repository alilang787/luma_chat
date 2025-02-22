import 'package:flutter/material.dart';

class SendMessage extends StatelessWidget {
  const SendMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                minLines: 1,
                maxLines: 4,
                style: TextStyle(fontSize: 16),
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter message...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    )),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.send,
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }
}

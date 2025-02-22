import 'package:flutter/material.dart';
import '/screens/seach-user/s_search_user.dart';
import '/utils/utils.dart';

class NewChat extends StatelessWidget {
  const NewChat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchUser(),
          )),
      icon: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Utils.isLightOn(context)
              ? const Color.fromARGB(255, 67, 138, 106)
              : Color.fromARGB(255, 34, 46, 53),
          // Colors.deepPurple.shade900,

          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
    );
  }
}

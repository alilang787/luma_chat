import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/screens/chat-screen/s_chat_screen.dart';
import '/utils/utils.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  String? _searchText;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.isLightOn(context)
          ? Colors.white
          : Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).padding.top),
          child: Column(
            children: [
              //
              // ----------- seach field ---------------
              TextField(
                onChanged: (value) {
                  setState(() {
                    _searchText = value.trim();
                  });
                },
                focusNode: _focusNode,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Utils.isLightOn(context)
                      ? Colors.grey.shade100
                      : Theme.of(context).focusColor,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 10.0,
                  ),
                  prefixIcon: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: Utils.isLightOn(context)
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  hintText: 'Search user by username...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(52),
                  ),
                ),
              ),
              Expanded(
                  child: _searchText == null || _searchText!.length < 3
                      ? Center(
                          child: Text('No results found here!'),
                        )
                      : StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }

                            final _matchingUsers = snapshot.data!.docs.where(
                              (doc) {
                                return (doc.data()
                                        as Map<String, dynamic>)['username']
                                    .toString()
                                    .contains(_searchText!);
                              },
                            ).toList();

                            if (_matchingUsers.isEmpty) {
                              return Center(child: Text('No users found'));
                            }

                            return ListView.builder(
                              itemCount: _matchingUsers.length,
                              itemBuilder: (context, index) {
                                // --------- fetch data ----------
                                final _data = _matchingUsers[index].data()
                                    as Map<String, dynamic>;
                                final _user =
                                    FirebaseAuth.instance.currentUser!;
                                final _isMe =
                                    _user.uid == _matchingUsers[index].id;

                                final _profileName = _isMe
                                    ? 'You'
                                    : '${_data['firstName']} ${_data['lastName']}';
                                final _username = _data['username'];
                                final _profileUrl = _data['profileUrl'];

                                return InkWell(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) {
                                        return ChatScreen(
                                          receiverUid: _matchingUsers[index].id,
                                          recUname: _username,
                                          recProfileName: _profileName,
                                          recProfileUrl: _profileUrl,
                                        );
                                      },
                                    ));
                                  },
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      foregroundImage:
                                          NetworkImage(_profileUrl),
                                    ),
                                    title: Text(_profileName),
                                  ),
                                );
                              },
                            );
                          },
                        ))
            ],
          ),
        ),
      ),
    );
  }
}

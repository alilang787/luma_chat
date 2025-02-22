import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '/providers/p_personal_data.dart';
import '/screens/user-settings/widgets/w_flex_space.dart';
import '/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings extends ConsumerStatefulWidget {
  const UserSettings({super.key});

  @override
  ConsumerState<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends ConsumerState<UserSettings> {
  late ScrollController _scrollController;
  bool _isExpanded = true;

  final List<Map<String, dynamic>> prefrences = [
    {
      'title': 'Profile and Status',
      'icon': Icon(Icons.person),
    },
    {
      'title': 'Privacy and Security',
      'icon': Icon(Icons.lock),
    },
    {
      'title': 'Notifications and Sound',
      'icon': Icon(Icons.notifications),
    },
    {
      'title': 'Chat Settings',
      'icon': Icon(Icons.message),
    },
    {
      'title': 'Data and Storage Usage',
      'icon': Icon(Icons.data_usage),
    },
    {
      'title': 'Blocked Contacts',
      'icon': Icon(Icons.block),
    },
    {
      'title': 'Help and Support',
      'icon': Icon(Icons.help),
    },
    {
      'title': 'Appearance',
      'icon': Icon(Icons.color_lens),
    },
    {
      'title': 'Language',
      'icon': Icon(Icons.language),
    },
    {
      'title': 'Account Management',
      'icon': Icon(Icons.account_circle),
    },
    {
      'title': 'Invite Friends',
      'icon': Icon(Icons.group_add),
    },
  ];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      double appBarHeight = MediaQuery.of(context).size.height * 0.15;

      if (offset >= appBarHeight && _isExpanded) {
        setState(() {
          _isExpanded = false;
        });
      } else if (offset < appBarHeight && !_isExpanded) {
        setState(() {
          _isExpanded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _toolBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    final userData = ref.watch(personalData);

    return Scaffold(
      backgroundColor: Utils.isLightOn(context)
          ? Colors.white
          : Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            toolbarHeight: _toolBarHeight,
            pinned: true,
            backgroundColor: Utils.isLightOn(context)
                ? Color.fromARGB(255, 67, 138, 106).withOpacity(0.8)
                : Theme.of(context).primaryColor,
            expandedHeight: MediaQuery.of(context).size.height * 0.3,
            foregroundColor: Colors.white,
            leading: BackButton(),
            stretch: true,
            flexibleSpace: FlexSpace(isExpanded: _isExpanded),
            // collapsedHeight: 200,
          ),
          SliverGap(8),

          // ---------------------  account ----------------

          SliverListTile(
            title: Text(
              'Account',
              style: TextStyle(
                color: Utils.isLightOn(context)
                    ? Color.fromARGB(255, 67, 138, 106)
                    : Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SliverListTile(
            title: Text(userData.username),
            subtitle: Text('username'),
          ),
          SliverListTile(
            title: Text(userData.email ?? 'NA'),
            subtitle: Text('email'),
          ),
          SliverListTile(
            title: Text(userData.dob ?? 'NA'),
            subtitle: Text('date-of-birth'),
            trailWidget: IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit),
            ),
          ),
          SliverToBoxAdapter(
            child: Divider(thickness: 8),
          ),

          // ---------------------  prefrences ----------------
          SliverListTile(
            title: Text(
              'Preferences',
              style: TextStyle(
                color: Utils.isLightOn(context)
                    ? Color.fromARGB(255, 67, 138, 106)
                    : Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SliverList.list(
              children: prefrences.map((pref) {
            return ListTile(
              leading: pref['icon'],
              title: Text(pref['title']),
            );
          }).toList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
      ),
    );
  }
}

class SliverListTile extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? leadWidget;
  final Widget? trailWidget;
  const SliverListTile({
    super.key,
    this.title,
    this.subtitle,
    this.leadWidget,
    this.trailWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ListTile(
        leading: leadWidget,
        title: title,
        subtitle: subtitle,
        trailing: trailWidget,
      ),
    );
  }
}

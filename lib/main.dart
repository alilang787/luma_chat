import '/providers/p_conditions.dart';
import '/providers/p_theme_mode.dart';
import '/screens/user-auth/s_auth_main.dart';
import '/screens/user-auth/s_post_signup.dart';
import '/screens/chats-home/s_chats_home.dart';
import '/themes/dark.dart';
import '/themes/light.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//  -------------------  main function ---------------------

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await dotenv.load();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.debug,
  // );
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/bungee/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(ProviderScope(child: const MainApp()));
}

//  -------------------  App Main Widget ---------------------

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  bool _postSignUp = false;

  void _conditionsAndSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final isSignInAllowed = await prefs.getBool('isSignInAllowed') ?? true;
    // await prefs.setBool('postSignUp',false) ;
    final postSignUp = await prefs.getBool('postSignUp') ?? false;
    final int val = prefs.getInt('themeOpt') ?? 2;
    ref.read(themeSetting.notifier).getSetting(val);

    setState(() {
      _postSignUp = postSignUp;
    });
  }

  @override
  void initState() {
    super.initState();
    _conditionsAndSettings();
    ref.read(isSignInAllowed.notifier).isAllowed();
  }

  @override
  Widget build(BuildContext context) {
    //  ------------ Material App ----------

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // debugShowCheckedModeBanner: false,
      title: 'LumaChat',
      themeMode: ref.watch(themeSetting),
      theme: lighTheme,
      darkTheme: darkTheme,

      // ------------- Home Stream Builder ----------

      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            if (_postSignUp) return PostSignUp();
            if (!_postSignUp) {
              bool _isSignInAllowed = ref.watch(isSignInAllowed);
              if (_isSignInAllowed) return ChatsHome();
            }
          }
          return UserAuthMain();
        },
      ),
    );
  }
}

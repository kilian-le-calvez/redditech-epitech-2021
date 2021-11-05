import 'package:flutter/material.dart';
import 'package:redditech/pages/loading_page.dart';
import 'package:redditech/pages/searchsub_page.dart';
import 'package:redditech/pages/home_page.dart';
import 'package:redditech/pages/profile_page.dart';
import 'package:redditech/pages/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:redditech/pages/subreddit_page.dart';
import 'package:redditech/widgets/global_info.dart';
import 'package:redditech/pages/authwebview_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalProvider()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/profile': (context) => const ProfilePage(),
          '/authwebview': (context) => Authwebview(),
          '/searchsub': (context) => const SearchsubPage(),
          '/settings': (context) => const SettingsPage(),
          '/loading': (context) => const LoadingPage(),
          '/subreddit': (context) => const SubRedditPage(),
          '/logout': (context) => const LogOutPage(),
        },
      ),
    );
  }
}

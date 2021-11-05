import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redditech/widgets/global_info.dart';
import 'package:redditech/widgets/profile_logged.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
        builder: (BuildContext context, GlobalProvider info, Widget? child) {
      return Scaffold(
          body: context.read<GlobalProvider>().isLoggedIn
              ? const ProfileLoggedIn()
              : const ProfileLoggedOut(messageLoggedOut: "You are not logged"));
    });
  }
}

// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redditech/material/snackbar_error.dart';
import 'package:redditech/widgets/navigation_bar.dart';
import 'package:redditech/widgets/request.dart';
import 'package:redditech/widgets/search_bar.dart';
import 'package:redditech/widgets/global_info.dart';
import 'package:country_list_pick/country_list_pick.dart';

Map<String, dynamic> getMapStringForQuery(
    MapEntry<PairOption<dynamic, dynamic>, dynamic> oldValue, bool newValue) {
  Map<String, dynamic> newMap = {};

  newMap[oldValue.key.queryValue] = newValue;
  return newMap;
}

class EmailCategoryWidget extends StatelessWidget {
  final Map<PairOption<String, String>, dynamic> listOptions;
  final String category;

  const EmailCategoryWidget(
      {required this.listOptions, required this.category, Key? key})
      : super(key: key);
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
        builder: (BuildContext context, GlobalProvider info, Widget? child) {
      return Column(
        children: <Widget>[
          for (MapEntry<PairOption<dynamic, dynamic>, dynamic> option
              in listOptions.entries)
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(option.key.lisibleName + " : "),
                    CupertinoSwitch(
                      value: option.value,
                      onChanged: (newValue) {
                        NewApiServices()
                            .patchSettings(context.read<GlobalProvider>().token,
                                getMapStringForQuery(option, newValue))
                            .then((value) {
                          try {
                            context
                                        .read<GlobalProvider>()
                                        .settings
                                        .emailNotifications
                                        .data[category]![
                                    option.key as PairOption<String, String>] =
                                newValue;
                            context
                                .read<GlobalProvider>()
                                .actualizeApplication();
                          } catch (error) {
                            showSnackBarError(context, error);
                          }
                        }).catchError((onError) {
                          showSnackBarError(context, onError);
                        });
                      },
                      activeColor: Colors.orange,
                    ),
                  ],
                )
              ],
            ),
        ],
      );
    });
  }
}

class EmailNotificationWidget extends StatelessWidget {
  final Map<String, Map<PairOption<String, String>, dynamic>> listCategories;

  const EmailNotificationWidget({required this.listCategories, Key? key})
      : super(key: key);
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
        builder: (BuildContext context, GlobalProvider info, Widget? child) {
      return Column(
        children: <Widget>[
          for (MapEntry<String, dynamic> category in listCategories.entries)
            Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black38, width: 1))),
                  child: Row(
                    children: [
                      Text(
                        category.key,
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.black38),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                EmailCategoryWidget(
                    listOptions: category.value, category: category.key),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
        ],
      );
    });
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewApiServices()
        .getUserSettings(context.read<GlobalProvider>().token)
        .then((mySettings) {
      context.read<GlobalProvider>().setSettings(mySettings);
    }).catchError((onError) {
      showSnackBarError(context, onError);
    });

    return Consumer<GlobalProvider>(
        builder: (BuildContext context, GlobalProvider info, Widget? child) {
      return Scaffold(
          appBar: NavigationBar(context: context),
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon:
                            const Icon(Icons.arrow_back, color: Colors.black)),
                    const Text(
                      "Back",
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
                Expanded(
                    child: ListView(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        children: <Widget>[
                      const Text(
                        "Email notifications",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      EmailNotificationWidget(
                          listCategories: context
                              .read<GlobalProvider>()
                              .settings
                              .emailNotifications
                              .data),
                    ]))
              ]));
    });
  }
}

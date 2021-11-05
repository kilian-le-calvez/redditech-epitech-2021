import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redditech/material/snackbar_error.dart';
import 'package:redditech/widgets/global_info.dart';
import 'package:redditech/widgets/request.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
        builder: (BuildContext context, GlobalProvider info, Widget? child) {
      NewApiServices()
          .searchSubReddit(context.read<GlobalProvider>().search,
              context.read<GlobalProvider>().token)
          .then((listSubReddit) {
        context.read<GlobalProvider>().setListSubRedditHomePage(listSubReddit);
      }).catchError((onError) {
        showSnackBarError(context, onError);
      });
      return Expanded(
          child: TextField(
        onChanged: (newText) {
          if (newText == "") {
            context.read<GlobalProvider>().listSubRedditHomePage = [];
            context.read<GlobalProvider>().search = "";
            context.read<GlobalProvider>().actualizeApplication();
          } else {
            context.read<GlobalProvider>().setSearch(newText);
          }
        },
        decoration: const InputDecoration(
            border: UnderlineInputBorder(), labelText: 'Search'),
      ));
    });
  }
}

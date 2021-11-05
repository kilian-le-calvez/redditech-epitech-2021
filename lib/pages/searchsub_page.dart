import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:redditech/model/subreddit_model.dart';
import 'package:redditech/widgets/global_info.dart';
import 'package:redditech/widgets/search_bar.dart';
import 'package:redditech/widgets/subreddit_widget.dart';

class SearchsubPage extends StatelessWidget {
  const SearchsubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
        builder: (BuildContext context, GlobalProvider info, Widget? child) {
      return Scaffold(
          body: Column(children: <Widget>[
        const SizedBox(width: 10, height: 10),
        Row(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.black)),
              const SearchBar(),
              const SizedBox(width: 20, height: 20),
            ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: Colors.black54, width: 1)),
                child: Text(
                    '${context.read<GlobalProvider>().listSubRedditHomePage.length.toString()} results')),
            IconButton(
                onPressed: () {
                  context.read<GlobalProvider>().isEditingSubReddit =
                      !context.read<GlobalProvider>().isEditingSubReddit;
                  context.read<GlobalProvider>().actualizeApplication();
                },
                icon: const Icon(Icons.edit)),
          ],
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: Colors.black54, width: 1)),
            child: ListView(children: <Widget>[
              for (SubReddit subReddit
                  in context.read<GlobalProvider>().listSubRedditHomePage)
                SubRedditWidget(subReddit: subReddit)
            ]),
          ),
        ),
      ]));
    });
  }
}

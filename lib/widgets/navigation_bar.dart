import 'package:flutter/material.dart';

class NavigationBar extends AppBar {
  NavigationBar({Key? key, required BuildContext context})
      : super(
          key: key,
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => {Navigator.pushNamed(context, '/searchsub')}),
          ],
          backgroundColor: Colors.black87,
          title: const Text('Redditech'),
        );
}

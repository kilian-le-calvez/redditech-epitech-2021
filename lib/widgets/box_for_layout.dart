import 'package:flutter/material.dart';

class BoxForLayout extends StatelessWidget {
  final String name;
  final Color color;
  const BoxForLayout(this.name, this.color, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(name),
      ),
      padding: const EdgeInsets.only(left: 20),
    );
  }
}

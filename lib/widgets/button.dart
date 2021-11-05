import 'package:flutter/material.dart';

class ButtonText extends StatelessWidget {
  final String name;
  final double fontsize;
  const ButtonText(this.name, this.fontsize, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: fontsize),
      ),
      onPressed: () {},
      child: Text(name),
    );
  }
}

class ButtonBox extends StatelessWidget {
  final String name;
  final double fontsize;
  const ButtonBox(this.name, this.fontsize, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Positioned.fill(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xFFFF5722),
                Color(0xFFE64A19),
                Color(0xFFE65100),
              ],
            ),
          ),
        ),
      ),
      TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          primary: Colors.white,
          textStyle: TextStyle(fontSize: fontsize),
        ),
        onPressed: () {},
        child: Text(name),
      ),
    ]);
  }
}

class Button extends StatelessWidget {
  final String name;
  final int type;
  final double fontsize;
  const Button(this.name, this.type, this.fontsize, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (type == 0) ? ButtonText(name, fontsize) : ButtonBox(name, fontsize);
  }
}

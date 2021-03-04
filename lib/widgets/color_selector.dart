import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ColorSelector extends StatefulWidget {
  Color colorres;
  ColorSelector(this.colorres);
  @override
  _ColorSelectorState createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  List<Color> color_list = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.grey,
    Colors.pink,
    Colors.yellow,
    Colors.orange,
    Colors.white,
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          // mainAxisAlignment: MainAxisAlignment.spaceEvenlt,
          Row(
            children: <Widget>[
              colorRadio(color_list[0], 0),
              colorRadio(color_list[1], 1),
              colorRadio(color_list[2], 2),
              colorRadio(color_list[3], 3),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              colorRadio(color_list[4], 4),
              colorRadio(color_list[5], 5),
              colorRadio(color_list[6], 6),
              colorRadio(color_list[7], 7),
            ],
          )
        ],
      ),
    );
  }

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget colorRadio(Color color, int index) {
    return RaisedButton(
      onPressed: () {
        changeIndex(index);
        print(color);
      },
      shape: new CircleBorder(),
      color: color,
      elevation: 5,
    );
  }
}

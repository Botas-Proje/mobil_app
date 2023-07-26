import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCard extends StatefulWidget {
  MyCard(this.value, this.forString, {super.key});

  String value;
  String forString;
  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          if (mounted) {
            Navigator.pushNamed(context, "/minusPlus", arguments: widget.value);
          }
        },
        child: ListTile(
          title: Center(child: Text(" ${widget.forString} ")),
          trailing: SizedBox(
            width: 100,
          ),
        ),
      ),
    );
  }
}

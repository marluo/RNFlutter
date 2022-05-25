import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({
    Key key,
    @required this.messageController,
    @required this.placeholder,
  }) : super(key: key);

  final TextEditingController messageController;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8.0,
        margin: new EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: messageController,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: placeholder,
              contentPadding: EdgeInsets.all(10.0)),
        ));
  }
}
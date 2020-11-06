import 'package:flutter/material.dart';

typedef UpdateCallback = Function(String value, String id);
typedef DeleteCallback = Function(String id);

class Task extends StatelessWidget {
  final String content, id;
  final UpdateCallback update;
  final DeleteCallback delete;

  final TextEditingController updateText = TextEditingController();

  Task(
      {@required this.content,
      @required this.id,
      @required this.update,
      @required this.delete});

  @override
  Widget build(BuildContext context) {
    updateText.text = this.content;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: updateText,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.cloud_upload,
                  color: Colors.blueAccent,
                  size: 20,
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(0),
                onPressed: () =>
                    this.update(updateText.text.toString(), this.id),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                  size: 20,
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(0),
                onPressed: () => this.delete(this.id),
              )
            ],
          ),
        ],
      ),
    );
  }
}

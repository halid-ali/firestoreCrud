import 'package:flutter/material.dart';

typedef VoidCallback = Function(String value);

class EditDialog extends StatefulWidget {
  final String title, positiveAction, negativeAction;
  final VoidCallback submit;

  EditDialog(
      {@required this.title,
      @required this.positiveAction,
      @required this.negativeAction,
      @required this.submit});

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final TextEditingController textFieldController = TextEditingController();
  bool _validateDialog = true;

  @override
  void initState() {
    textFieldController.addListener(_updateDialogTextField);
    super.initState();
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: getDialogContent(),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              if (_validateDialog) {
                widget.submit(textFieldController.text.toString());
                Navigator.of(context).pop();
              }
            },
            child: Text(
              widget.positiveAction,
              style: TextStyle(
                color: _validateDialog ? Colors.blueAccent : Colors.grey,
              ),
            )),
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              widget.negativeAction,
              style: TextStyle(color: Colors.redAccent),
            )),
      ],
    );
  }

  Widget getDialogContent() {
    return TextField(
      cursorColor: Theme.of(context).accentColor,
      controller: textFieldController,
      maxLines: 5,
      decoration: InputDecoration(
          hintText: 'Enter your task here',
          errorText: !_validateDialog ? 'Value cannot be empty' : null),
    );
  }

  void _updateDialogTextField() {
    setState(() {
      _validateDialog = textFieldController.text.isNotEmpty;
    });
  }
}

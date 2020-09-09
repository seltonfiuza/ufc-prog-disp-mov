import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contact/contacts.dart';

class ContactsWidget extends StatefulWidget {
  final selected;
  final data;
  ContactsWidget({Key key, this.selected, this.data}) : super(key: key);
  @override
  _ContactsWidgetState createState() => _ContactsWidgetState();
}

class _ContactsWidgetState extends State<ContactsWidget> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    countSelected() {
      var count = 0;
      widget.selected.forEach((s) => s ? count = count + 1 : null);
      return count == 5 ? false : true;
    }

    tap(index) {
      if (countSelected()) {
        setState(() {
          widget.selected[index] = !widget.selected[index];
        });
      } else {
        if (widget.selected[index]) {
          setState(() {
            widget.selected[index] = !widget.selected[index];
          });
        }
      }
    }

    return AlertDialog(
      title: new Text("Contact List (Only 5 contacts)"),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
            itemCount: widget.data.length - 1,
            itemBuilder: (BuildContext buildContext, int index) => Container(
                  color: widget.selected[index]
                      ? Colors.lightBlue[100]
                      : Colors.white,
                  child: ListTile(
                    onTap: () => tap(index),
                    title: Text(widget.data[index].displayName),
                    subtitle: Text((widget.data[index].phones
                        .map((e) => e.value)).toString()),
                  ),
                ),
            shrinkWrap: true),
      ),
      actions: [
        FloatingActionButton(
            onPressed: () {
              var b = [];
              for (var c = 0; c < widget.selected.length; c++) {
                if (widget.selected[c]) {
                  b.add(c);
                }
              }
              Navigator.pop(context, b);
            },
            child: Icon(Icons.check),
            backgroundColor: Colors.blue[800]),
        FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.cancel),
            backgroundColor: Colors.blue[800]),
      ],
    );
  }
}

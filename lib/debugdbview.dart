import 'package:flutter/material.dart';
import 'databasehelper.dart';

class DebugViewDB extends StatefulWidget {
  const DebugViewDB({super.key});

  @override
  State<DebugViewDB> createState() => _DebugViewDBState();
}

class _DebugViewDBState extends State<DebugViewDB> {
  List<Widget> contentList = <Widget>[];

  void getContentFromDB() async {
    var value = await DatabaseHelper.instance.queryAll();
    contentList.add(Center(
      child: Text('User List'),
    ));
    if (value.isNotEmpty) {
      debugPrint("value not empty!");
      for (var val in value) {
        debugPrint('Value found ${val['ownerName']}');
        contentList.add(
          Row(
            children: [
              Text('Name: '),
              Text(val['ownerName']),
            ],
          ),
        );
        contentList.add(
          Row(
            children: [
              Text('Plate number: '),
              Text(val['plateNum']),
            ],
          ),
        );
        contentList.add(
          Row(
            children: [
              Text('Model: '),
              Text(val['model']),
            ],
          ),
        );
        contentList.add(
          Row(
            children: [
              Text('CR number: '),
              Text(val['CRNum']),
            ],
          ),
        );
        contentList.add(
          Row(
            children: [
              Text('Permit num: '),
              Text(val['permitNum']),
            ],
          ),
        );
        contentList.add(
          Row(
            children: [
              Text('Is expired: '),
              Text(val['isExpired'] == 1 ? 'Expired' : 'Not Expired'),
            ],
          ),
        );
        contentList.add(Padding(padding: EdgeInsets.all(5.0)));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('Init state');
    getContentFromDB();
    debugPrint('Set state -> Length: ${contentList.length}');
  }

  bool isExpired = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: contentList.toList(),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                debugPrint('Updated ${contentList.length}');
              });
            },
            child: Text('Refresh'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'databasehelper.dart';

class DebugViewDB extends StatefulWidget {
  const DebugViewDB({super.key});

  @override
  State<DebugViewDB> createState() => _DebugViewDBState();
}

class _DebugViewDBState extends State<DebugViewDB> {
  Future<Widget> createView() async {
    List<Widget> contentList = <Widget>[];
    var value = await DatabaseHelper.instance.queryAll();

    if (value.isEmpty) {
      return const Center(
        child: Text('No Data'),
      );
    }

    contentList.add(const Center(
      child: Text('User List'),
    ));

    debugPrint("value not empty!");
    for (var val in value) {
      debugPrint('Value found ${val['ownerName']}');
      contentList.add(
        Row(
          children: [
            const Text('Name: '),
            Text(val['ownerName']),
          ],
        ),
      );
      contentList.add(
        Row(
          children: [
            const Text('Plate number: '),
            Text(val['plateNum']),
          ],
        ),
      );
      contentList.add(
        Row(
          children: [
            const Text('Model: '),
            Text(val['model']),
          ],
        ),
      );
      contentList.add(
        Row(
          children: [
            const Text('CR number: '),
            Text(val['CRNum']),
          ],
        ),
      );
      contentList.add(
        Row(
          children: [
            const Text('Permit num: '),
            Text(val['permitNum']),
          ],
        ),
      );
      contentList.add(
        Row(
          children: [
            const Text('Is expired: '),
            Text(val['isExpired'] == 1 ? 'Expired' : 'Not Expired'),
          ],
        ),
      );
      contentList.add(const Padding(padding: EdgeInsets.all(5.0)));
    }

    contentList.add(const Center(
      child: Text('Violation List'),
    ));
    contentList.add(const Padding(padding: EdgeInsets.all(5.0)));

    var violation = await DatabaseHelper.instance.queryAllViolation();

    for (var val in violation) {
      debugPrint('Value found ${val['ownerName']}');
      contentList.add(
        Row(
          children: [
            const Text('Name: '),
            Text(val['ownerName']),
          ],
        ),
      );
      contentList.add(
        Row(
          children: [
            const Text('Plate number: '),
            Text(val['plateNum']),
          ],
        ),
      );
      contentList.add(
        Row(
          children: [
            const Text('Model: '),
            Text(val['model']),
          ],
        ),
      );
      contentList.add(
        Row(
          children: [
            const Text('CR number: '),
            Text(val['CRNum']),
          ],
        ),
      );
      contentList.add(
        Row(
          children: [
            const Text('Permit num: '),
            Text(val['permitNum']),
          ],
        ),
      );
      contentList.add(
        Row(
          children: [
            const Text('Date: '),
            Text(val['date']),
          ],
        ),
      );
      contentList.add(
        Row(
          children: [
            const Text('Place of Violation: '),
            Text(val['place']),
          ],
        ),
      );
      contentList.add(
        Row(
          children: [
            const Text('Violation: '),
            Text(val['violation']),
          ],
        ),
      );
      contentList.add(const Padding(padding: EdgeInsets.all(5.0)));
    }

    return Column(
      children: contentList,
    );
  }

  @override
  void initState() {
    super.initState();
    debugPrint('Init state');
  }

  bool isExpired = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          FutureBuilder(
              future: createView(),
              builder: (context, snapshot) {
                return snapshot.requireData;
              }),
        ],
      ),
    );
  }
}

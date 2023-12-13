import 'package:flutter/material.dart';
import 'package:printer/databasehelper.dart';
import 'package:printer/debugdbview.dart';

class DebugDB extends StatefulWidget {
  const DebugDB({super.key});

  @override
  State<DebugDB> createState() => _DebugDBState();
}

class _DebugDBState extends State<DebugDB> {
  bool isExpired = false;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _plateNum = TextEditingController();
  final TextEditingController _model = TextEditingController();
  final TextEditingController _crNum = TextEditingController();
  final TextEditingController _permitNum = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Name: "),
                controller: _name,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Platenum: "),
                controller: _plateNum,
              ),
              TextField(
                decoration: InputDecoration(labelText: "model: "),
                controller: _model,
              ),
              TextField(
                decoration: InputDecoration(labelText: "CRNum: "),
                controller: _crNum,
              ),
              TextField(
                decoration: InputDecoration(labelText: "permitNum: "),
                controller: _permitNum,
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.trailing,
                title: const Text('Is Expired: '),
                value: isExpired,
                onChanged: (value) {
                  setState(() {
                    isExpired = value!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Inserting...');
                  var insert = {
                    'ownerName': _name.text,
                    'plateNum': _plateNum.text,
                    'model': _model.text,
                    'CRNum': _crNum.text,
                    'permitNum': _permitNum.text,
                    'isExpired': isExpired ? 1 : 0,
                  };
                  DatabaseHelper.instance
                      .insert(insert)
                      .then((value) => debugPrint("result: $value"));
                },
                child: const Text('Insert to Database'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DebugViewDB()),
                  );
                },
                child: const Text('View Database'),
              ),
              ElevatedButton(
                onPressed: () {
                  DatabaseHelper.instance.deleteAllEntries();
                },
                child: const Text('Delete All Content'),
              )
            ],
          )
        ],
      ),
    );
  }
}

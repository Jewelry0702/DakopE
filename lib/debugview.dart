import 'package:flutter/material.dart';

class DebugDBView extends StatefulWidget {
  const DebugDBView({super.key});

  @override
  State<DebugDBView> createState() => _DebugDBViewState();
}

class _DebugDBViewState extends State<DebugDBView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Name: "),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Platenum: "),
            ),
            TextField(
              decoration: InputDecoration(labelText: "model: "),
            ),
            TextField(
              decoration: InputDecoration(labelText: "CRNum: "),
            ),
            TextField(
              decoration: InputDecoration(labelText: "permitNum: "),
            ),
            TextField(
              decoration: InputDecoration(labelText: "isExpired: "),
            ),
          ],
        )
      ],
    );
  }
}
